TARGET = myapp
LIBS = -lm
CC=gcc


.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

#$(GIT_REF_SHORT):
GIT_REF_SHORT = $(shell git rev-parse HEAD|cut -c 1-8)

CFLAGS= -g -Wall

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -D'GIT_REF_SHORT=0x$(GIT_REF_SHORT)' -c $< -o $@

$(TARGET): $(OBJECTS) 
	g++ $(OBJECTS) -Wall $(LIBS) -o $@

clean:
	-rm -f *.o 
	-rm -f $(TARGET)
