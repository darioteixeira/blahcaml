/********************************************************************************/
/*	Stubs for libmathml2dtd.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*/
/********************************************************************************/

#include <string.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>


/********************************************************************************/
/* The get_pickle function.  It interfaces with the Ocaml side, returning the	*/
/* specified pickle as a string.						*/
/********************************************************************************/

CAMLprim value get_pickle (char *pickle_start, char *pickle_end)

	{
	CAMLparam0 ();
	CAMLlocal1 (ml_pickle);

	size_t pickle_size = pickle_end - pickle_start;
	ml_pickle = caml_alloc_string (pickle_size);
	memcpy ((void*) String_val (ml_pickle), (void*) pickle_start, pickle_size);

	CAMLreturn (ml_pickle);
	}


/********************************************************************************/
/* Definition of macros that simplify the declaration of the external pickles.	*/
/********************************************************************************/

#define BIN_START(name)		_binary_##name##_start
#define BIN_END(name)		_binary_##name##_end

#define DECL_BIN_START(name)	extern char BIN_START (name) []
#define DECL_BIN_END(name)	extern char BIN_END (name) []

#define GET_BIN(name)		CAMLprim value get_##name (value v_unit) {CAMLparam1 (v_unit); CAMLreturn (get_pickle (BIN_START (name), BIN_END (name)));}
#define ALL_BIN(name)		DECL_BIN_START (name); DECL_BIN_END (name); GET_BIN (name);


/********************************************************************************/
/* Declaration of the external pickles. 					*/
/********************************************************************************/

ALL_BIN (mathml2_dtd)
ALL_BIN (mathml2_qname_1_mod)
ALL_BIN (isoamsa_ent)
ALL_BIN (isoamsb_ent)
ALL_BIN (isoamsc_ent)
ALL_BIN (isoamsn_ent)
ALL_BIN (isoamso_ent)
ALL_BIN (isoamsr_ent)
ALL_BIN (isogrk3_ent)
ALL_BIN (isomfrk_ent)
ALL_BIN (isomopf_ent)
ALL_BIN (isomscr_ent)
ALL_BIN (isotech_ent)
ALL_BIN (isobox_ent)
ALL_BIN (isocyr1_ent)
ALL_BIN (isocyr2_ent)
ALL_BIN (isodia_ent)
ALL_BIN (isolat1_ent)
ALL_BIN (isolat2_ent)
ALL_BIN (isonum_ent)
ALL_BIN (isopub_ent)
ALL_BIN (mmlextra_ent)
ALL_BIN (mmlalias_ent)

