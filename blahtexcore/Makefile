SRCS=$(shell ls *.cpp)
OBJS=$(foreach SRC, $(SRCS), $(basename $(SRC)).o)

all: $(OBJS)

%.o: %.cpp
	g++ -O2 -c $< -o $@

install:

clean:
	rm -f $(OBJS)

cleanall: clean

