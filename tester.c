#include <stdio.h> 

int main() {
	printf("_MSC_VER:%d sizeof_intptr:%d\n", _MSC_VER, (int) sizeof(int*));

	return 0;
}
