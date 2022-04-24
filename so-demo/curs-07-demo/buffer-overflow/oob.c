#include <stdio.h>
#include <string.h>

char buffer[128];
char secret[] = "p422w0rd";

int main(void)
{
	size_t n;

	strcpy(buffer, "Hello, World!");
	printf("n = ");
	scanf("%zu", &n);

	printf("0x%02hhx (%c)\n", buffer[n], buffer[n]);

	return 0;
}
