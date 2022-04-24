CC = gcc
CPPFLAGS = -I../utils
CFLAGS = -Wall -Wextra -g -fno-stack-protector -fPIC
LDFLAGS = -static-pie

.PHONY: all clean

all: run-shellcode run-shellcode-32 inject-shellcode inject-shellcode-32

run-shellcode: run-shellcode.o

run-shellcode-32: run-shellcode-32.o
	$(CC) $(LDFLAGS) -m32 -o $@ $^

run-shellcode-32.o: run-shellcode.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m32 -c -o $@ $<

inject-shellcode: inject-shellcode.o
	$(CC) $(LDFLAGS) -z execstack -o $@ $^

inject-shellcode-32: inject-shellcode-32.o
	$(CC) $(LDFLAGS) -m32 -z execstack -o $@ $^

inject-shellcode-32.o: inject-shellcode.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m32 -c -o $@ $<

clean:
	-rm -f run-shellcode.o run-shellcode
	-rm -f run-shellcode-32.o run-shellcode-32
	-rm -f inject-shellcode.o inject-shellcode
	-rm -f inject-shellcode-32.o inject-shellcode-32
	-rm -f *~
