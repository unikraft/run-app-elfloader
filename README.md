# Run App ELF Loader

Run Unikraft ELF loader app on Linux binaries, i.e. binary compatibility mode.
Supported Linux executables must be built using `-static-pie`.

A list of pre-built Linux executables are located in the [`static-pie-apps` repository](https://github.com/unikraft/static-pie-apps).

A pre-built ELF loader app image for KVM is provided in the `app-elfloader_kvm-x86_64` file.
This is used to load and run Linux static PIE ELF files.

Use the `run_elfloader` script to run an ELF file:

```
$ ./run_elfloader ../static-pie-apps/small/socket/call_socket

$ ./run_elfloader ../static-pie-apps/sqlite3/sqlite3
```

The default script options for the script are defined in the `defaults` file.
This file is sourced in the `run_elfloader` script.

To list all script options run it without arguments or with the `-h` argument:

```
$ ./run_elfloader
Start QEMU/KVM for ELF Loader app

./run_elfloader [-h] [-g] [-n] [-r path/to/9p/rootfs] [-k path/to/kvm/image] path/to/exec/to/load [args]
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

```
$ ./run_elfloader -r ../static-pie-apps/sqlite3/rootfs/ ../static-pie-apps/sqlite3/sqlite3
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

```
$ ./run_elfloader -r ../static-pie-apps/redis/rootfs/ -n ../static-pie-apps/redis/redis-server redis.conf

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
This is enabled by the `-g` option of the `run_elfloader` script, together with the use of the `.dbg` image and the `debug.sh` script.

Note that GDB does not load the static PIE ELF's symbols automatically (see [app-elfloader#debugging-elf-apps](https://github.com/unikraft/app-elfloader/blob/lyon-hackathon/README.md#debugging-elf-apps)).
To load those symbols, we need to know the start address which the ELF is loaded to.
Run `run_elfloader` to find the start address:

```
$ ./run_elfloader -k app-elfloader_kvm-x86_64.dbg ../static-pie-apps/lang/c/helloworld
[...]
[    5.241754] dbg:  [appelfloader] <elf_exec.c @   70> [...]/app-elfloader_kvm-x86_64.dbg: start: 0x3fe01000
[...]
```

Here the start address is `0x3fe01000`.

To start a debugging session, run the `run_elfloader` script with the corresponding options:

```
$ ./run_elfloader -g -k app-elfloader_kvm-x86_64.dbg ../static-pie-apps/lang/c/helloworld
```

It will hang waiting for debugging inputs.

On another console start the actual debugging interface by running the `debug.sh` script with the `.dbg` image, the ELF file and it's offset (both required for ELF symbols) as its arguments:

```
ubuntu@vm-11:~/workdir/apps/run-app-elfloader$ ./debug.sh -e ../static-pie-apps/lang/c/helloworld -o 0x3fe01000 app-elfloader_kvm-x86_64.dbg
+ gdb '--eval-command=target remote :1234' -ex 'set confirm off' -ex 'set pagination off' -ex 'hbreak _libkvmplat_start64' -ex 'hbreak _libkvmplat_entry' -ex c -ex disconnect -ex 'set arch i386:x86-64:intel' [...]
[...]
Reading symbols from app-elfloader_kvm-x86_64.dbg...
Remote debugging using :1234
0x000000000000fff0 in ?? ()
Hardware assisted breakpoint 1 at 0x10503f: file /home/unikraft/bin-compat/unikraft.sched-refactor/plat/kvm/x86/entry64.S, line 158.
Hardware assisted breakpoint 2 at 0x106d00: file /home/unikraft/bin-compat/unikraft.sched-refactor/plat/kvm/x86/setup.c, line 261.
Continuing.

Breakpoint 1, _libkvmplat_start64 () at /home/unikraft/bin-compat/unikraft.sched-refactor/plat/kvm/x86/entry64.S:158
158             movq $bootstack, %rsp
Ending remote debugging.
The target architecture is assumed to be i386:x86-64:intel
Remote debugging using localhost:1234
_libkvmplat_start64 () at /home/unikraft/bin-compat/unikraft.sched-refactor/plat/kvm/x86/entry64.S:158
158             movq $bootstack, %rsp
add symbol table from file "../static-pie-apps/lang/c/helloworld" with all sections offset by 0x3fe01000
Reading symbols from ../static-pie-apps/lang/c/helloworld...
(gdb)
```
