# auto-error-codes
No more maintaining lists of error codes. This library:

1. creates a 32 bit integer which identifies your file and line number as a 32 bit int called ERROR_CODE.
2. has a trivial demo project with a sample ASSERT implementation which uses ERROR_CODE.
3. makes the first 32 bits of the git reference available to the source code.
4. suggests ways to use these feature in your project to simplify your error handling.

## Assert Assert Assert!

No serious embedded project should be without proper error handling, a.k.a. ASSERT handlers. A good ASSERT handler should do something like the following:

1. In development : show the dev that an error has occurred and where (file and line number). (Typically debug/error print.)
2. Development and production : store the error location to non-volatile storage (typically on-board FLASH).
3. Put the system into a known safe state, and (possibly) signal the issue to the dev/user (flashing red lights or similar).
4. Try to safely recover from the error (perhaps a reboot).

The exact implementation of these steps depends heavily on the application and risks/consequences of failure, but error handling is ALWAYS a primary part of system design and can never be ignored.

A scheme which works well on many modern microcontrollers is to have a dedicated area of FLASH where failure records are kept, which is checked and reported on boot. Because FLASH is a slow write device and the system could be in an unstable state on faolire, it is good if the stored error code is small.

This small library allows the location of an error (the FILE and LINE NUMBER) to be stored as a single 32 bit integer. This is done using a script to create integer SOURCE IDS for all sources in the project, and a simple pre-processor macro. It also makes the first 32 bits of the git reference available as a processor define, which should also be stored in FLASH when the sustem is forst programmed.

Modifications to the Makefile are needed to support this mechanism. A sample Makefile and simple demo project are provided.

### Manually defining error codes is not your friend

Many systems maintain a file called something like `ErrorCodes.h` which must be maintained manually by the programmer. However this is **not** a great way of doing things, for several reasons:

- it is prone to human error (for instance codes should be unique but often they are not).
- having to maintain the list manually is a pain, and discourages the liberal use of ASSERT.

## How This Library Works

1. python script *make_source_ids.py* finds all source files in your project, relative to the root of your project, While doing so it checks:
   1. that there are not too many source files 
   2. that no file has too many lines
   3. (the parameters for project root, maximum files and maximum lines are passed on command line)
2. *make_source_ids.py* assigns an integer ID to each source file
3. you add rules to your Makefile so that your build your project is built, *make_source_ids.py* is called and its output sent to the sources list text file (before compiling sources)
4. as each source is compiled, the integer ID of each file is extracted from the sources list and passed to the compiler as compiler flag SOURCE_ID
5. the the shortened 32 bit git reference is also passed to the compiler as a flag GIT_REF_SHORT
6. when you include asserts.h, this checks that SOURCE_ID and GIT_REF_SHORT are defined
7. each ASSERT macro in your code combines the SOURCE_ID and the LINE NUMBER to a single 32 bit number ERROR_REFERENCE
8. **your job** : implement implement/extend ASSERT in your project so that ERROR_REFERENCE and GIT_REF_SHORT are saved to two 32 bit numbers in FLASH or similar.



