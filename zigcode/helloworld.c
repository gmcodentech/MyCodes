#include "stdio.h"
#include "conio.h"
#include "stdlib.h"
void read_string(){
	char *name;
	printf("\n Enter your name: ");
	scanf("%s",name);
	printf("Hello %s",name);
}
int main(){
	system("cls");
	printf("Hello world!");
	char c = getche();
	printf("\n%c",c);
	read_string();
	return 0;
}