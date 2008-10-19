OCAML_STDLIB=$(shell ocamlfind printconf stdlib)

BLAH_DIR=../blahtexcore
BLAH_OBJS=$(shell ls $(BLAH_DIR)/*.o)

CONV_DIR=../uconv
CONV_OBJS=$(shell ls $(CONV_DIR)/*.o)

TARGETS=blahcaml.cmi blahcaml.cma blahcaml.cmxa libblahcaml.a


all: build

build: $(TARGETS)

install: META $(TARGETS)
	ocamlfind remove blahcaml
	ocamlfind install blahcaml $+

blahcaml.cma blahcaml.cmxa libblahtex_stubs.a: $(BLAH_OBJS) $(CONV_OBJS) libblahtex_stubs.o blahcaml.ml
	ocamlmklib -verbose -ocamlc 'ocamlfind ocamlc -package extlib' -ocamlopt 'ocamlfind ocamlopt -package extlib' -o blahcaml -custom $+ -cclib -lstdc++

libblahtex_stubs.o: libblahtex_stubs.c
	g++ -I $(OCAML_STDLIB) -I $(BLAH_DIR) -I $(CONV_DIR) -c $<

blahcaml.cmi: blahcaml.mli
	ocamlfind ocamlc -package extlib -c $<

clean:
	rm -f *.cm* *.a *.o

