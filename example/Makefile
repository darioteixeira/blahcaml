test: test.cmo
	ocamlfind ocamlc -package blahcaml -linkpkg -o $@ $<

test.cmo: test.ml
	ocamlfind ocamlc -package blahcaml -c $<

install:

clean:
	rm -f *.cm[io]
