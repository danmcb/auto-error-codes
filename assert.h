// assert.h

#pragma once

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define __FILENAME__ (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

#define ASSERT(condition)  \
    if (!(condition)) { \
        printf("ASSERT at %s:%d\n", __FILENAME__, __LINE__ ); \
        exit(-1); \
    }


#define ASSERT_ALWAYS ASSERT(0)