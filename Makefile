SHELL := /bin/bash
TARGET = myapp
LIBS = -lm
CC=gcc

SOME_LIB_PATH = pathto/some_lib

MAX_FILES = 1024
MAX_LINES = 1024

.PHONY: default all clean

default: $(TARGET)
all: default


SRCS = *.c $(SOME_LIB_PATH)/*.c
OBJECTS = $(patsubst %.c, %.o, $(wildcard $(SRCS)))
HEADERS = $(wildcard *.h)

SOURCE_IDS_DIR = ./source_ids
SOURCE_ID_SCRIPT = $(SOURCE_IDS_DIR)/make_source_ids.py
SOURCE_IDS_LIST = $(SOURCE_IDS_DIR)/source_ids.txt

GET_SOURCE_ID = `grep $< $(SOURCE_IDS_LIST)| cut -f 1`

$(SOURCE_IDS_LIST): $(SOURCE_ID_SCRIPT)
	$(info Generating source ids into $(SOURCE_IDS_LIST))
	$(SOURCE_ID_SCRIPT) --root . --max_files $(MAX_FILES) --max_lines $(MAX_LINES) > $(SOURCE_IDS_LIST)

GIT_REF_SHORT = $(shell git rev-parse HEAD|cut -c 1-8)
CFLAGS = -g -Wall -D'GIT_REF_SHORT=0x$(GIT_REF_SHORT)'

%.o: %.c $(HEADERS) $(SOURCE_IDS_LIST)
	$(CC) $(CFLAGS) -DSOURCE_ID=$(GET_SOURCE_ID) -c $< -o $@

$(TARGET): $(OBJECTS) 
	g++ $(OBJECTS) -Wall $(LIBS) -o $@

clean:
	-rm -f *.o 
	-rm -f $(TARGET)
	-rm -f $(SOURCE_IDS_LIST)
