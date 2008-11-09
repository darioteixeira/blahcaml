#
# Configuration options
#

CPP_OPS=-Werror -O2

OCAML_STDLIB=$(shell ocamlfind printconf stdlib)

BLAH_DIR=../blahtexcore
BLAH_OBJS=$(shell ls $(BLAH_DIR)/*.o)

CONV_DIR=../unicodeconverter
CONV_OBJS=$(shell ls $(CONV_DIR)/*.o)

MATHML2DTD=../mathml2dtd

TARGETS=blahcaml.cmi blahcaml.cma blahcaml.cmxa blahcaml.a libblahcaml.a


#
# Rules.
#

all: lib

lib: $(TARGETS)

$(TARGETS): $(BLAH_OBJS) $(CONV_OBJS) libblahtex_stubs.o blahcaml.mli blahcaml.ml
	ocamlmklib \
		-verbose \
		-ocamlc 'ocamlfind ocamlc -I $(MATHML2DTD) -package pxp' \
		-ocamlopt 'ocamlfind ocamlopt -I $(MATHML2DTD) -package pxp' \
		-o blahcaml -custom $+ -cclib -lstdc++

libblahtex_stubs.o: libblahtex_stubs.c
	g++ $(CPP_OPS) -I $(OCAML_STDLIB) -I $(BLAH_DIR) -I $(CONV_DIR) -c $<

apidoc:
	ocamlfind ocamldoc -I $(MATHML2DTD) -package pxp -v -html -d ../../doc/apidoc blahcaml.mli blahcaml.ml

clean:
	rm -f *.cm* *.a *.o

targets:
	@echo $(TARGETS)

