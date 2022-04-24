LDFLAGS = -static-pie
CC = gcc
CPPFLAGS = -I../utils
CFLAGS = -Wall -Wextra -g

.PHONY: all clean

all: yield

yield: yield.o

yield.o: yield.c ../utils/utils.h

clean:
	-rm -f *.o *~ yield
