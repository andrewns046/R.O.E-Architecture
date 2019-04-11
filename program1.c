/*
 * CSE141L Custom Architecture Emulator
 *
 * Description: 15 bit FEC encoder/decoder
 * Authors: Andrew Sanchez & Matthew Taylor
 * Date: 4/1/2019
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef unsigned char u_byte;

#define DATA_BITS 11  // number of bits in one word
#define TRANS_BITS 15  // bits transmitted (word + parity)
#define MEM_SIZE 300
#define PART_SIZE 100  // partition size
#define BYTE_MAX 256


/* Format of memory
  - input values [0 - 99]
  - encoded values [100 - 199]
  - decoded values [200 - 299]
*/

u_byte mem [MEM_SIZE];
u_byte tb_mem [MEM_SIZE];
u_byte corr[PART_SIZE];

void printMem( void );
void fec_encode( void );
u_byte xor_bits( u_byte );
int bits_to_buf( char *, int );
int fill_mem( void );
int checkMem( void );

int main( void ) {
  int errors;
  fill_mem();
  fec_encode();
  if( (errors = checkMem()) > 0 ) {
    fprintf(stderr ,"\nNum Errors: %d", errors);
  } else {
    printf("\nNum Errors: %d\tAll Tests Passed!", errors);
  }
  return 0;
}

/*Show memory on console*/
void printMem( void ) {
  int i;
  printf("\nMemory Results\n");
  printf("=========================\n");
  for( i = (MEM_SIZE - 1); i >= 0; i--)
    printf("mem[%d] = 0x%.2X\n", i, mem[i]);

  printf("\nTest Bench Memory Results\n");
  printf("=========================\n");
  for( i = (MEM_SIZE - 1); i >= 0; i--)
      printf("tb_mem[%d] = 0x%.2X\n", i, tb_mem[i]);
}

/*Forward Error Code (encoding algorithm)*/
void fec_encode( void ) {
  int i;

  u_byte par_bit8;
  u_byte par_bit4;
  u_byte par_bit2;
  u_byte par_bit1;

  for(i = 0; i < PART_SIZE; i = i + 2) {
    //fec encoding algorithm
    mem[i+PART_SIZE+1] = (mem[i+1] << 4) | (mem[i] >> 4);

    par_bit8 = xor_bits( mem[i+PART_SIZE+1] );
    par_bit4 = xor_bits( ((mem[i] & 0x0E) >> 1) | ((mem[i] & 0x80) >> 4) |
                         (mem[i+1] << 4) );
    par_bit2 = xor_bits( ((mem[i+1] & 0x06 ) << 5) |
                         ((mem[i] & 0x60) >> 1) | (mem[i] & 0x0D));
    par_bit1 = xor_bits( ((mem[i+1] & 0x04) << 5) |
                         ((mem[i+1] & 0x01) << 6) | ((mem[i] & 0x40) >> 1) |
                         (mem[i] & 0x10) | (mem[i] & 0x0B));
    mem[i+PART_SIZE] = ( ((par_bit8 << 4) << 3) | ((mem[i] & 0x0E) << 3) |
                                    (par_bit4 << 3) | ((mem[i] & 0x01) << 2) |
                                    (par_bit2 << 1) | (par_bit1) );
  }
}


/* Compares test bench memory with memory our algorithms generated*/
int checkMem( void ){
  int i, num_errs = 0;

  printf("\n**************\nError Summary\n**************\n");
  for( i < 0; i < MEM_SIZE; i++) {
    if( mem[i] != tb_mem[i] ) {
      fprintf( stderr, "Error at mem[%d]\tresult: 0x%.2X\texpected: 0x%.2X\n", i, mem[i], tb_mem[i]);
      num_errs++;
    }
  }

  return num_errs;

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

/* Takes transcript from verilog file and fills mem with input and tb_mem with
correct resutls for comparing later */
int fill_mem( void ) {
  FILE *fp;
  char buf[100];

  if ( (fp = fopen("prog1_2_results.txt", "rb")) == NULL ) {
    fprintf( stderr,"Could not open file");
    exit(1);
  }

  //read from system verilog transcript file
  int i = 0;
  while ( fgets(buf, 100, fp) != NULL ) {
    bits_to_buf(buf, i);
    i+=2;
  }

  fclose(fp);
  return 0;
}

/* takes bits in string form then converts and stores them in
 * more useful buffers
 * return: number of bits stored
 */
int bits_to_buf( char * bit_str, int indx) {
  int n;
  u_byte mem1, mem0;
  mem1 = mem0 = 0x00;

  //data_in conversion
  for(n = 0; n < 3; n++) {
    if( bit_str[n] == '1' ) {
      mem1 = (mem1 | 0x01);
    }
    if( n < 2 ) {
      mem1 <<= 1;
    }
  }
  for(n = 3; n < 11; n++) {
    if( bit_str[n] == '1' ) {
      mem0 = (mem0 | 0x01);
    }
    if( n < 10 ) {
      mem0 <<= 1;
    }
  }

  //fill input buffers
  tb_mem[indx] = mem0;
  tb_mem[indx+1] = mem1;
  mem[indx] = mem0;
  mem[indx+1] = mem1;

  mem0 = mem1 = 0x00;

  // data_sent conversion
  for( n = 12; n < 19; n++) {
    if( bit_str[n] == '1' ) {
      mem1 = (mem1 | 0x01);
    }
    if( n < 18 ) {
      mem1 <<= 1;
    }
  }
  for(n = 19; n < 27; n++) {
    if( bit_str[n] == '1' ) {
      mem0 = (mem0 | 0x01);
    }
    if( n < 26 ) {
      mem0 <<= 1;
    }
  }

  //fill expected encoded results buffer
  tb_mem[indx+100] = mem0;
  tb_mem[indx+100+1] = mem1;
  mem0 = mem1 = 0x00;

  // corruption conversion
  for( n = 28; n < 35; n++) {
    if( bit_str[n] == '1' ) {
      mem1 = (mem1 | 0x01);
    }
    if( n < 34 ) {
      mem1 <<= 1;
    }
  }
  for(n = 35; n < 43; n++) {
    if( bit_str[n] == '1' ) {
      mem0 = (mem0 | 0x01);
    }
    if( n < 42 ) {
      mem0 <<= 1;
    }
  }

  // fill corrupted bits buffer
  corr[indx] = mem0;
  corr[indx+1] = mem1;

  // decoded conversion
  for(n = 44; n < 47; n++) {
    if( bit_str[n] == '1' ) {
      mem1 = (mem1 | 0x01);
    }
    if( n < 46 ) {
      mem1 <<= 1;
    }
  }
  for(n = 47; n < 55; n++) {
    if( bit_str[n] == '1' ) {
      mem0 = (mem0 | 0x01);
    }
    if( n < 54 ) {
      mem0 <<= 1;
    }
  }

  //fill decoded result buffer
  tb_mem[indx+(PART_SIZE*2)] = mem0;
  tb_mem[indx+(PART_SIZE*2)+1] = mem1;

  return n;
}
