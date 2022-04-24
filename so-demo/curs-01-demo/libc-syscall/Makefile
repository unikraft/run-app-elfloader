LDFLAGS = -static-pie
CFLAGS = -Wall

.PHONY: all clean

all: caller caller-32

caller: caller.o

caller-32: caller-32.o
	$(CC) -m32 -o $@ $^

caller-32.o: caller.c
	$(CC) -m32 -c -o $@ $<

caller.o: caller.c

clean:
	-rm -f *~
	-rm -f caller.o caller
	-rm -f caller-32.o caller-32
	-rm -f a.txt b.txt
