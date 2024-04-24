#include<stdio.h> 
#include<conio.h> 
int main(void){ 
    char password[15]; 
  
    printf("password: "); 
    int p=0; 
    do{ 
        password[p]=getch(); 
        if(password[p]!='\r'){ 
            printf("*"); 
        } 
        p++; 
    }while(password[p-1]!='\r'); 
    //password[p-1]='&#092;&#048;'; 
    printf("\npassword %s ",password); 
    getch(); 
} 