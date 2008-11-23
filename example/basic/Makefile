all: test.byte test.native

test.byte: test.cmo
	ocamlfind ocamlc -package blahcaml -linkpkg -o $@ $<

test.native: test.cmx
	ocamlfind ocamlopt -package blahcaml -linkpkg -o $@ $<

test.cmo: test.ml
	ocamlfind ocamlc -package blahcaml -c $<

test.cmx: test.ml
	ocamlfind ocamlopt -package blahcaml -c $<

clean:
	rm -f *.cm[iox] test.o test.byte test.native

