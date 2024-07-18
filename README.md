# auto-error-codes

This library gives you a way to identify any line in your source by a single uint32_t, provided that you know the git commit of the code.
It also makes the first 32 bits of the git hashref available to the code.

## How It Works

1. python script *make_source_ids.py* finds all source files in your project, relative to the root of your project, While doing so it checks:
   1. that there are not too many source files 
   2. that no file has too many lines
   3. (the parameters for project root, maximum files and maximum lines are passed on command line)
2. *make_source_ids.py* assigns an integer ID to each source file and writes to stdout.
3. your build process calls *make_source_ids.py* and sends its output to a text file, before compiling any sources.
4. during compilation, the integer ID of each file is extracted from the sources list and passed to the compiler as #define SOURCE_ID nn
5. the the shortened 32 bit git reference is also passed to the compiler #define GIT_REF_SHORT 0x1234abcd
6. in your source, #include asserts.h (this checks that SOURCE_ID and GIT_REF_SHORT are indeed defined).
7. each ASSERT macro in your code now has the SOURCE_ID and the LINE NUMBER to a single 32 bit number ERROR_REFERENCE
8. **your job** : implement implement/extend ASSERT in your project so that ERROR_REFERENCE and GIT_REF_SHORT are saved to two 32 bit numbers in FLASH or similar.

### Why this exists : Manually defining error codes is not your friend

Many systems maintain a file called something like `ErrorCodes.h` which must be maintained manually by the programmer. However this is **not** a great way of doing things, for several reasons:

- it is prone to human error (for instance codes should be unique but often they are not).
- having to maintain the list manually is a chore and discourages the liberal use of ASSERT.
