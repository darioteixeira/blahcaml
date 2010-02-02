#
# Configuration options
#

CCOPT=-O2 -fno-defer-pop -D_FILE_OFFSET_BITS=64 -D_REENTRANT -fPIC

OCAML_STDLIB=$(shell ocamlc -where)

BLAH_DIR=../blahtexcore
BLAH_OBJS=$(shell ls $(BLAH_DIR)/*.o)

UCONV_DIR=../unicodeconverter
UCONV_OBJS=$(shell ls $(UCONV_DIR)/*.o)

MSG_DIR=../messages
MSG_OBJS=$(shell ls $(MSG_DIR)/*.o)

MATHML2DTD=../mathml2dtd

TARGETS=blahcaml.cmi blahcaml.cma blahcaml.cmxa blahcaml.cmxs blahcaml.a libblahcaml.a dllblahcaml.so


#
# Rules.
#

all: lib

lib: $(TARGETS)

blahcaml.cma blahcaml.cmxa blahcaml.a libblahcaml.a dllblahcaml.so: $(BLAH_OBJS) $(UCONV_OBJS) $(MSG_OBJS) blahtex_stubs.o blahcaml.cmo blahcaml.cmx
	ocamlmklib -verbose -lstdc++ -o blahcaml -oc blahcaml $+

blahcaml.cmxs: blahcaml.cmxa
	ocamlopt -shared -linkall -I `pwd` -o $@ $<

blahcaml.cmi: blahcaml.mli
	ocamlfind ocamlc -package pxp-engine,pxp-ulex-utf8 -I $(MATHML2DTD) -o $@ -c $<

blahcaml.cmo: blahcaml.ml
	ocamlfind ocamlc -package pxp-engine,pxp-ulex-utf8 -I $(MATHML2DTD) -o $@ -c $<

blahcaml.cmx: blahcaml.ml
	ocamlfind ocamlopt -package pxp-engine,pxp-ulex-utf8 -I $(MATHML2DTD) -o $@ -c $<

blahtex_stubs.o: blahtex_stubs.cpp
	g++ $(CCOPT) -I $(OCAML_STDLIB) -I $(BLAH_DIR) -I $(UCONV_DIR) -I $(MSG_DIR) -o $@ -c $<

clean:
	rm -f *.cm* *.a *.o *.so

targets:
	@echo $(TARGETS)

