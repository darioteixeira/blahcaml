#
# Configuration options.
#

CCOPT=-O2 -fno-defer-pop -D_FILE_OFFSET_BITS=64 -D_REENTRANT -fPIC

SRCS=$(shell ls *.cpp)
OBJS=$(foreach SRC, $(SRCS), $(basename $(SRC)).o)


#
# Rules.
#

all: lib

lib: $(OBJS)

%.o: %.cpp
	g++ $(CCOPT) -o $@ -c $<

clean:
	rm -f $(OBJS)

