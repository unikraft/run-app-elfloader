# App ELF Loader Tests

Test Unikraft ELF loader app to run Linux binaries, i.e. binary compatibility mode.

The `so-demo/` folder stores source code from the Operating Systems class at UPB.
Enter the folder and build the binaries using `make_all`.

The list of executables is in the `so_demo_exec_list` file.
Run the binaries using:

```
./run_all so_demo_exec_list
```

Results are summarized in the `so_demo.out` file.
