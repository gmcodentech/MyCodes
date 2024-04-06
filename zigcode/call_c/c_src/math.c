#include "math.h"

int add_two(int a, int b){
	return a + b;
}

long long unsigned get_total(long long int no){
	
	long long unsigned total = 0;
	for(long int i=0;i<=no; i++){
		total += i;
	}
	return total;
}