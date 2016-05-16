# Compilers
CC=gcc
VALAC=valac
PKGCONFIG=pkg-config

# Targets
LIBRARY=dflib

# Filepaths
SRCPATH=src/
OBJPATH=obj/
LIBPATH=lib

SRCS:=$(wildcard $(SRCPATH)*.vala)

# Flags
VFLAGS=-c -H $(LIBRARY).h --cc=$(CC) --vapi=$(LIBRARY).vapi
VLIBS=--pkg=glib-2.0 --pkg=gtk+-3.0 --pkg=gee-0.8 --pkg sqlheavy-0.1
CFLAGS=-I$(SRCPATH)$(COMMONTARGET) `$(PKGCONFIG) --cflags glib-2.0 gtk+-3.0 gee-0.8 sqlheavy-0.1`
CLIBS=`$(PKGCONFIG) --libs glib-2.0 gtk+-3.0 gee-0.8 sqlheavy-0.1`

# Directory inits
$(shell mkdir -p $(OBJPATH))
$(shell mkdir -p $(LIBPATH))

all: objects
	ar -rs lib$(LIBRARY).a $(OBJPATH)*.o
	ranlib lib$(LIBRARY).a
	mv -f $(LIBRARY).h $(LIBPATH)
	mv -f $(LIBRARY).vapi $(LIBPATH)
	mv -f lib$(LIBRARY).a $(LIBPATH)

objects: $(SRCS)
	$(VALAC) $(VFLAGS) $(SRCS) $(VLIBS)
	mv -f *.o $(OBJPATH)

clean:
	rm -rf $(LIBPATH) $(OBJPATH)

install: all
	cp $(LIBPATH)/lib$(LIBRARY).a /usr/lib
	cp $(LIBPATH)/$(LIBRARY).h /usr/include
	cp $(LIBPATH)/$(LIBRARY).vapi /usr/share/vala/vapi
	cp $(LIBRARY).deps /usr/share/vala/vapi
