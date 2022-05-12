#!/bin/bash

if test $# -ne 1; then
    echo "Usage: $0 path/to/kvm_image" 1>&2
    exit 1
fi

kvm_image="$1"

# This is the default debug port used by QEMU.
debug_port="1234"

# Show script commands when run.
set -x

# If you want to add further breakpoints from the start, update the gdb
# command below with entries such as:
#   -ex "hbreak lwip_socket" \
#   -ex "hbreak lwip_setsockopt" \

gdb --eval-command="target remote :$debug_port" -ex "set confirm off" -ex "set pagination off" \
    -ex "hbreak _libkvmplat_start64" \
    -ex "hbreak _libkvmplat_entry" \
    -ex "c" \
    -ex "disconnect" -ex "set arch i386:x86-64:intel" \
    -ex "target remote localhost:$debug_port" "$kvm_image"
