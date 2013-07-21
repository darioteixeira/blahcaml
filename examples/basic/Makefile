NAME=test

all: $(NAME).byte $(NAME).native

$(NAME).byte: $(NAME).cmo
	ocamlfind ocamlc -package blahcaml -linkpkg -o $@ $<

$(NAME).native: $(NAME).cmx
	ocamlfind ocamlopt -package blahcaml -linkpkg -o $@ $<

$(NAME).cmo: $(NAME).ml
	ocamlfind ocamlc -package blahcaml -c $<

$(NAME).cmx: $(NAME).ml
	ocamlfind ocamlopt -package blahcaml -c $<

clean:
	rm -f *.cm[iox] $(NAME).o $(NAME).byte $(NAME).native

