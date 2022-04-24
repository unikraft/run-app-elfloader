LDFLAGS = -static-pie
CC = gcc
CPPFLAGS = -I../utils
CFLAGS = -Wall -Wextra -g

.PHONY: all clean

all: cpu

cpu: cpu.o

cpu.o: cpu.c ../utils/utils.h

clean:
	-rm -f *.o *~ cpu *.txt
