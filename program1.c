#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef unsigned char u_byte;

#define MEM_SIZE 60
#define UPPER_LIMIT 255

u_byte mem [MEM_SIZE];

void fillMem( void );
void printMem( void );

int main( void ) {
  //use current time as seed for random generator
  srand(time(0));

  fillMem();
  printMem();
  return 0;
}

/* Fills half of the memory with 11 bit data sequences */
void fillMem( void ) {
  int i;

  for( i = 0; i < MEM_SIZE/2; i++)
    mem[i] = rand() % (UPPER_LIMIT + 1);

  //pad odd [1-29] with 5 preceeding zeros
  for( i = 1; i < MEM_SIZE/2; i+=2)
    mem[i] = mem[i]>>5;
}

/*Show memory on console*/
void printMem( void ) {
  int i;
  printf("\nMemory Results\n");
  printf("=========================\n");
  for( i = (MEM_SIZE - 1); i >= 0; i--)
    printf("mem[%d] = 0x%.2X\n", i, mem[i]);
}

/*Forward Error Code (encoding algorithm)*/
