MATHML2DTD_DIR=mathml2dtd.d

SOURCES=$(wildcard $(MATHML2DTD_DIR)/mathml2.dtd $(MATHML2DTD_DIR)/mathml2-qname-1.mod $(MATHML2DTD_DIR)/*.ent)

TARGETS=$(foreach SOURCE, $(SOURCES), $(notdir $(SOURCE)).ro.o)

all: libmathml2dtd.a

libmathml2dtd.a: $(TARGETS)
	ar rc $@ $+

%.ro.o: %.rw.o
	objcopy --rename-section .data=.rodata,alloc,load,readonly,data,contents $< $@

%.rw.o:
	ld -r -b binary -o $@ $(MATHML2DTD_DIR)/$(basename $(basename $@))

install:

clean:
	rm -f *.o libmathml2dtd.a

