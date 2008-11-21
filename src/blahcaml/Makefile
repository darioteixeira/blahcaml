#
# Configuration options
#

CCOPT=-O2 -fno-defer-pop -D_FILE_OFFSET_BITS=64 -D_REENTRANT -fPIC

OCAML_STDLIB=$(shell ocamlc -where)
OCAML_ROOT=$(abspath $(OCAML_STDLIB)/../../)

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

dllblahcaml.so: $(BLAH_OBJS) $(CONV_OBJS) blahtex_stubs.o
	gcc -shared -lstdc++ -L$(OCAML_ROOT) -Wl,-rpath,$(OCAML_ROOT) -o $@ $+

libblahcaml.a: $(BLAH_OBJS) $(CONV_OBJS) blahtex_stubs.o
	ar rc $@ $+
	ranlib $@

blahcaml.cma: blahcaml.cmo libblahcaml.a dllblahcaml.so
	ocamlc -a -o $@ $< -dllib -lblahcaml -cclib -lblahcaml -cclib -lstdc++ -ccopt -L$(OCAML_ROOT) -ccopt -Wl,-rpath,$(OCAML_ROOT)

blahcaml.cmxa: blahcaml.cmx libblahcaml.a dllblahcaml.so
	ocamlopt -a -o $@ $< -cclib -lblahcaml -cclib -lstdc++ -ccopt -L$(OCAML_ROOT) -ccopt -Wl,-rpath,$(OCAML_ROOT)

blahcaml.cmxs: blahcaml.cmxa
	ocamlopt -shared -linkall -I `pwd` -o $@ $<

blahcaml.cmi: blahcaml.mli
	ocamlfind ocamlc -package pxp -I $(MATHML2DTD) -o $@ -c $<

blahcaml.cmo: blahcaml.ml
	ocamlfind ocamlc -package pxp -I $(MATHML2DTD) -o $@ -c $<

blahcaml.cmx: blahcaml.ml
	ocamlfind ocamlopt -package pxp -I $(MATHML2DTD) -o $@ -c $<

blahtex_stubs.o: blahtex_stubs.cpp
	g++ $(CCOPT) -I $(OCAML_STDLIB) -I $(BLAH_DIR) -I $(CONV_DIR) -o $@ -c $<

apidoc:
	ocamlfind ocamldoc -I $(MATHML2DTD) -package pxp -v -html -d ../../doc/apidoc blahcaml.mli blahcaml.ml

clean:
	rm -f *.cm* *.a *.o *.so

targets:
	@echo $(TARGETS)

