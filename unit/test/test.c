#include <stdio.h>
#include <stdlib.h>
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
unsigned long long add(unsigned long long a, unsigned long long b) {
	return a + b;
}

struct person {
	char* name;
	unsigned short age;
};

struct person* make_person(char* name, unsigned short age) {
	struct person* p = malloc(sizeof(struct person));
	p -> name = name;
	p -> age = age;
	return p;
}