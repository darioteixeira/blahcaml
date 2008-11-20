#
# Configuration options
#

CCOPT="-O2 -fno-defer-pop -D_FILE_OFFSET_BITS=64 -D_REENTRANT -fPIC"

OCAML_STDLIB=$(shell ocamlfind printconf stdlib)

BLAH_DIR=../blahtexcore
BLAH_OBJS=$(shell ls $(BLAH_DIR)/*.o)

CONV_DIR=../unicodeconverter
CONV_OBJS=$(shell ls $(CONV_DIR)/*.o)

MATHML2DTD=../mathml2dtd

TARGETS=blahcaml.cmi blahcaml.cma blahcaml.cmxa blahcaml.cmxs blahcaml.a libblahcaml.a dllblahcaml.so


#
# Rules.
#

all: lib

lib: $(TARGETS)

blahcaml.cmxs: blahcaml.cmxa
	ocamlopt -shared -linkall -I `pwd` -o $@ $<

blahcaml.cma blahcaml.cmxa blahcaml.a libblahcaml.a dllblahcaml.so: $(BLAH_OBJS) $(CONV_OBJS) blahtex_stubs.o blahcaml.cmo blahcaml.cmx
	ocamlmklib -verbose -o blahcaml -oc blahcaml -cclib -lstdc++ $+

blahcaml.cmi: blahcaml.mli
	ocamlfind ocamlc -package pxp -I $(MATHML2DTD) -o $@ -c $<

blahcaml.cmo: blahcaml.ml
	ocamlfind ocamlc -package pxp -I $(MATHML2DTD) -o $@ -c $<

blahcaml.cmx: blahcaml.ml
	ocamlfind ocamlopt -package pxp -I $(MATHML2DTD) -o $@ -c $<

blahtex_stubs.o: blahtex_stubs.c
	ocamlc -cc g++ -ccopt $(CCOPT) -I $(BLAH_DIR) -I $(CONV_DIR) -o $@ -c $<

apidoc:
	ocamlfind ocamldoc -I $(MATHML2DTD) -package pxp -v -html -d ../../doc/apidoc blahcaml.mli blahcaml.ml

clean:
	rm -f *.cm* *.a *.o *.so

targets:
	@echo $(TARGETS)

