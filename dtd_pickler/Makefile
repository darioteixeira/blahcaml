all: pickle_ro.o

pickle_ro.o: pickle_rw.o
	objcopy --rename-section .data=.rodata,alloc,load,readonly,data,contents $< $@

pickle_rw.o: pickle.dat
	ld -r -b binary -o $@ $<

pickle.dat: dtd_pickler
	./dtd_pickler > $@

dtd_pickler: dtd_pickler.ml
	ocamlfind ocamlc -package camlzip,pxp -linkpkg $< -o $@

install:

clean:
	rm -f *.cm[iox] *.o pickle.dat dtd_pickler

