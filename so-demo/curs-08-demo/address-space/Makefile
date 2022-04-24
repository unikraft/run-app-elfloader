LDFLAGS = -static-pie
CC = gcc
CPPFLAGS = -I../utils
CFLAGS = -Wall -Wextra -Wno-unused -Wno-unused-parameter -g
LDLIBS = -lpthread

.PHONY: all clean

all: address-space

address-space: address-space.o

address-space.o: address-space.c ../utils/utils.h

clean:
	-rm -f *.o *~ address-space
