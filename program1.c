/*
 * CSE141L Custom Architecture Emulator
 *
 * Description: 15 bit FEC encoder/decoder
 * Authors: Andrew Sanchez & Matthew Taylor
 * Date: 4/1/2019
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef unsigned char u_byte;

#define MEM_SIZE 255
#define UPPER_LIMIT 255

u_byte mem [MEM_SIZE];

void fillMem( void );
void printMem( void );
void fec_encode( void );
u_byte xor_bits( u_byte );

int main( void ) {
  //use current time as seed for random generator
  srand(time(0));

  fillMem();
  printMem();
  fec_encode();
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
void fec_encode( void ) {
  //original memory
  u_byte mem1 = 0x07;
  u_byte mem0 = 0xEE;

  //encoded memory
  u_byte new_mem1 = 0x00;
  u_byte new_mem0 = 0x00;

  //fec encoding algorithm
  new_mem1 = (mem1 << 4) | (mem0 >> 4);

  //parity bits
  u_byte par_bit8 = xor_bits( new_mem1 );
  u_byte par_bit4 = xor_bits( (mem0 << 3) | (mem0 >> 4) | (mem1) );
  u_byte par_bit2 = xor_bits( (mem0 << 4) | ((mem0 >> 4) >> 1) | (mem1 << 1));
  u_byte par_bit1 = xor_bits( (mem0 >> 4) | ( mem0 << 4) | (mem1 << 1) );

  new_mem0 = ( (~par_bit8) + 0x01) | ((mem0 & 0x0E) << 3) |
             (par_bit4 << 4) | ((mem0 & 0x01) << 3) |
             (par_bit2 << 2) | (par_bit1);

  printf("Encoding Results:\n\nmem[1]= 0x%.2X \nmem[0]= 0x%.2X", new_mem1, new_mem0);
}

/*XOR all bits in byte NOTE: it's communinative and associative*/
u_byte xor_bits( u_byte byte ) {
  u_byte result = 0;
  while (byte) {
    result ^= byte & 1;
    byte >>= 1;
  }
  return result;
}
