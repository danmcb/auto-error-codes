// main.c

#include <stdio.h>
#include "assert.h"

#ifndef GIT_REF_SHORT
  error("not git ref provided!")
#endif

int main(void)
{
  printf("git ref is 0x%x ok!\n", GIT_REF_SHORT);  
  ASSERT_ALWAYS;
}