#CPPFLAGS = -DDEBUG -DLOG_LEVEL=LOG_DEBUG
CFLAGS = -Wall -Wextra -Wno-unused-parameter -g

.PHONY: all clean

build: all

all: epoll-server server sendfile-server threaded-server

epoll-server: epoll-server.o sock-util.o

server: server.o sock-util.o

sendfile-server: sendfile-server.o sock-util.o

threaded-server: threaded-server.o sock-util.o
	$(CC) $(LDFLAGS) -o $@ $^ -lpthread

epoll-server.o: epoll-server.c sock-util.h debug.h util.h

server.o: server.c sock-util.h debug.h util.h

sendfile-server.o: sendfile-server.c sock-util.h debug.h util.h

threaded-server.o: threaded-server.c sock-util.h debug.h util.h

sock-util.o: sock-util.c sock-util.h debug.h util.h

clean:
	-rm -f *~
	-rm -f *.o
	-rm -f epoll-server server sendfile-server threaded-server
