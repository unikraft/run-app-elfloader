CFLAGS = -Wall -fPIC
LDFLAGS = -static-pie

.PHONY: all clean

all: hello-static hello-dynamic

hello-static: hello.o
	$(CC) $(LDFLAGS) -static -o $@ $^

hello-dynamic: hello.o
	$(CC) $(LDFLAGS) -o $@ $^

hello.o: hello.c

clean:
	-rm -f hello.o hello-static hello-dynamic
	-rm -f *~
