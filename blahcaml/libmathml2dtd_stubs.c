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


/********************************************************************************/

#define BIN_START(name)		_binary_##name##_start
#define BIN_END(name)		_binary_##name##_end

#define DECL_BIN_START(name)	extern char BIN_START(name) []
#define DECL_BIN_END(name)	extern char BIN_END(name) []

#define DECL_BIN(name)		DECL_BIN_START(name); DECL_BIN_END(name);
#define REF_BIN(name)		{BIN_START(name), BIN_END(name)}


/********************************************************************************/

DECL_BIN(mathml2_dtd)
DECL_BIN(mathml2_qname_1_mod)
DECL_BIN(isoamsa_ent)
DECL_BIN(isoamsb_ent)
DECL_BIN(isoamsc_ent)
DECL_BIN(isoamsn_ent)
DECL_BIN(isoamso_ent)
DECL_BIN(isoamsr_ent)
DECL_BIN(isogrk3_ent)
DECL_BIN(isomfrk_ent)
DECL_BIN(isomopf_ent)
DECL_BIN(isomscr_ent)
DECL_BIN(isotech_ent)
DECL_BIN(isobox_ent)
DECL_BIN(isocyr1_ent)
DECL_BIN(isocyr2_ent)
DECL_BIN(isodia_ent)
DECL_BIN(isolat1_ent)
DECL_BIN(isolat2_ent)
DECL_BIN(isonum_ent)
DECL_BIN(isopub_ent)
DECL_BIN(mmlextra_ent)
DECL_BIN(mmlalias_ent)

/********************************************************************************/

typedef struct
	{
	char *start;
	char *end;
	} pickle_t;

static const pickle_t pickles [] =
	{
	REF_BIN(mathml2_dtd),
	REF_BIN(mathml2_qname_1_mod),
	REF_BIN(isoamsa_ent),
	REF_BIN(isoamsb_ent),
	REF_BIN(isoamsc_ent),
	REF_BIN(isoamsn_ent),
	REF_BIN(isoamso_ent),
	REF_BIN(isoamsr_ent),
	REF_BIN(isogrk3_ent),
	REF_BIN(isomfrk_ent),
	REF_BIN(isomopf_ent),
	REF_BIN(isomscr_ent),
	REF_BIN(isotech_ent),
	REF_BIN(isobox_ent),
	REF_BIN(isocyr1_ent),
	REF_BIN(isocyr2_ent),
	REF_BIN(isodia_ent),
	REF_BIN(isolat1_ent),
	REF_BIN(isolat2_ent),
	REF_BIN(isonum_ent),
	REF_BIN(isopub_ent),
	REF_BIN(mmlextra_ent),
	REF_BIN(mmlalias_ent)
	};


/********************************************************************************/

CAMLprim value get_pickle (value v_file)

	{
	CAMLparam1 (v_file);
	CAMLlocal1 (ml_pickle);

	pickle_t pickle = pickles [Int_val (v_file)];

	size_t pickle_size = pickle.end - pickle.start;
	ml_pickle = caml_alloc_string (pickle_size);
	memcpy ((void*) String_val (ml_pickle), (void*) pickle.start, pickle_size);

	CAMLreturn (ml_pickle);
	}

