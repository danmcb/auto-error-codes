// test file for function that asserts

#include "../../assert.h"
#include <stdio.h>

void bad_func(void)
{
    printf("your bad code is here at source id %d, after line %d\n", SOURCE_ID, __LINE__);
    ASSERT_ALWAYS;
}
