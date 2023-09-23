#!/bin/sh

. ./defaults

usage()
{
    echo "Start QEMU/KVM for ELF Loader app" 1>&2
    echo ""
    echo "$0 [-h] [-g] [-n] [-i] [-r path/to/9p/rootfs] [-k path/to/unikernel/image] path/to/exec/to/load [args]" 1>&2
    echo "    -h - show this help message" 1>&2
    echo "    -g - start in debug mode" 1>&2
    echo "    -n - add networking support" 1>&2
    echo "    -i - use initial ramdisk for loading executable" 1>&2
    echo "    -d - disable KVM" 1>&2
    echo "    -r - set path to 9pfs root filesystem" 1>&2
    echo "    -k - set path unikraft image" 1>&2
    exit 1
}

setup_networking()
{
    # Configure bridge interface.
    echo "Creating bridge $bridge_iface if it does not exist ..."
    ip -d link show "$bridge_iface" 2> /dev/null | tail -1 | grep bridge > /dev/null 2>&1
    if test $? -ne 0; then
        sudo ip address flush dev "$bridge_iface" > /dev/null 2>&1
        sudo ip link del dev "$bridge_iface" > /dev/null 2>&1
        sudo ip link add "$bridge_iface" type bridge > /dev/null 2>&1
    fi

    echo "Adding IP address $bridge_ip to bridge $bridge_iface ..."
    sudo ip address flush dev "$bridge_iface"
    sudo ip address add "$bridge_ip"/"$netmask_prefix" dev "$bridge_iface"
    sudo ip link set dev "$bridge_iface" up

    # Create setup folder if it doesn't exist.
    if test ! -d "$PWD/setup"; then
        rm -fr "$PWD/setup"
        mkdir "$PWD/setup"
    fi

    # Configure network setup scripts.
    cat > "$net_up_script" <<END
#!/bin/sh
sudo ip link set dev "\$1" up
sudo ip link set dev "\$1" master "$bridge_iface"
END

    cat > "$net_down_script" <<END
#!/bin/sh

sudo ip link set dev "\$1" nomaster
sudo ip link set dev "\$1" down
END

    chmod a+x setup/up
    chmod a+x setup/down
}

use_kvm=1
use_networking=0
use_initrd=0
start_in_debug_mode=0

while getopts "dhngik:r:" OPT; do
    case ${OPT} in
        n)
            use_networking=1
            ;;
        d)
            use_kvm=0
            ;;
        h)
            usage
            ;;
        k)
            kvm_image=${OPTARG}
            ;;
        r)
            rootfs_9p=${OPTARG}
            ;;
        g)
            start_in_debug_mode=1
            ;;
        i)
            use_initrd=1
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if test "$#" -lt 1; then
    usage
fi

exec_to_load="$1"

arguments="-m 2G -nographic -nodefaults "
arguments="${arguments}-display none -serial stdio -device isa-debug-exit "
arguments="${arguments}-fsdev local,security_model=none,id=hvirtio0,path=$rootfs_9p "
arguments="${arguments}-device virtio-9p-pci,fsdev=hvirtio0,mount_tag=fs1 "
arguments="${arguments}-kernel $kvm_image "

# If using initial ramdisk, load the executable into ramdisk.
if test "$use_initrd" -eq 1; then
    arguments="${arguments}-initrd $exec_to_load "
    shift
fi

if test "$use_kvm" -eq 1; then
    file="/dev/kvm"
    if ! [ -c "$file" ]; then
      echo "$file does not exist, cannot run with KVM" 1>&2
      exit 1
    fi

    # Check if the effective user has RW permission to /dev/kvm,
    # if they haven't, temporarily add the user to the group that owns
    # /dev/kvm, by default the KVM group. If that also fails, run QEMU
    # as root, but with the -runas parameter to drop privileges.
    if ! [ -r "$file" ] || ! [ -w "$file" ]; then
        group_owner=$(stat -c "%G" $file)
        if [ "$(stat -c "%A" $file | cut -c 5-6)" = "rw" ] && ! [ "$group_owner" = "$(id -un 0)" ];
        then
            sudo_prefix="sudo -g $group_owner -- "
        else
            sudo_prefix="sudo "
            arguments="${arguments}-runas $USER "
        fi
    fi

    arguments="${arguments}-enable-kvm -cpu host "
else
    arguments="${arguments}-cpu ${cpu_model} "
fi

if test "$start_in_debug_mode" -eq 1; then
    arguments="${arguments}-s -S "
fi

if test "$use_networking" -eq 1; then
    setup_networking
    arguments="${arguments}-netdev tap,id=hnet0,vhost=off,script=$net_up_script,downscript=$net_down_script -device virtio-net-pci,netdev=hnet0,id=net0 "
    arguments="${arguments}-append \"$net_args -- $*\" "
else
    arguments="${arguments}-append \"$*\" "
fi

# Start QEMU VM.
echo "Running command: "
echo "${sudo_prefix}"qemu-system-x86_64 "$arguments" | sed 's/ -/\n-/g' | sed 's/^/\t/'
echo ""
eval "${sudo_prefix}"qemu-system-x86_64 "$arguments"
