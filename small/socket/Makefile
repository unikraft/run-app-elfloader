CFLAGS = -Wall -fPIC
LDFLAGS = -static-pie

.PHONY: all clean

all: call_socket

call_socket: call_socket.o

call_socket.o: call_socket.c

clean:
	-rm -f call_socket call_socket.o
	-rm -f *~
