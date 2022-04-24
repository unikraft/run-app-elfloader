/**
  * Variables in process address space viewed with objdump
  */
#include <stdlib.h>

int var_a;
int var_b = 2;
char var_c[] = "so";

int main(void)
{
	int var_d;
	static int var_e;
	char *var_f = "rulz";
	char *var_g = malloc(10);

	return 0;
}
