#
# Configuration options.
#

MATHML2DTD_DIR=mathml2dtd.d

PICKLE_SRCS=$(wildcard $(MATHML2DTD_DIR)/mathml2.dtd $(MATHML2DTD_DIR)/mathml2-qname-1.mod $(MATHML2DTD_DIR)/*.ent)

TARGETS=mathml2dtd.cmi mathml2dtd.cma mathml2dtd.cmxa mathml2dtd.cmxs mathml2dtd.a

#
# Rules
#

all: lib

lib: $(TARGETS)

mathml2dtd.cmxs: mathml2dtd.cmxa
	ocamlopt -shared -linkall -I . -o $@ $<

mathml2dtd.cmxa: mathml2dtd.cmx
	ocamlfind ocamlopt -o $@ -a $<

mathml2dtd.cma: mathml2dtd.cmo
	ocamlfind ocamlc -o $@ -a $<

mathml2dtd.cmi: mathml2dtd.mli
	ocamlfind ocamlc -package pxp-engine,pxp-ulex-utf8 -o $@ -c $<

mathml2dtd.cmo: mathml2dtd.ml mathml2dtd.cmi
	ocamlfind ocamlc -package xstrp4,pxp-engine,pxp-ulex-utf8 -syntax camlp4o -o $@ -c $<

mathml2dtd.cmx: mathml2dtd.ml mathml2dtd.cmi
	ocamlfind ocamlopt -package xstrp4,pxp-engine,pxp-ulex-utf8 -syntax camlp4o -o $@ -c $<

clean:
	rm -f *.o *.a *.cm*

targets:
	@echo $(TARGETS)

