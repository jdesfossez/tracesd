CC=gcc
CFLAGS=-I.
TARGET = tracesd
LIBS=-lavahi-client -lavahi-common
PREFIX = $(DESTDIR)/usr/local
BINDIR = $(PREFIX)/bin
SOURCES = $(shell echo *.c)
OBJECTS = $(SOURCES:.c=.o)

all: $(TARGET)

tracesd: tracesd.c
	  $(CC) $(FLAGS) $(CFLAGS) $(DEBUGFLAGS) -o $@ $@.c $(LIBS)

install:
	install -D tracesd $(BINDIR)/tracesd

clean:
	rm -f $(TARGET)
