// J Gonzalez
// June 30, 2018
// gen.c
// Licensed under the terms of the AGPLv3

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define AMOUNT     500000
#define SYMBOLS    64
#define BASESYM    '!'
#define FILLER     'a'

typedef char collidable[21];

int main(int argc, char** argv) {
  collidable* buffer = (collidable*)malloc(sizeof(collidable) * AMOUNT);

  memset(buffer, FILLER, AMOUNT * sizeof(collidable));

  #pragma clang loop vectorize(enable)
  for (uint32_t i = 0; i < AMOUNT; i++) {
    uint32_t a = i >> 0;
    uint32_t b = i >> 4;
    uint32_t c = i >> 8;
    uint32_t d = i >> 12;
    uint32_t e = i >> 16;

    a %= SYMBOLS;
    b %= SYMBOLS;
    c %= SYMBOLS;
    d %= SYMBOLS;
    e %= SYMBOLS;

    a += BASESYM;
    b += BASESYM;
    c += BASESYM;
    d += BASESYM;
    e += BASESYM;

    buffer[i][12] = a;
    buffer[i][13] = b;
    buffer[i][14] = c;
    buffer[i][15] = d;
    buffer[i][16] = e;
  }

  FILE* out = fopen("output.dmp", "wb");
  fwrite(buffer, sizeof(collidable), AMOUNT, out);
  fclose(out);

  return 0;
}
