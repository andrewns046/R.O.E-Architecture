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
#define MEM_SIZE 256
#define PART_SIZE 100  // partition size
#define BYTE_MAX 256
#define ENCODE_MEM_SIZE 60
#define K 30

u_byte mem [MEM_SIZE];
u_byte tb_mem [MEM_SIZE];
u_byte corr[PART_SIZE];

void printMem( void );
void fec_encode( void );
void fec_decode( u_byte use_corrupted_memory );
void fec_corruptor( void );
u_byte xor_bits( u_byte );
int bits_to_buf( char *, int );
int fill_mem( void );
void checkMem( void );

int main( void ) {
  fill_mem();
  fec_encode();
<<<<<<< HEAD
  //fec_corruptor();
  //fec_decode( 1 );
=======
  // fec_corruptor();
  // fec_decode( 1 );
>>>>>>> 81fbff59489e8180056ef005c0cfeb317907a7a2
  printMem();
  checkMem();
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

  printf("\nCorruption\n");
  printf("=========================\n");
  for( i = (PART_SIZE - 1); i >= 0; i--)
      printf("corr[%d] = 0x%.2X\n", i, corr[i]);
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

void fec_corruptor( void ) {
    int i;
    int corrupted_start_mem = 64;
    for(i = 0; i < (ENCODE_MEM_SIZE/2); i = i + 2){
      u_byte encMem1 = mem[i+1+K];
      u_byte encMem0 = mem[i+K];

      u_byte corMem1;
      u_byte corMem0;

      int cor_pos = rand() % 15;
      if(cor_pos > 7){
        corMem1 = encMem1 ^ (0x01 << cor_pos - 8);
        corMem0 = encMem0;
        mem[corrupted_start_mem + i + 1] = corMem1;
        mem[corrupted_start_mem + i] = corMem0;
      } else {
        corMem1 = encMem1;
        corMem0 = encMem0  ^ (0x01 << cor_pos);
        mem[corrupted_start_mem + i + 1] = corMem1;
        mem[corrupted_start_mem + i] = corMem0;
      }
    }

}

void fec_decode( u_byte use_corrupted_memory ) {

    u_byte encMem1;
    u_byte encMem0;
    int i;
    int decoded_mem_start_offset = 94;

    int encoded_mem_start_offset;
    if(use_corrupted_memory){
      encoded_mem_start_offset = 64;
    } else {
      encoded_mem_start_offset = K;
    }

    for(i = 0; i < (ENCODE_MEM_SIZE/2); i = i + 2){
        encMem1 = mem[i+1+encoded_mem_start_offset];
        encMem0 = mem[i+encoded_mem_start_offset];
        u_byte decMem0 = 0x00;
        u_byte decMem1 = 0x00;

        // Counter for error bits, lower 4 indicate error position after algorithm
        u_byte err_pos = 0x00;

        // Get error bit 8 with value d11^d10^d9^d8^d7^d6^d5^p8
        // and add to position counter
        u_byte err_bit8 = xor_bits((encMem1 << 1) | (encMem0 >> 7));
        err_pos = err_pos^err_bit8;
        err_pos = err_pos << 1;

        // Get error bit 4 with value d11^d10^d9^d8^d4^d3^d2^p4
        // and add to position counter
        u_byte err_bit4 =  xor_bits(((encMem1 >> 3) << 4 )|((encMem0 & 0x7F) >> 3));
        err_pos = err_pos^err_bit4;
        err_pos = err_pos << 1;

        // Get error bit 2 with value d11^d10^d7^d6^d4^d3^d1^p2
        u_byte err_bit2 = xor_bits(((encMem1 & 0x60) << 1)|((encMem1 & 0x06) << 3)|
                                  ((encMem0 & 0x60) >> 3)|((encMem0 & 0x06) >> 1));

        err_pos = err_pos^err_bit2;
        err_pos = err_pos << 1;

        // Get error bit 1 with value d11^d9^d7^d5^d4^d2^d1^p1
        // Trying different strategy without masks
        u_byte err_bit1 = 0x00;
        //temp variable to avoid C implicit cast
        u_byte temp = 0x00;
        //places d11
        err_bit1 = err_bit1 | ((encMem1 >> 6) << 7);
        //places d9
        // Need to store result of this shift before shifting right, because
        // C will implicitly cast to an int and keep the upper bits we want
        // to shear off.
        temp = ((encMem1 >> 4) << 7);
        err_bit1 = err_bit1 | ( temp >> 1);

        //places d7
        // Same issue as before
        temp = ((encMem1 >> 2) << 7);
        err_bit1 = err_bit1 | ( temp >> 2);

        //places d5
        // Same issue as before
        temp = (encMem1 << 7);
        err_bit1 = err_bit1 | ( temp >> 3);

        //places d4
        // Same issue as before
        // Bugged?
        temp = (encMem0 << 1);
        err_bit1 = err_bit1 | (( temp >> 7) << 3);

        //places d2
        // Same issue as before
        temp = (encMem0 << 3);
        err_bit1 = err_bit1 | (( temp >> 7) << 2);

        //places d1
        // Same issue as before
        temp = (encMem0 << 5);
        err_bit1 = err_bit1 | (( temp >> 7) << 1);

        //places p1
        // Same issue as before
        temp = (encMem0 << 7);
        err_bit1 = err_bit1 | ( temp >> 7);

        //xors all bits to get error bit
        err_bit1 = xor_bits(err_bit1);


        err_pos = err_pos^err_bit1;

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
        // Same issue with shifting as before
        temp = (encMem0 << 1);
        decMem0 = decMem0 | ((temp >> 5) << 1);

        // Places d1 in LSB of lower byte
        // Same issue with shifting as before
        temp = (encMem0 << 5);
        decMem0 = decMem0 | (temp >> 7);

        // Now decMem1 decMem0 should be the original data, print test
        mem[decoded_mem_start_offset + i + 1] = decMem1;
        mem[decoded_mem_start_offset + i] = decMem0;
    }

}

void checkMem( void ){
  int i;
  int decoded_mem_start_offset = 94;
  for(i = 0; i < (ENCODE_MEM_SIZE/2); i = i + 2){
    if(mem[i+1] != mem[decoded_mem_start_offset + 1 + i] || mem[i] != mem[decoded_mem_start_offset + i]){
      printf("Some decoded memory did not match the original memory: i = %i!\n",i);
      return;
    }
  }
  printf("Everything looks good my dude\n");
  return;
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

  corr[indx] = mem0;
  corr[indx+1] = mem1;

  return n;
}
