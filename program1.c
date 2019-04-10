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

#define MEM_SIZE 256
#define ENCODE_MEM_SIZE 60
#define K 30

u_byte mem [MEM_SIZE];

void fillMem( void );
void printMem( void );
void fec_encode( void );
void fec_decode( int choice );
u_byte xor_bits( u_byte );

int main( void ) {
  //use current time as seed for random generator
  srand(time(0));

  fillMem();
  printf("Original memory: 0x%.2X%.2X\n", mem[1], mem[0]);
  fec_encode();
  printf("Encoded memory: 0x%.2X%.2X\n", mem[31], mem[30]);
  // printMem();
  fec_decode(2);
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

  for(i = 0; i < (ENCODE_MEM_SIZE/2); i = i + 2) {
    //fec encoding algorithm
    mem[i+K+1] = (mem[i+1] << 4) | (mem[i] >> 4);
    printf("mem[%i] = %.2X = (%.2X << 4) | (%.2X >> 4)\n",i+K+1,mem[i+K+1],mem[i+1],mem[i]);
    par_bit8 = xor_bits( mem[i+K+1] );
    par_bit4 = xor_bits( ((mem[i] & 0x0E) >> 1) | ((mem[i] & 0x80) >> 4) |
                         (mem[i+1] << 4) );
    par_bit2 = xor_bits( ((mem[i+1] & 0x06 ) << 5) |
                         ((mem[i] & 0x60) >> 1) | (mem[i] & 0x0D));
    par_bit1 = xor_bits( ((mem[i+1] & 0x04) << 5) |
                         ((mem[i+1] & 0x01) << 6) | ((mem[i] & 0x40) >> 1) |
                         (mem[i] & 0x10) | (mem[i] & 0x0D));

    mem[i+K] = ( ((par_bit8 << 4) << 3) | ((mem[i] & 0x0E) << 3) |
                                    (par_bit4 << 3) | ((mem[i] & 0x01) << 2) |
                                    (par_bit2 << 1) | (par_bit1) );
  }
}

void fec_corruptor( void ) {

    //TODO

}

void fec_decode( int choice ) {

    u_byte encMem1;
    u_byte encMem0;
    switch(choice){

      case 0:
        // these are uncorrupted test values
        encMem1 = 0x1D;
        encMem0 = 0x4F;
        break;
      case 1:
        // this is a corrupted version of the above
        encMem1 = 0x3D;
        encMem0 = 0x4F;
        break;
      case 2:
        // Grab one encoded message from fec_encode for validation
        encMem1 = mem[1+K];
        encMem0 = mem[0+K];
        break;
    }

    u_byte decMem0 = 0x00;
    u_byte decMem1 = 0x00;

    // Counter for error bits, lower 4 indicate error position after algorithm
    u_byte err_pos = 0x00;

    // Get error bit 8 with value d11^d10^d9^d8^d7^d6^d5^p8
    // and add to position counter
    u_byte err_bit8 = xor_bits((encMem1 << 1) | (encMem0 >> 7));
    printf("Err_bit8: %i\n", err_bit8);
    err_pos = err_pos^err_bit8;
    err_pos = err_pos << 1;

    // Get error bit 4 with value d11^d10^d9^d8^d4^d3^d2^p4
    // and add to position counter
    u_byte err_bit4 =  xor_bits(((encMem1 >> 3) << 4 )|((encMem0 << 1) >> 4));
    printf("Err_bit4: %i\n", err_bit4);
    err_pos = err_pos^err_bit4;
    err_pos = err_pos << 1;

    // Get error bit 2 with value d11^d10^d7^d6^d4^d3^d1^p2
    u_byte err_bit2 = xor_bits(((encMem1 & 0x60) << 1)|((encMem1 & 0x06) << 3)|
                              ((encMem0 & 0x60) >> 2)|((encMem0 & 0x06) >> 1));
    printf("Err_bit2: %i\n", err_bit2);
    err_pos = err_pos^err_bit2;
    err_pos = err_pos << 1;

    // Get error bit 1 with value d11^d9^d7^d5^d4^d2^d1^p1
    // Trying different strategy without masks
    u_byte err_bit1 = 0x00;
    //places d11
    err_bit1 = err_bit1 | ((encMem1 >> 6) << 7);
    //places d9
    err_bit1 = err_bit1 | (((encMem1 >> 4) << 7) >> 1);
    //places d7
    err_bit1 = err_bit1 | (((encMem1 >> 2) << 7) >> 2);
    //places d5
    err_bit1 = err_bit1 | ((encMem1 << 7) >> 3);
    //places d4
    err_bit1 = err_bit1 | (((encMem0 << 1) >> 7) << 3);
    //places d2
    err_bit1 = err_bit1 | (((encMem0 << 3) >> 7) << 2);
    //places d1
    err_bit1 = err_bit1 | (((encMem0 << 5) >> 7) << 1);
    //places p1
    err_bit1 = err_bit1 | ((encMem0 << 7) >> 7);
    //xors all bits to get error bit
    err_bit1 = xor_bits(err_bit1);

    printf("Err_bit1: %i\n", err_bit1);

    err_pos = err_pos^err_bit1;

    printf("Error position: %i\n",err_pos);
    // If there is an error, correct it before ripping out the data bits
    if(err_pos != 0){
      // Need to figure out way to determine if error position is in upper (gt 8)
      // or in lower (lte 8) byte

      // Adjust err_pos for binary location (0 index)
      err_pos = err_pos - 1;

      // Subtract 8 from err_pos
      err_pos = err_pos - 8;

      // Now the error position overflows if it was between 8 and 1 originally
      // and does not if it was between 15 and 9
      u_byte byte_determiner = err_pos & 0x80;
      byte_determiner = byte_determiner >> 7;

      // Should be 1 if lower byte, 0 if upper
      if(byte_determiner != 0){
        err_pos = err_pos + 8;
        u_byte err_mask = 0x1 << err_pos;
        encMem0 = encMem0 ^ err_mask;
      } else {
        u_byte err_mask = 0x1 << err_pos;
        encMem1 = encMem1 ^ err_mask;
      }
    }

    // Now comes stitching the data back together
    // Places 0 0 0 0 0 d11 d10 d9 in decMem1
    decMem1 = decMem1 | (encMem1 >> 4);

    // Places d8 d7 d6 d5 in upper 4 bits of lower byte
    decMem0 = decMem0 | (encMem1 << 4);

    // Places d4 d3 d2 0 in lower 4 bits of lower byte
    decMem0 = decMem0 | (((encMem0 << 1) >> 5) << 1);

    // Places d1 in LSB of lower byte
    decMem0 = decMem0 | ((encMem0 << 5) >> 7);

    // Now decMem1 decMem0 should be the original data, print test
    printf("Decoded memory: 0x%.2X%.2X\n", decMem1, decMem0);
}
/*XOR all bits in byte NOTE: it's communicative and associative*/
u_byte xor_bits( u_byte byte ) {
  u_byte result = 0;
  while (byte) {
    result ^= byte & 1;
    byte >>= 1;
  }
  return result;
}
