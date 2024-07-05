// main.c

#include <stdio.h>
#include "pathto/some_lib/bad_file.h"

#ifndef GIT_REF_SHORT
  error("not git ref provided!")
#endif

int main(void)
{
  printf("git ref is 0x%x ok!\n", GIT_REF_SHORT);  
  printf("src id of %s is %d\n", __FILE__, SOURCE_ID);
  bad_func();
}