// test file for function that asserts

#include "../../assert.h"
#include <stdio.h>

void bad_func(void)
{
    printf("your bad code is right here\n");
    ASSERT_ALWAYS;
}
