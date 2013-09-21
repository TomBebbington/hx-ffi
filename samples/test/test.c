#include <stdlib.h>
struct point {
	float x;
	float y;
};
float fast_sqrt(float number) {
	long i;
	float x2, y;
	const float threehalfs = 1.5F;
	x2 = number * 0.5F;
	y  = number;
	i  = * ( long * ) &y;                       // evil floating point bit level hacking
	i  = 0x5f3759df - ( i >> 1 );               // what the fuck?
	y  = * ( float * ) &i;
	y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
	y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed
	return  1 / y;
}
struct point make_point(float x, float y) {
	struct point p;
	p.x = x;
	p.y = y;
	return p;
}
float point_length(struct point p) {
	return fast_sqrt(p.x * p.x + p.y * p.y);
}