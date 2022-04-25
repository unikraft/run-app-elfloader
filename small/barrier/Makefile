LDFLAGS = -static-pie
CC = gcc
CPPFLAGS = -I../utils
CFLAGS = -Wall -Wextra -Wno-unused -Wno-unused-parameter -g
LDLIBS = -lpthread

.PHONY: all clean

all: barrier

barrier: barrier.o

barrier.o: barrier.c ../utils/utils.h

clean:
	-rm -f barrier barrier.o
	-rm -f *~
