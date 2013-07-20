/********************************************************************************/
/*	Blahtex_stubs.cpp
	Copyright (c) 2008-2013 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*/
/********************************************************************************/

#include "Interface.h"
#include "UnicodeConverter.h"
#include "Messages.h"

extern "C"
	{
	#include <caml/mlvalues.h>
	#include <caml/memory.h>
	#include <caml/alloc.h>
	#include <caml/callback.h>
	#include <caml/fail.h>
	}

using namespace std;


/********************************************************************************/
/* The unsafe_mathml_from_tex_stub function.  It interfaces between the	Ocaml	*/
/* side and the C++ functions that actually do all the work.			*/
/********************************************************************************/

extern "C" CAMLprim value unsafe_mathml_from_tex_stub (value v_tex)

	{
	CAMLparam1 (v_tex);
	CAMLlocal1 (ml_res);

	UnicodeConverter iconv;
	iconv.Open ();

	try	{
		char *tex = String_val (v_tex);
		string stex (tex);

		wstring wtex = iconv.ConvertIn (stex);
		blahtex::Interface blah;
		blah.ProcessInput (wtex);
		wstring wres = blah.GetMathml ();
		string sres = iconv.ConvertOut (wres);

		const char* res = sres.c_str ();
		ml_res = caml_copy_string (res);
		CAMLreturn (ml_res);
		}
	catch (blahtex::Exception exc)
		{
		wstring w_explanation = GetErrorMessage (exc);
		string s_explanation = iconv.ConvertOut (w_explanation);
		const char* c_explanation = s_explanation.c_str ();
		caml_raise_with_string (*caml_named_value ("blahtex_error"), c_explanation);
		}
	catch (UnicodeConverter::Exception exc)
		{
		caml_raise_constant (*caml_named_value ("unicode_error"));
		}
	}

