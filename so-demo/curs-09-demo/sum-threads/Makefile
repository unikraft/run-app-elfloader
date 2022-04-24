CC = gcc
CPPFLAGS = -I../utils
CFLAGS = -Wall -Wextra -Wno-unused -Wno-unused-parameter -fPIC -g
LDFLAGS = -static-pie
LDLIBS = -lpthread

.PHONY: all clean

all: sum_threads sum_threads_atomic sum_threads_32 sum_threads_atomic_32 \
	sum_threads_32_longlong sum_threads_atomic_32_longlong

sum_threads: sum_threads.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

sum_threads.o: sum_threads.c ../utils/utils.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

sum_threads_atomic: sum_threads_atomic.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

sum_threads_atomic.o: sum_threads.c ../utils/utils.h
	$(CC) $(CPPFLAGS) -DUSE_ATOMIC $(CFLAGS) -c -o $@ $<

sum_threads_32: sum_threads_32.o
	$(CC) $(LDFLAGS) -m32 -o $@ $^ $(LDLIBS)

sum_threads_32.o: sum_threads.c ../utils/utils.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -m32 -c -o $@ $<

sum_threads_atomic_32: sum_threads_atomic_32.o
	$(CC) $(LDFLAGS) -m32 -o $@ $^ $(LDLIBS)

sum_threads_atomic_32.o: sum_threads.c ../utils/utils.h
	$(CC) $(CPPFLAGS) -DUSE_ATOMIC $(CFLAGS) -m32 -c -o $@ $<

sum_threads_32_longlong: sum_threads_32_longlong.o
	$(CC) $(LDFLAGS) -m32 -o $@ $^ $(LDLIBS)

sum_threads_32_longlong.o: sum_threads.c ../utils/utils.h
	$(CC) $(CPPFLAGS) -DUSE_LONGLONG $(CFLAGS) -m32 -c -o $@ $<

sum_threads_atomic_32_longlong: sum_threads_atomic_32_longlong.o
	$(CC) $(LDFLAGS) -m32 -o $@ $^ $(LDLIBS)

sum_threads_atomic_32_longlong.o: sum_threads.c ../utils/utils.h
	$(CC) $(CPPFLAGS) -DUSE_ATOMIC -DUSE_LONGLONG $(CFLAGS) -m32 -c -o $@ $<
clean:
	-rm -f *~
	-rm -f sum_threads.o sum_threads
	-rm -f sum_threads_atomic.o sum_threads_atomic
	-rm -f sum_threads_32.o sum_threads_32
	-rm -f sum_threads_atomic_32.o sum_threads_atomic_32
	-rm -f sum_threads_32_longlong.o sum_threads_32_longlong
	-rm -f sum_threads_atomic_32_longlong.o sum_threads_atomic_32_longlong
