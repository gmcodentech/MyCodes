#include<stdio.h>
long long unsigned get_total(long long int no){
	
	long long unsigned total = 0;
	for(long int i=0;i<=no; i++){
		total += i;
	}
	return total;
}
int main(){
	int n;
	printf("Enter a no:");
	scanf("%d",&n);
	printf("Hello from C and thanks for entering %llu",get_total(n));
	return 0;
}