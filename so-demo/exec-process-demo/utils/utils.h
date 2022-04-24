/**
 * SO, 2011
 * Lab #3, Procese
 *
 * Useful structures/macros
 */

#ifndef LIN_UTILS_H_
#define LIN_UTILS_H_	1

#include <stdio.h>
#include <stdlib.h>

/* useful macro for handling error codes */
#define DIE(assertion, call_description)				\
	do {								\
		if (assertion) {					\
			fprintf(stderr, "(%s, %d): ",			\
					__FILE__, __LINE__);		\
			perror(call_description);			\
			exit(EXIT_FAILURE);				\
		}							\
	} while(0)

#endif
