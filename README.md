# Run App ELF Loader

Run Linux ELF binaries, i.e. binary compatibility mode, using [`app-elfloader`](https://github.com/unikraft/app-elfloader).
ELFs must be PIE (*position-independent executables*).
Both static and dynamic PIE ELFs are supported.
The common built for Linux distributions is dynamic PIE ELFs.

A list of pre-built Linux executables are located in:

* the [`dynamic-apps` repository](https://github.com/unikraft/dynamic-apps): dynamic ELFs
* the [`static-pie-apps` repository](https://github.com/unikraft/static-pie-apps): static PIE ELFs

Pre-built `app-elfloader` Unikraft images for KVM,  are provided:

* `app-elfloader_kvm-x86_64`: This is the default image.
  It prints out `strace`-like messages for each system call.
* `app-elfloader_kvm-x86_64_plain`: This is the least verbose image, without `strace`-like messages.
* `app-elfloader_kvm-x86_64_full-debug`: This image prints out extensive debugging information, including the `strace`-like messages.
* `app-elfloader_kvm-x86_64_full-debug.dbg`: This is the above image with debugging symbols, used for debugging.
  See more on debugging [below](#running-in-debugging-mode).

Other files are:

* `run_app.sh`: The prime script used to run applications.
  See more in the [`Run Applications` section below](#run-applications).
* `run.sh`: The back end script used to run applications and configure networking, filesystems and debugging.
  See more in the [`Custom Runs` section below](#custom-runs).
* `defaults`: The file with default configuration options used by `run.sh`.
* `scripts/`: Network-configuration scripts used by `run.sh`.
* `rootfs/`: Placeholder directory used as 9pfs root filesystem for applications that don't have a specific one.
* `utils/`, `out/`: Old files that may be removed at some point.

## Run Applications

## Custom Runs

In order to have more control over the running of ELFs, such as configuring networking, filesystems and debugging, use the `run.sh` script:

```console
$ ./run.sh ../static-pie-apps/small/socket/call_socket

$ ./run.sh ../static-pie-apps/sqlite3/sqlite3
```

The default script options for the script are defined in the `defaults` file.
This file is sourced in the `run.sh` script.

To list all script options run it without arguments or with the `-h` argument:

```console
$ ./run.sh
Start QEMU/KVM for ELF Loader app

./run.sh [-h] [-g] [-n] [-r path/to/9p/rootfs] [-k path/to/kvm/image] path/to/exec/to/load [args]
    -h - show this help message
    -g - start in debug mode
    -n - add networking support
    -d - disable KVM
    -r - set path to 9pfs root filesystem
    -k - set path unikraft image
```

### Using a Root Filesystem

The `rootfs/` folder stores the filesystem that will be used by the loaded ELF via 9pfs.
It may require being populated with corresponding files.
The files to be used by each particular ELF file are located in:

* the `rootfs/` subdirectory for application directory for [`static PIE ELFs`](https://github.com/unikraft/static-pie-apps)
* the application directory for [`dynamic ELFs`](https://github.com/unikraft/dynamic-apps)

For example, to run the `sqlite3` static PIE ELF, use:

```console
$ ./run.sh -k app-elfloader_kvm-x86_64_plain -r ../static-pie-apps/sqlite3/rootfs/ ../static-pie-apps/sqlite3/sqlite3
[...]
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
             Epimetheus 0.12.0~5bd4b94d
-- warning: cannot find home directory; cannot read ~/.sqliterc
SQLite version 3.38.2 2022-03-26 13:51:10
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite> .open chinook.db
sqlite> select * from ALBUM limit 5;
1|For Those About To Rock We Salute You|1
2|Balls to the Wall|2
3|Restless and Wild|2
4|Let There Be Rock|1
5|Big Ones|3
sqlite>
```

In the command above, we used the `-k` option to use the `plain` ELF loader image, with minimal debugging information printed.

To run the dynamic `sqlite3` PIE ELF, use:

```console
$ ./run.sh -k app-elfloader_kvm-x86_64_plain -r ../dynamic-apps/sqlite3/ ../dynamic-apps/sqlite3/lib64/ld-linux-x86-64.so.2 /usr/bin/sqlite3
[...]
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
             Epimetheus 0.12.0~5bd4b94d
[    0.800341] CRIT: [appelfloader] <brk.c @   60> Cannot handle multiple user space heaps: Not implemented!
-- warning: cannot find home directory; cannot read ~/.sqliterc
SQLite version 3.22.0 2018-01-22 18:45:57
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite> .open chinook.db
sqlite> select * from ALBUM limit 5;
1|For Those About To Rock We Salute You|1
2|Balls to the Wall|2
3|Restless and Wild|2
4|Let There Be Rock|1
5|Big Ones|3
sqlite>
```

For dynamic ELFs, the ELF Loader loads the Linux dynamic linker / loader (`ld-linux-x86-64.so.2`) that, in its turn, loads the actual dynamic ELF.

### Using Networking

When running a server / network application, networking is required.
The `-n` option creates a bridge (`virbr0`) and runs the specific actions to provide networking support.

You can run a simple dynamic ELF server written in C using:

```console
$ ./run.sh -k app-elfloader_kvm-x86_64_plain -r ../dynamic-apps/lang/c/ ../dynamic-apps/lang/c/lib64/ld-linux-x86-64.so.2 /server
[...]
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
             Epimetheus 0.12.0~5bd4b94d
Listening on port 3333...
```

For a more complex scenario, below is the command to run the dynamic `redis-server` ELF:

```console
$ ./run.sh -k app-elfloader_kvm-x86_64_plain -r ../dynamic-apps/redis/ ../dynamic-apps/redis/lib64/ld-linux-x86-64.so.2 /usr/bin/redis-server /etc/redis/redis.conf
[...]
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
             Epimetheus 0.12.0~5bd4b94d
0:M 09 Apr 18:02:50.068 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
0:M 09 Apr 18:02:50.069 # Redis version=4.0.9, bits=64, commit=00000000, modified=0, pid=0, just started
0:M 09 Apr 18:02:50.071 # Configuration loaded
[    0.173187] ERR:  [libposix_process] <deprecated.c @  348> Ignore updating resource 7: cur = 10032, max = 10032
0:M 09 Apr 18:02:50.075 * Increased maximum number of open files to 10032 (it was originally set to 1024).
0:M 09 Apr 18:02:50.078 # Fatal: Can't initialize Background Jobs.
```

`redis-server` currently block due to some issues with futexes.

### Running in Debugging Mode

It is often the case you want to debug the unikernel running image using a debugger such as GDB.
This is enabled by the `-g` option of the `run.sh` script, together with the use of the `.dbg` image and the `debug.sh` script.

Note that GDB does not load ELF symbols automatically.
To load those symbols, we need to know the start address which the ELF is loaded to.
Run `run.sh` to find the start address and use the `app-elfloader_kvm-x86_64_full-debug` image.
This differs depending on whether running a static PIE ELF or a dynamic ELF.

#### Load Address for Static PIE ELFs

For a static PIE ELF, we need the to know where `app-elfloader` loads the ELF.
So we do a full run of the `..._full-debug` variant of the `app-elfloader` and extract the corresponding debug message:

```console
$ ./run.sh -k app-elfloader_kvm-x86_64_full-debug ../static-pie-apps/lang/c/helloworld
[...]
[    0.351701] Info: [appelfloader] <main.c @  122> ELF program loaded to 0x400101000-0x4001d0860 (850016 B), entry at 0x40010afa0
[...]
```

Here the load address is `0x400101000`.

#### Load Address for Static PIE ELFs

For a dynamic ELF, we need the to know where the Linux dynamic linker / loader loads the dynamic ELF.
Similar to the static case, we do a full run of the `..._full-debug` variant of the `app-elfloader` and extract the corresponding debug message:

```console
$ ./run.sh -k app-elfloader_kvm-x86_64_full-debug -r ../dynamic-apps/lang/c/ ../dynamic-apps/lang/c/lib64/ld-linux-x86-64.so.2 /helloworld
[...]
openat(AT_FDCWD, "/helloworld", O_RDONLY|O_CLOEXEC) = fd:3
read(fd:3, <out>"\x7FELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00>\x00\x01\x00\x00\x00"..., 832) = 832
fstat(fd:3, va:0x40004f650) = OK
mmap(NULL, 2101272, PROT_EXEC|PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, fd:3, 0) = va:0x1000002000
[...]
```

The final `mmap` system call, used to map the `.text` section of the `helloworld` executable (see `PROT_EXEC|PROT_READ`) provides the address for it is loaded: `0x1000002000`.

#### Starting a Debugging Session

To start a debugging session, run the `run.sh` script with the `-g` option.
We show the case for a dynamic ELF, the same would apply for debugging static PIE ELF:

```console
$ ./run.sh -g -k app-elfloader_kvm-x86_64_full-debug -r ../dynamic-apps/lang/c/ ../dynamic-apps/lang/c/lib64/ld-linux-x86-64.so.2 /helloworld
```

It will hang waiting for debugging inputs.

On another console, start the actual debugging interface with GDB by running the `debug.sh` script with the following arguments:

* the path to the ELF being loaded
* the memory address where the ELF is loaded (found above)
* the `.dbg` image of the ELF Loader

```console
$ ./debug.sh -e ../dynamic-apps/lang/c/helloworld -o 0x1000002000 app-elfloader_kvm-x86_64_full-debug.dbg
+ gdb -ex 'set confirm off' -ex 'set pagination off' -ex 'set arch i386:x86-64:intel' -ex 'target remote localhost:1234' -ex 'add-symbol-file ../dynamic-apps/lang/c/helloworld -o 0x10
00002000' -ex 'hbreak _ukplat_entry' -ex continue -ex 'delete 1' app-elfloader_kvm-x86_64_full-debug.dbg
GNU gdb (Ubuntu 10.2-0ubuntu1~18.04~2) 10.2
[...]
Reading symbols from app-elfloader_kvm-x86_64_full-debug.dbg...
The target architecture is set to "i386:x86-64:intel".
Remote debugging using localhost:1234
0x000000000000fff0 in ?? ()
add symbol table from file "../dynamic-apps/lang/c/helloworld" with all sections offset by 0x1000002000
Reading symbols from ../dynamic-apps/lang/c/helloworld...
(No debugging symbols found in ../dynamic-apps/lang/c/helloworld)
Hardware assisted breakpoint 1 at 0x10f790: file /home/razvan/projects/unikraft/scripts/workdir/unikraft/plat/kvm/x86/setup.c, line 300.
Continuing.
Breakpoint 1, _ukplat_entry (lcpu=lcpu@entry=0x210040 <lcpus>, bi=bi@entry=0x1c0148 <bi_bootinfo_sec>) at /home/razvan/projects/unikraft/scripts/workdir/unikraft/plat/kvm/x86/setup.c:300
300             _libkvmplat_init_console();
(gdb)
```

The `./debug.sh` sets a hardware breakpoint at the unikernel entry point (`_ukplat_entry`).
And then it deletes it to make room for other hardware breakpoints.

Note that you need to use hardware breakpoints when first breaking into the newly loaded executable (afterwards you can use simple software breakpoints - using `break`).

When waiting at `_ukplat_entry` you can list the `main` symbols by running `info function main`;
the `main` symbol for the newly loaded executable typically starts with `0x100...` for dynamic ELFs and with `0x400...` for static PIE ELFs.
Use `hbreak` to break.

```console
(gdb) info function main
[...]
Non-debugging symbols:
0x0000001000002615  main
(gdb) hbreak *0x0000001000002615
Hardware assisted breakpoint 2 at 0x1000002615
(gdb) c
Continuing.

Breakpoint 2, 0x0000001000002615 in main ()
(gdb) bt
#0  0x0000001000002615 in main ()
#1  0x0000001000225c87 in ?? ()
#2  0x0000000000008000 in ?? ()
#3  0x000000040004fe50 in ?? ()
#4  0x0000000100000000 in ?? ()
#5  0x0000001000002615 in frame_dummy ()
#6  0x0000000000000000 in ?? ()
(gdb) disass
Dump of assembler code for function main:
=> 0x0000001000002615 <+0>:     push   %rbp
   0x0000001000002616 <+1>:     mov    %rsp,%rbp
   0x0000001000002619 <+4>:     lea    0x94(%rip),%rdi        # 0x10000026b4
   0x0000001000002620 <+11>:    call   0x1000002510 <puts@plt>
   0x0000001000002625 <+16>:    mov    $0x0,%eax
   0x000000100000262a <+21>:    pop    %rbp
   0x000000100000262b <+22>:    ret
End of assembler dump.
(gdb)
```

Typically, you would want to break on different system calls by using `break uk_syscall_r_...` (you can use Tab-Tab to list system call symbols).
