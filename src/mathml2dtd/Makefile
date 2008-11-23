#
# Configuration options.
#

MATHML2DTD_DIR=mathml2dtd.d

PICKLE_SRCS=$(wildcard $(MATHML2DTD_DIR)/mathml2.dtd $(MATHML2DTD_DIR)/mathml2-qname-1.mod $(MATHML2DTD_DIR)/*.ent)

PICKLE_OBJS=$(foreach SRC, $(PICKLE_SRCS), $(notdir $(SRC)).ro.o)

TARGETS=mathml2dtd.cmi mathml2dtd.cma mathml2dtd.cmxa mathml2dtd.cmxs mathml2dtd.a libmathml2dtd.a dllmathml2dtd.so

#
# Rules
#

all: lib

lib: $(TARGETS)

mathml2dtd.cmxs: mathml2dtd.cmxa
	ocamlopt -shared -linkall -I `pwd` -o $@ $<

mathml2dtd.cma mathml2dtd.cmxa mathml2dtd.a libmathml2dtd.a dllmathml2dtd.so: $(PICKLE_OBJS) mathml2dtd_stubs.o mathml2dtd.cmo mathml2dtd.cmx
	ocamlmklib -verbose -o mathml2dtd -oc mathml2dtd $+

mathml2dtd.cmi: mathml2dtd.mli
	ocamlfind ocamlc -package pxp -o $@ -c $<

mathml2dtd.cmo: mathml2dtd.ml
	ocamlfind ocamlc -package pxp -o $@ -c $<

mathml2dtd.cmx: mathml2dtd.ml
	ocamlfind ocamlopt -package pxp -o $@ -c $<

mathml2dtd_stubs.o: mathml2dtd_stubs.c
	ocamlc -verbose -ccopt -std=c99 -c $<

%.ro.o: %.rw.o
	objcopy --rename-section .data=.rodata,alloc,load,readonly,data,contents $< $@

%.rw.o:
	cd $(MATHML2DTD_DIR) && ld -r -b binary -o ../$@ $(basename $(basename $@))

clean:
	rm -f *.o *.a *.cm* *.so

targets:
	@echo $(TARGETS)
