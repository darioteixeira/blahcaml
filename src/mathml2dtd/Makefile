#
# Configuration options.
#

MATHML2DTD_DIR=mathml2dtd.d

PICKLE_SRCS=$(wildcard $(MATHML2DTD_DIR)/mathml2.dtd $(MATHML2DTD_DIR)/mathml2-qname-1.mod $(MATHML2DTD_DIR)/*.ent)

PICKLE_OBJS=$(foreach SRC, $(PICKLE_SRCS), $(notdir $(SRC)).ro.o)

TARGETS=mathml2dtd.cmi mathml2dtd.cma mathml2dtd.cmxa mathml2dtd.a libmathml2dtd.a

#
# Rules
#

all: lib

lib: $(TARGETS)

$(TARGETS): $(PICKLE_OBJS) libmathml2dtd_stubs.o mathml2dtd.ml
	ocamlmklib -verbose -o mathml2dtd -custom $+

libmathml2dtd_stubs.o: libmathml2dtd_stubs.c
	ocamlc -c $<

%.ro.o: %.rw.o
	objcopy --rename-section .data=.rodata,alloc,load,readonly,data,contents $< $@

%.rw.o:
	cd $(MATHML2DTD_DIR) && ld -r -b binary -o ../$@ $(basename $(basename $@))

clean:
	rm -f *.o *.a *.cm*

targets:
	@echo $(TARGETS)
