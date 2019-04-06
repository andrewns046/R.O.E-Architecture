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
#define ENCODE_MEM_SIZE 60
#define K 30

u_byte mem [MEM_SIZE];

void fillMem( void );
void printMem( void );
void fec_encode( void );
u_byte xor_bits( u_byte );

int main( void ) {
  //use current time as seed for random generator
  srand(time(0));

  fillMem();
  fec_encode();
  printMem();
  return 0;
}

/* Fills half of the memory with 11 bit data sequences */
void fillMem( void ) {
  int i;

  for( i = 0; i < ENCODE_MEM_SIZE/2; i++)
    mem[i] = rand() % (MEM_SIZE + 1);

  //pad odd [1-29] with 5 preceeding zeros
  for( i = 1; i < ENCODE_MEM_SIZE/2; i+=2)
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
  int i;

  u_byte par_bit8;
  u_byte par_bit4;
  u_byte par_bit2;
  u_byte par_bit1;

  for(i = 0; i < (ENCODE_MEM_SIZE/2); i++) {
    //fec encoding algorithm
    mem[i+K+1] = (mem[i+1] << 4) | (mem[i] >> 4);

    par_bit8 = xor_bits( mem[i+K+1] );
    par_bit4 = xor_bits( ((mem[i] & 0x0E) >> 1) | (((mem[i] & 0x80) >> 4) >> 1) |
                         (mem[i+1] << 4) );
    par_bit2 = xor_bits( ((mem[i+1] & 0x06 ) << 4) |
                         ((mem[i] & 0x60) >> 2) | ((mem[i] & 0x0C) >> 1) |
                         (mem[i] & 0x01) );
    par_bit1 = xor_bits( ((mem[i+1] & 0x04) << 4) |
                         ((mem[i+1] & 0x01) << 5) | ((mem[i] & 0x40) >> 2) |
                         ((mem[i] & 0x10) >> 1) | ((mem[i] & 0x08) >> 1) |
                         (mem[i] & 0x03) );

    mem[i+K] = ( ((par_bit8 << 4) << 4) | ((mem[i] & 0x0E) << 3) |
                                    (par_bit4 << 4) | ((mem[i] & 0x01) << 3) |
                                    (par_bit2 << 2) | (par_bit1) );
  }
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
