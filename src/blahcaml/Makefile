#
# Configuration options
#

CC_OPS=-Wall -Werror
CPP_OPS=-Werror

OCAML_STDLIB=$(shell ocamlfind printconf stdlib)

BLAH_DIR=../blahtexcore
BLAH_OBJS=$(shell ls $(BLAH_DIR)/*.o)

CONV_DIR=../unicodeconverter
CONV_OBJS=$(shell ls $(CONV_DIR)/*.o)

PICKLE_DIR=../mathml2dtd

TARGETS=blahcaml.cmi blahcaml.cma blahcaml.cmxa blahcaml.a libblahcaml.a


#
# Rules.
#

all: $(TARGETS)

$(TARGETS): $(BLAH_OBJS) $(CONV_OBJS) libblahtex_stubs.o blahcaml.ml
	ocamlmklib \
		-verbose \
		-ocamlc 'ocamlfind ocamlc -I $(PICKLE_DIR) -package pxp' \
		-ocamlopt 'ocamlfind ocamlopt -I $(PICKLE_DIR) -package pxp' \
		-o blahcaml -custom $+ -cclib -lstdc++

libblahtex_stubs.o: libblahtex_stubs.c
	g++ $(CPP_OPS) -I $(OCAML_STDLIB) -I $(BLAH_DIR) -I $(CONV_DIR) -c $<

blahcaml.cmi: blahcaml.mli
	ocamlfind ocamlc -c $<

doc:
	mkdir -p ../apidoc
	ocamlfind ocamldoc -package pxp -v -html -d ../apidoc blahcaml.mli blahcaml.ml

install: META $(TARGETS)
	ocamlfind remove blahcaml
	ocamlfind install blahcaml $+

clean:
	rm -f *.cm* *.a *.o

cleanall: clean
	rm -rf ../apidoc

