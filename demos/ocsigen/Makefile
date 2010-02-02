all: test.cma test.cmxs

test.cma: test.cmo
	ocamlc -a -o $@ $<

test.cmxa: test.cmx
	ocamlopt -a -o $@ $<

test.cmxs: test.cmxa
	ocamlopt -shared -linkall -I `pwd` -o $@ $<

test.cmo: test.ml
	ocamlfind ocamlc -thread -package lwt,ocsigen,blahcaml -c $<

test.cmx: test.ml
	ocamlfind ocamlopt -thread -package lwt,ocsigen,blahcaml -c $<

clean:
	rm -f *.cm* *.o *.a

