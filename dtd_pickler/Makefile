all: dtd_pickle_ro.o

dtd_pickle_ro.o: dtd_pickle_rw.o
	objcopy --rename-section .data=.rodata,alloc,load,readonly,data,contents $< $@

dtd_pickle_rw.o: dtd_pickle.dat
	ld -r -b binary -o $@ $<

dtd_pickle.dat: dtd_pickler
	./dtd_pickler > $@

dtd_pickler: dtd_pickler.ml
	ocamlfind ocamlc -package camlzip,pxp -linkpkg $< -o $@

clean:
	rm -f *.cm[io] *.o dtd_pickle.dat dtd_pickler

