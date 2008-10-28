all: test.byte test.native

test.byte: test.cmo
	ocamlfind ocamlc -package blahcaml -linkpkg -o $@ $<

test.native: test.cmx
	ocamlfind ocamlopt -package blahcaml -linkpkg -o $@ $<

test.cmo: test.ml
	ocamlfind ocamlc -package blahcaml -c $<

test.cmx: test.ml
	ocamlfind ocamlopt -package blahcaml -c $<

apidoc:

install:

clean:
	rm -f *.cm[iox] test.byte test.native

cleanall: clean

