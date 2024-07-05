TARGET = myapp
LIBS = -lm
CC=gcc

MAX_FILES = 1024
MAX_LINES = 1024

.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

FILE_ID_SCRIPT = ./file_ids/make_file_ids.py

FILE_IDS = ./file_ids.txt

$(FILE_IDS): $(FILE_ID_SCRIPT)
	$(FILE_ID_SCRIPT) --root . --max_files $(MAX_FILES) --max_lines $(MAX_LINES) > $(FILE_IDS)

GIT_REF_SHORT = $(shell git rev-parse HEAD|cut -c 1-8)

CFLAGS= -g -Wall -D'GIT_REF_SHORT=0x$(GIT_REF_SHORT)'

%.o: %.c $(HEADERS) $(FILE_IDS)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJECTS) 
	g++ $(OBJECTS) -Wall $(LIBS) -o $@

clean:
	-rm -f *.o 
	-rm -f $(TARGET)
	-rm -f $(FILE_IDS)
