TARGET = myapp
LIBS = -lm
CC=gcc
CFLAGS= -g -Wall

.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< $@

$(TARGET): $(OBJECTS)
	g++ $(OBJECTS) -Wall $(LIBS) -o $@

clean:
	-rm -f *.o 
	-rm -f $(TARGET)
