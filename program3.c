/*
 * CSE141L Custom Architecture Emulator
 *
 * Description: Where's Waldo
 * Authors: Andrew Sanchez & Matthew Taylor
 * Date: 4/10/2019
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MEM_SIZE 64
#define PAT_SIZE 4
#define BYTES_IN_STR 8

typedef unsigned char u_byte;

u_byte pat = 0x0B;  //1011
u_byte bit_str1[BYTES_IN_STR];
u_byte bit_str2[BYTES_IN_STR];
u_byte bit_str3[BYTES_IN_STR];
u_byte bit_str4[BYTES_IN_STR];
u_byte bit_str5[BYTES_IN_STR];

void init_bitstr( void );

int main() {
  init_bitstr();
  return 0;
}

/* initialize bit strings of the algorithm */
void init_bitstr( void ) {
  int i;
  for (i = 0; i < BYTES_IN_STR; i++) {
    bit_str1[i] = bit_str2[i] = bit_str3[i] = bit_str4[i] = bit_str5[i] = 0x00;
  }
  bit_str2[1] = bit_str3[1] = bit_str4[1] = bit_str5[1] = 0xB0;
  bit_str3[2] = bit_str4[2] = bit_str5[2] = 0xBB;
  bit_str4[4] = bit_str5[4] = 0xC0;
  bit_str4[5] = bit_str5[5] = 0x02;
  bit_str5[7] = 0xBB;

  printf("\n************************MESSAGES**************************");
  printf("\nbit_str1:");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str1[i]);
  }
  printf("\nbit_str2:");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str2[i]);
  }
  printf("\nbit_str3:");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str3[i]);
  }
  printf("\nbit_str4:");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str4[i]);
  }
  printf("\nbit_str5:");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str5[i]);
  }
  printf("\n************************MESSAGES**************************\n");
}
