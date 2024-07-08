// assert.h

#pragma once

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef SOURCE_ID
  #error SOURCE_ID is not defined (the source file that includes this file should have been found by make_source_ids.py)
#endif

#define ERROR_CODE (( SOURCE_ID << 16 ) + __LINE__ )

#define __FILENAME__ (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

// this macro should be re-written for yur system to :
// 1. store ERROR_CODE in FLASH if possible
// 2. notify the dev or user in a suitable way
// 3. make the system safe (up to you to decide what that means)
#define ASSERT(condition)  \
    if (!(condition)) { \
        printf("ASSERT at %s:%d - ERROR_CODE is 0x%08x\n", __FILENAME__, __LINE__, ERROR_CODE ); \
        exit(-1); \
    }

#define ASSERT_ALWAYS ASSERT(0)
