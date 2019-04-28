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

void init_bitstr( u_byte*, u_byte*, u_byte*, u_byte*, u_byte* );
int cnt_bytes( u_byte , u_byte* );
int cnt_occur( u_byte, u_byte* );
int cnt_occur2( u_byte, u_byte* );

int main() {
  u_byte bit_str1[BYTES_IN_STR];
  u_byte bit_str2[BYTES_IN_STR];
  u_byte bit_str3[BYTES_IN_STR];
  u_byte bit_str4[BYTES_IN_STR];
  u_byte bit_str5[BYTES_IN_STR];

  u_byte pat = 0x0B;  // pattern 1011

  init_bitstr(bit_str1, bit_str2, bit_str3, bit_str4, bit_str5);
  printf("\n************************RESULTS**************************\n");
  printf("bit_str1\t%d\t%d\t%d\n", cnt_bytes(pat, bit_str1), cnt_occur(pat, bit_str1), cnt_occur2(pat, bit_str1));
  printf("bit_str2\t%d\t%d\t%d\n", cnt_bytes(pat, bit_str2), cnt_occur(pat, bit_str2), cnt_occur2(pat, bit_str2));
  printf("bit_str3\t%d\t%d\t%d\n", cnt_bytes(pat, bit_str3), cnt_occur(pat, bit_str3), cnt_occur2(pat, bit_str3));
  printf("bit_str4\t%d\t%d\t%d\n", cnt_bytes(pat, bit_str4), cnt_occur(pat, bit_str4), cnt_occur2(pat, bit_str4));
  printf("bit_str5\t%d\t%d\t%d\n", cnt_bytes(pat, bit_str5), cnt_occur(pat, bit_str5), cnt_occur2(pat, bit_str5));
  printf("\n************************RESULTS**************************\n");

  return 0;
}

/*
 * Returns number of bytes in which pattern occurs in memory
 */
int cnt_bytes( u_byte pat, u_byte* str) {
  int i, j, cnt = 0;  //byte count
  u_byte buf, temp;

  for(i=(BYTES_IN_STR-1); i >= 0; i--) {
    buf = str[i];
    //continue till pattern detected or whole byte searched
    for(j = 0; j < 5; j++ ) {
      temp = buf^pat;
      temp <<= 4;
      //printf("%.2X\n", temp);
      if( temp == 0x00 ) {  //pattern found
        ++cnt;
      }
      buf >>= 1;
    }
  }
  return cnt;
}

int cnt_occur( u_byte pat, u_byte* str){
  int i, j, cnt = 0;  //byte count
  u_byte buf, temp;
  pat <<= 4; // adjust pattern
  //printf("%.2X\n", pat);

  //init pipeline

  buf = str[BYTES_IN_STR-1];
  //continue till pattern detected or whole byte searched
  for(j = 0; j < 5; j++ ) {
    temp = buf^pat;
    temp >>= 4;
    //printf("loop1%.2X\n", temp);
    if( temp == 0x00 ) {  //pattern found
      ++cnt;
    }
    if(j < 4) buf <<= 1;
  }

  for(i=(BYTES_IN_STR-2); i >= 0; i--) {

    //import upper half of str[i-1]
    buf = buf | (str[i] >> 4);
    buf <<= 1;

    for(j = 0; j < 4; j++ ) {
      temp = buf^pat;
      temp >>= 4;
      //printf("loop2%.2X\n", temp);
      if( temp == 0x00 ) {  //pattern found
        ++cnt;
      }
      if(j < 3) buf <<= 1;
    }

    //import lower half of str[i-1]
    buf = (buf | (str[i] & 0x0F));
    buf <<= 1;

    for(j = 0; j < 4; j++ ) {
      temp = buf^pat;
      temp >>= 4;
      //printf("loop3%.2X\n", temp);
      if( temp == 0x00 ) {  //pattern found
        ++cnt;
      }
      if(j < 3) buf <<= 1;
    }
  }
  return cnt;
}

/*This one is the one that does not cross byte boundaries*/
int cnt_occur2( u_byte pat, u_byte* str) {
  int i, j, cnt = 0;  //byte count
  u_byte buf, temp;
  int pat_det;

  for(i=(BYTES_IN_STR-1); i >= 0; i--) {
    buf = str[i];
    j = 0;
    pat_det = 0;
    //continue till pattern detected or whole byte searched
    while( (pat_det == 0) && (j < 5) ) {
      temp = buf^pat;
      temp <<= 4;
      if( temp == 0x00 ) {  //pattern found
        ++cnt;
        pat_det = 1;
      }
      buf >>= 1;
      j++;
    }
  }
  return cnt;
}

/* initialize bit strings of the algorithm */
void init_bitstr( u_byte* bit_str1, u_byte* bit_str2, u_byte* bit_str3, u_byte* bit_str4, u_byte* bit_str5 ) {
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
  printf("\nbit_str1");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str1[i]);
  }
  printf("\nbit_str2");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str2[i]);
  }
  printf("\nbit_str3");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str3[i]);
  }
  printf("\nbit_str4");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str4[i]);
  }
  printf("\nbit_str5");
  for(i = (BYTES_IN_STR-1); i > 0; i--) {
    printf("\t%.2X", bit_str5[i]);
  }
  printf("\n************************MESSAGES**************************\n");
}
