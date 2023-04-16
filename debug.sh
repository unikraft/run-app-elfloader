#!/bin/sh

usage()
{
    echo "Debug QEMU/KVM with ELF Loader app" 1>&2
    echo ""
    echo "$0 [-e elf -o offset] path/to/kvm/image" 1>&2
    echo "    -h - show this help message" 1>&2
    echo "    -e - set path to ELF app" 1>&2
    echo "    -o - start address of the ELF app" 1>&2
    exit 1
}

while getopts "he:o:" OPT; do
    case ${OPT} in
        h)
            usage
            ;;
        e)
            elf=${OPTARG}
            ;;
        o)
            offset=${OPTARG}
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

kvm_image="$1"
shift

if test ! -z ${elf+x} && test ! -z ${offset+x}; then
    add_symbol_file="add-symbol-file $elf -o $offset"
elif test ! -z ${elf+x}; then
    echo "ELF provided without offset"
    exit 1
elif test ! -z ${offset+x}; then
    echo "offset provided without ELF"
    exit 1
else
    add_symbol_file=""
fi

# This is the default debug port used by QEMU.
debug_port="1234"

# Show script commands when run.
set -x

# Start GDB and use a hardware breakpoint at `_ukplat_entry`.
# After waiting at `_ukplat_entry`, delete hardware breakpoint to
# make room for others.
# Note that you need to use hardware breakpoints when first breaking into
# the newly loaded executable (afterwards you can use simple software
# breakpoints - using `break`).
#
# When waiting at `_ukplat_entry` you can list the `main` symbols by
# running `info function main`; the `main` symbol for the newly loaded
# executable typically starts with `0x400...`; you can make a connection
# with the `__libc_start_main` symbol. Use `hbreak` to break.
#
# Sample run:
# ```
# (gdb) info function main
# [...]
# Non-debugging symbols:
# [...]
# 0x000000040010b089  main
# 0x000000040010b430  __libc_start_main
# [...]
# (gdb) hbreak *0x000000040010b089
# Hardware assisted breakpoint 2 at 0x40010b089
# (gdb) c
# Continuing.
#
# Breakpoint 2, 0x000000040010b089 in main ()
# [...]
# ```
#
# Typically, you would want to break on different system calls by using
# `b uk_syscall_r_...` (you can use Tab-Tab to list system call symbols).
#
# If you want to add further breakpoints from the start, update the gdb
# command below with entries such as:
#   -ex "hbreak lwip_socket" \
#   -ex "hbreak lwip_setsockopt" \

gdb -ex "set confirm off" -ex "set pagination off" \
    -ex "set arch i386:x86-64:intel" \
    -ex "target remote localhost:$debug_port" \
    -ex "$add_symbol_file" \
    -ex "hbreak _ukplat_entry" \
    -ex "continue" \
    -ex "delete 1" \
    "$kvm_image"
