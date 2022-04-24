#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <dirent.h>

#include "utils.h"

static char dentry_type_buffer[256];

static char *get_entry_type(const struct dirent *de)
{
	switch (de->d_type) {
	case DT_BLK:
		strcpy(dentry_type_buffer, "block device");
		break;
	case DT_CHR:
		strcpy(dentry_type_buffer, "character device");
		break;
	case DT_DIR:
		strcpy(dentry_type_buffer, "directory");
		break;
	case DT_FIFO:
		strcpy(dentry_type_buffer, "named pipe (FIFO)");
		break;
	case DT_LNK:
		strcpy(dentry_type_buffer, "symbolic link");
		break;
	case DT_REG:
		strcpy(dentry_type_buffer, "regular file");
		break;
	case DT_SOCK:
		strcpy(dentry_type_buffer, "domain file");
		break;
	default:
		strcpy(dentry_type_buffer, "unknown");
		break;
	}

	return dentry_type_buffer;
}

int main(int argc, char **argv)
{
	char *dirname;
	DIR *dirp;
	struct dirent *de;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s folder-name\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	dirname = argv[1];
	dirp = opendir(dirname);
	DIE(dirp == NULL, "dirname");

	printf("-- Reading directory %s\n\n", dirname);
	while (1) {
		de = readdir(dirp);
		if (de == NULL)
			break;
		printf("%s [%s]\n", de->d_name, get_entry_type(de));
	}

	return 0;
}
