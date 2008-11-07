MATHML2DTD_DIR=mathml2dtd.d

SOURCES=$(wildcard $(MATHML2DTD_DIR)/mathml2.dtd $(MATHML2DTD_DIR)/mathml2-qname-1.mod $(MATHML2DTD_DIR)/*.ent)

TARGETS=$(foreach SOURCE, $(SOURCES), $(notdir $(SOURCE)).ro.o)

all: $(TARGETS)

%.ro.o: %.rw.o
	objcopy --rename-section .data=.rodata,alloc,load,readonly,data,contents $< $@

%.rw.o:
	(cd $(MATHML2DTD_DIR); ld -r -b binary -o ../$@ $(basename $(basename $@)))

doc:

install:

clean:
	rm -f *.o

cleanall: clean

