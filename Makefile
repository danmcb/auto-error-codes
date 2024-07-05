TARGET = myapp
LIBS = -lm
CC=gcc

SOME_LIB_PATH = pathto/some_lib

MAX_FILES = 1024
MAX_LINES = 1024

.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
OBJECTS += $(patsubst %.c, %.o, $(wildcard $(SOME_LIB_PATH)/*.c))
HEADERS = $(wildcard *.h)

SOURCE_ID_SCRIPT = ./source_ids/make_source_ids.py

SOURCE_IDS = ./source_ids.txt

$(SOURCE_IDS): $(SOURCE_ID_SCRIPT)
	$(info Generating source ids into $(SOURCE_IDS))
	$(SOURCE_ID_SCRIPT) --root . --max_files $(MAX_FILES) --max_lines $(MAX_LINES) > $(SOURCE_IDS)

GIT_REF_SHORT = $(shell git rev-parse HEAD|cut -c 1-8)

CFLAGS= -g -Wall -D'GIT_REF_SHORT=0x$(GIT_REF_SHORT)'

%.o: %.c $(HEADERS) $(SOURCE_IDS)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJECTS) 
	g++ $(OBJECTS) -Wall $(LIBS) -o $@

clean:
	-rm -f *.o 
	-rm -f $(TARGET)
	-rm -f $(SOURCE_IDS)
