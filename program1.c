#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef unsigned char u_byte;

#define MEM_SIZE 255
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
void fec_encode() {
  //original memory
  u_byte mem1 = 0x07;
  u_byte mem0 = 0xAA;

  //masks used for bit manipulation
  u_byte mask1 = 0x0F;  // 00001111

  //encoded memory
  u_byte new_mem1 = 0x00;
  u_byte new_mem0 = 0x00;

  //parity bits
  parity_bit8_mask = 0x80;
  parity_bit

  //fec encoding algorithm
  new_mem1 = (mem1 & mask1) << 4;
  //create parity bit 8 here
  new_mem1 = (mem0 >> 4) | new_mem1;

  printf("Encoding Results:\n\nmem[1]= 0x%.2X \nmem[0]= 0x%.2X", new_mem1, new_mem0);

}
