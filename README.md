# auto-error-codes
No more maintaining lists of error codes : compress build/file/line to a 32 bit int and use it in your asserts and error handlers. Especially useful for embedded systems development.

## Assert Assert Assert!

No serious embedded project should be without proper error handling, a.k.a. ASSERT handlers. A good ASSERT handler should do the following:

1. try to store a persistent record of the location/cause of the problem to non-volatile storage (typically on-board FLASH)
2. put the system into a known safe state, and (possibly) signal the issue t the user (flashing red lights or similar).
3. attempt to safely recover from the error (what this really means is system-specific but let's assume a reboot).

A dedicated area should exist in storage where records of failures is kept and this should be checked and (if necessary) reported on boot.

Implementation of such handlers, with appropriate behaviour for both production and development environments, should be amongst the earliest functions implemented in any project. This encourages programmers to use ASSERT liberally *(A Very Good Thing)* and can be a serious aid in finding more bugs sooner.

### Manually Maintained Error Codes

Many systems maintain a file called something like `error_codes.h` which contains a long list of codes which must be maintained manually by the programmer. However this is **not** a great way of doing things, for several reasons:

- it is prone to human error (for instance codes should be unique but sometimes are not).
- having to maintain the list manually is a pain, and discourages the liberal use of ASSERT.

### Auto Error Codes

This small library contains a simple solution to this which can be integrated fairly easily into most build environments. It consists of:

- a python script which finds source files in the repository and creates a single file which assigns an integer ID to each
- a file asserts.h which contains sample macros to generate a unique 32 bit code which allows any line in any file to be uniquely identified
- another python script which decodes the 32 bit code back to a file and linenumber.
- some sample Makefile fragments to assist in integration with your build project.

## How It Works

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



