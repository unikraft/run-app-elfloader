#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include "utils.h"

int main(void)
{
	size_t i, j;
	size_t val = 0x12345678;

	for (i = 0; i < 100; i++) {
		val = val ^ i;
		for (j = 0; j < 100; j++)
			write(STDOUT_FILENO, "a", 1);
		sleep(3);
	}

	return 0;
}
