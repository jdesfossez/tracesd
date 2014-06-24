CC=gcc
CFLAGS=-I.
TARGET = tracesd
OBJ = tracesd.o
LIBS=-lavahi-client -lavahi-common
PREFIX = $(DESTDIR)/usr/local
BINDIR = $(PREFIX)/bin
SOURCES = $(shell echo *.c)
OBJECTS = $(SOURCES:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJECTS) $(COMMON)
	  $(CC) $(FLAGS) $(CFLAGS) $(DEBUGFLAGS) -o $(TARGET) $(OBJECTS) $(LIBS)

install:
	install -D $(TARGET) $(BINDIR)/$(TARGET)

clean:
	rm -f $(OBJECTS) $(TARGET)
