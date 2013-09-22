#include <stdio.h>
int get_cool_int() {
	return 1337;
}
void* get_null() {
	return 0;
}
char* get_cool_str() {
	return "Oranges";
}
void print_str(const char* str) {
	printf("%s", str);
}