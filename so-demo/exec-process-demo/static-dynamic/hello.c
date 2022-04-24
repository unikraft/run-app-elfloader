#include <stdio.h>

static void wait_for_input(const char *msg)
{
	char buf[32];

	printf(" * %s\n", msg);
	printf(" -- Press ENTER to continue ...\n"); fflush(stdout);
	fgets(buf, 32, stdin);
}

int main(void)
{
	wait_for_input("Hello, world!");
	return 0;
}
