all: main.cma main.cmxs

main.cma: main.cmo
	ocamlc -a -o $@ $<

main.cmxa: main.cmx
	ocamlopt -a -o $@ $<

main.cmxs: main.cmxa
	ocamlopt -shared -linkall -I `pwd` -o $@ $<

main.cmo: main.ml
	ocamlfind ocamlc -thread -package lwt,ocsigen,blahcaml -c $<

main.cmx: main.ml
	ocamlfind ocamlopt -thread -package lwt,ocsigen,blahcaml -c $<

clean:
	rm -f *.cm* *.o *.a

