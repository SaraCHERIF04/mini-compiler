#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct qdr{

    char op[100]; 
    char arg1[100];   
    char arg2[100];   
    char result[100];  
    
  }qdr;
  qdr quad[1000];
	
extern int qc;

void quadr(char op[],char arg1[],char arg2[],char result[])
{

	strcpy(quad[qc].op,op);
	strcpy(quad[qc].arg1,arg1);
	strcpy(quad[qc].arg2,arg2);
	strcpy(quad[qc].result,result);
	
	
qc=qc+1;

}

void update_quad(int num_quad, int column_quad, char val[])
{
	switch (column_quad) {
		case 0: strcpy(quad[num_quad].op,val); break;
		case 1: strcpy(quad[num_quad].arg1,val); break;
		case 2: strcpy(quad[num_quad].arg2,val); break;
		case 3: strcpy(quad[num_quad].result,val); break;
	}
}

void print_quad()
{   printf("\n");
	printf("*********************Les Quadruplets***********************\n");
    printf("\n");
	int i;

	for(i=0;i<qc;i++)
	{
		printf("\n %d - ( %s  ,  %s  ,  %s  ,  %s )",i,quad[i].op,quad[i].arg1,quad[i].arg2,quad[i].result); 
		printf("\n--------------------------------------------------------\n");
	}
}
// Function to generate a new temporary variable name
char* newTemp() {
    static int tempCounter = 0; // Static counter to keep track of the number of temporary variables
    
    // Allocate memory for the temporary variable string
    char* tempName = (char*)malloc(10 * sizeof(char));
    
    // Format the temporary variable name as "tX", where X is the counter
    sprintf(tempName, "t%d", tempCounter);
    
    // Increment the counter for the next temporary variable
    tempCounter++;
    
    return tempName;
}
 
