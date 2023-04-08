# Run App ELF Loader

Run Unikraft ELF loader app on Linux binaries, i.e. binary compatibility mode, using [`app-elfloader`](https://github.com/unikraft/app-elfloader).
Supported Linux executables must be built using `-static-pie`.

A list of pre-built Linux executables are located in the [`static-pie-apps` repository](https://github.com/unikraft/static-pie-apps).

A pre-built ELF loader app image for KVM is provided in the `app-elfloader_kvm-x86_64` file.
This is used to load and run Linux static PIE ELF files.

Use the `run.sh` script to run an ELF file:

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

## Using a root filesystem

The `rootfs/` folder stores the filesystem that will be used by the loaded ELF via 9pfs.
It may require being populated with corresponding files.
The files to be used by each particular ELF file are located in the [`static-pie-apps` repository](https://github.com/unikraft/static-pie-apps) in the `rootfs/` folder foe each application.
These need to be copied to be used.

For example, to run the `sqlite3` executable using the ELF loader, use:

```console
$ ./run.sh -r ../static-pie-apps/sqlite3/rootfs/ ../static-pie-apps/sqlite3/sqlite3
[...]
qemu-system-x86_64: warning: host doesn't support requested feature: CPUID.80000001H:ECX.svm [bit 2]
SeaBIOS (version 1.13.0-1ubuntu1.1)
Booting from ROM..Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                    Mimas 0.7.0~ba3796e
-- warning: cannot find home directory; cannot read ~/.sqliterc
SQLite version 3.38.2 2022-03-26 13:51:10
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite> .open chinook.db
sqlite> select * from album limit 10;
1|For Those About To Rock We Salute You|1
2|Balls to the Wall|2
3|Restless and Wild|2
4|Let There Be Rock|1
5|Big Ones|3
6|Jagged Little Pill|4
7|Facelift|5
8|Warner 25 Anos|6
9|Plays Metallica By Four Cellos|7
10|Audioslave|8
sqlite>
```

## Using networking

When running a server / network application, networking is required.
The `-n` option creates a bridge (`uk0`) and runs the specific actions to provide networking support.

Below is the command to run the `redis-server` application with the ELF Loader.

```console
$ ./run.sh -r ../static-pie-apps/redis/rootfs/ -n ../static-pie-apps/redis/redis-server redis.conf

Creating bridge uk0 if it does not exist ...
Adding IP address 172.44.0.1 to bridge uk0 ...
SeaBIOS (version 1.13.0-1ubuntu1.1)


iPXE (http://ipxe.org) 00:03.0 C000 PCI2.10 PnP PMM+7FF8C7D0+7FECC7D0 C000



Booting from ROM..1: Set IPv4 address 172.44.0.2 mask 255.255.255.0 gw 172.44.0.1
en1: Added
en1: Interface is up
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
            Mimas 0.7.0~1e17a9c8-custom
<jemalloc>: Error in munmap(): Invalid argument
<jemalloc>: Error in munmap(): Invalid argument
<jemalloc>: Error in munmap(): Invalid argument
<jemalloc>: Error in munmap(): Invalid argument
<jemalloc>: Error in munmap(): Invalid argument
<jemalloc>: Error in munmap(): Invalid argument
<jemalloc>: Error in munmap(): Invalid argument
<jemalloc>: Error in munmap(): Invalid argument
<jemalloc>: Error in munmap(): Invalid argument
0:M 12 May 2022 20:39:17.049 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
0:M 12 May 2022 20:39:17.052 # Redis version=6.2.6, bits=64, commit=f1c63fe7, modified=0, pid=0, just started
0:M 12 May 2022 20:39:17.057 # Configuration loaded
[    0.160656] ERR:  [libposix_process] <deprecated.c @  368> Ignore updating resource 7: cur = 10032, max = 10032
0:M 12 May 2022 20:39:17.065 * Increased maximum number of open files to 10032 (it was originally set to 1024).
0:M 12 May 2022 20:39:17.070 * monotonic clock: POSIX clock_gettime
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis 6.2.6 (f1c63fe7/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 0
  `-._    `-._  `-./  _.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |           https://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
      `-._    `-.__.-'    _.-'
          `-._        _.-'
              `-.__.-'

0:M 12 May 2022 20:39:17.133 # Server initialized
0:M 12 May 2022 20:39:17.136 # Warning: can't mask SIGALRM in bio.c thread: Success
0:M 12 May 2022 20:39:17.140 # Warning: can't mask SIGALRM in bio.c thread: Success
0:M 12 May 2022 20:39:17.143 # Warning: can't mask SIGALRM in bio.c thread: Success
<jemalloc>: Error in dlsym(RTLD_NEXT, "pthread_create"). Cannot enable background_thread
0:M 12 May 2022 20:39:17.152 # Fatal error loading the DB: Operation not permitted. Exiting.
```

## Running in debugging mode

It is often the case you want to debug the unikernel running image using a debugger such as GDB.
This is enabled by the `-g` option of the `run.sh` script, together with the use of the `.dbg` image and the `debug.sh` script.

Note that GDB does not load the static PIE ELF's symbols automatically (see [app-elfloader#debugging-elf-apps](https://github.com/unikraft/app-elfloader/blob/lyon-hackathon/README.md#debugging-elf-apps)).
To load those symbols, we need to know the start address which the ELF is loaded to.
Run `run.sh` to find the start address and use the `app-elfloader_kvm-x86_64_full-debug` image:

```console
$ ./run.sh -k app-elfloader_kvm-x86_64_full-debug ../static-pie-apps/lang/c/helloworld
[...]
[    0.351701] Info: [appelfloader] <main.c @  122> ELF program loaded to 0x400101000-0x4001d0860 (850016 B), entry at 0x40010afa0
[...]
```

Here the start address is `0x400101000`.

To start a debugging session, run the `run.sh` script with the corresponding arguments:

```console
$ ./run.sh -g -k app-elfloader_kvm-x86_64_full_debug ../static-pie-apps/lang/c/helloworld
```

It will hang waiting for debugging inputs.

On another console, start the actual debugging interface by running the `debug.sh` script with the following arguments:

* the path to the ELF being loaded
* the memory address where the ELF is loaded (found above)
* the `.dbg` image of the ELF Loader

```console
$ ./debug.sh -e ../static-pie-apps/lang/c/helloworld -o 0x400101000 app-elfloader_kvm-x86_64_full-debug.dbg
+ gdb -ex 'set confirm off' -ex 'set pagination off' -ex 'set arch i386:x86-64:intel' -ex 'target remote localhost:1234' -ex 'add-symbol-file ../static-pie-apps/lang/c/helloworld -o 0
x400101000' -ex 'hbreak _ukplat_entry' -ex continue -ex 'delete 1' app-elfloader_kvm-x86_64_full-debug.dbg

add symbol table from file "../static-pie-apps/lang/c/helloworld" with all sections offset by 0x400101000
Reading symbols from ../static-pie-apps/lang/c/helloworld...
(No debugging symbols found in ../static-pie-apps/lang/c/helloworld)
Hardware assisted breakpoint 1 at 0x10f780: file /workdir/unikraft/plat/kvm/x86/setup.c, line 296.
Continuing.

Breakpoint 1, _ukplat_entry (lcpu=lcpu@entry=0x200c40 <lcpus>, bi=bi@entry=0x1b3e68 <bi_bootinfo_sec>) at /workdir/unikraft/plat/kvm/x86/setup.c:296
296     /workdir/unikraft/plat/kvm/x86/setup.c: No such file or directory.
(gdb)
```

The `./debug.sh` sets a hardware breakpoint at the unikernel entry point (`_ukplat_entry`).
And then it deletes it to make room for other hardware breakpoints.

Note that you need to use hardware breakpoints when first breaking into the newly loaded executable (afterwards you can use simple software breakpoints - using `break`).

When waiting at `_ukplat_entry` you can list the `main` symbols by running `info function main`;
the `main` symbol for the newly loaded executable typically starts with `0x400...`;
you can make a connection with the address of the `__libc_start_main` symbol.
Use `hbreak` to break.

```console
(gdb) info function main
[...]
Non-debugging symbols:
[...]
0x000000040010b089  main
0x000000040010b430  __libc_start_main
[...]
(gdb) hbreak *0x000000040010b089
Hardware assisted breakpoint 2 at 0x40010b089
(gdb) c
Continuing.

Breakpoint 2, 0x000000040010b089 in main ()
(gdb) bt
#0  0x000000040010b089 in main ()
#1  0x000000040010b8c0 in __libc_start_main ()
#2  0x000000040010afce in _start ()
```

Typically, you would want to break on different system calls by using `break uk_syscall_r_...` (you can use Tab-Tab to list system call symbols).
