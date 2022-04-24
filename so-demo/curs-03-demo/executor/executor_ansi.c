#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"


#ifndef BUFSIZ
#define BUFSIZ		256
#endif

static char buffer[BUFSIZ];

int main(void)
{
	FILE *f;

	/* Create process channel: to read from child process. */
	f = popen("./printer", "r");
	DIE(f == NULL, "popen");

	/* Read and print message from process. */
	fgets(buffer, BUFSIZ, f);
	printf("I read from child process: %s", buffer);

	/* Close process. */
	pclose(f);

	return 0;
}
