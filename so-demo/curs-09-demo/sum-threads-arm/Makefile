CC = arm-linux-gnueabi-gcc
CPPFLAGS = -I../utils
CFLAGS = -Wall -Wextra -Wno-unused -Wno-unused-parameter -fPIC -g
LDFLAGS = -static-pie
LDLIBS = -lpthread

.PHONY: all clean

all: sum_threads sum_threads_atomic

sum_threads: sum_threads.o

sum_threads.o: sum_threads.c ../utils/utils.h

sum_threads_atomic: sum_threads_atomic.o

sum_threads_atomic.o: sum_threads.c ../utils/utils.h
	$(CC) $(CPPFLAGS) -DUSE_ATOMIC $(CFLAGS) -c -o $@ $<

clean:
	-rm -f *~
	-rm -f sum_threads.o sum_threads
	-rm -f sum_threads_atomic.o sum_threads_atomic
