OCAML_STDLIB=$(shell ocamlfind printconf stdlib)

BLAH_DIR=../blahtexcore
BLAH_OBJS=$(shell ls $(BLAH_DIR)/*.o)

CONV_DIR=../unicodeconverter
CONV_OBJS=$(shell ls $(CONV_DIR)/*.o)

PICKLE_DIR=../mathml2dtd
PICKLE_OBJS=$(shell ls $(PICKLE_DIR)/*.o)

TARGETS=blahcaml.cmi blahcaml.cma blahcaml.cmxa blahcaml.a libblahcaml.a


all: build

build: $(TARGETS)

install: META $(TARGETS)
	ocamlfind remove blahcaml
	ocamlfind install blahcaml $+

blahcaml.cma blahcaml.cmxa blahcaml.a libblahcaml.a: $(BLAH_OBJS) $(CONV_OBJS) $(PICKLE_OBJS) libmathml2dtd_stubs.o libblahtex_stubs.o blahcaml.ml
	ocamlmklib -verbose -ocamlc 'ocamlfind ocamlc -package extlib,pxp' -ocamlopt 'ocamlfind ocamlopt -package extlib,pxp' -o blahcaml -custom $+ -cclib -lstdc++

libblahtex_stubs.o: libblahtex_stubs.c
	g++ -I $(OCAML_STDLIB) -I $(BLAH_DIR) -I $(CONV_DIR) -c $<

libmathml2dtd_stubs.o: libmathml2dtd_stubs.c
	gcc -I $(OCAML_STDLIB) -c $<

blahcaml.cmi: blahcaml.mli
	ocamlfind ocamlc -package extlib -c $<

clean:
	rm -f *.cm* *.a *.o

