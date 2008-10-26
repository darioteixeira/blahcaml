#include <stdio.h>

#include <string.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>

extern char _binary_pickle_dat_start [];
extern char _binary_pickle_dat_end [];

CAMLprim value get_pickled_dtd (value v_unit)

	{
	CAMLparam1 (v_unit);
	CAMLlocal1 (ml_pickle);

	size_t pickle_size = _binary_pickle_dat_end - _binary_pickle_dat_start;
	printf ("Pickle has %lu bytes\n", pickle_size);
	ml_pickle = caml_alloc_string (pickle_size);
	memcpy ((void*) String_val (ml_pickle), (void*) _binary_pickle_dat_start, pickle_size);

	CAMLreturn (ml_pickle);
	}

