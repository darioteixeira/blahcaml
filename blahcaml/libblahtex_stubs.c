#include "Interface.h"
#include "UnicodeConverter.h"

extern "C"
	{
	#include <caml/mlvalues.h>
	#include <caml/memory.h>
	#include <caml/alloc.h>
	}


extern "C" CAMLprim value unsafe_mathml_from_tex (value v_tex)

	{
	CAMLparam1 (v_tex);
	CAMLlocal1 (ml_res);

	UnicodeConverter iconv;
	iconv.Open ();

	char *tex = String_val (v_tex);
	std::string stex (tex);
	std::wstring wtex = iconv.ConvertIn (stex);

	blahtex::Interface blah;
	blah.ProcessInput (wtex);
	std::wstring wres = blah.GetMathml ();

	std::string sres = iconv.ConvertOut (wres);
	const char* res = sres.c_str ();
	
	ml_res = caml_copy_string (res);
	CAMLreturn (ml_res);
	}

