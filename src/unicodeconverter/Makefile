#
# Configuration options.
#

CPP_OPS=-Werror -O2

SRCS=$(shell ls *.cpp)
OBJS=$(foreach SRC, $(SRCS), $(basename $(SRC)).o)


#
# Rules.
#

all: lib

lib: $(OBJS)

%.o: %.cpp
	g++ $(CPP_OPS) -c $< -o $@

clean:
	rm -f $(OBJS)

