(********************************************************************************)
(*	Implementation file for the Blahcaml library.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	The [Blahcaml] module defines functions for the conversion of TeX
	equations into MathML.
*)

open Pxp_core_types
open Pxp_document
open Pxp_yacc


(********************************************************************************)
(*	{2 Privates types and functions}					*)
(********************************************************************************)

(**	The [pickle_t] type enumerates all pickled files of the MathML2 DTD.
	These must be declared in the same order as that found in the C module.
*)
type pickle_t =
	| Pickled_mathml2_dtd
	| Pickled_mathml2_qname_1_mod
	| Pickled_isoamsa_ent
	| Pickled_isoamsb_ent
	| Pickled_isoamsc_ent
	| Pickled_isoamsn_ent
	| Pickled_isoamso_ent
	| Pickled_isoamsr_ent
	| Pickled_isogrk3_ent
	| Pickled_isomfrk_ent
	| Pickled_isomopf_ent
	| Pickled_isomscr_ent
	| Pickled_isotech_ent
	| Pickled_isobox_ent
	| Pickled_isocyr1_ent
	| Pickled_isocyr2_ent
	| Pickled_isodia_ent
	| Pickled_isolat1_ent
	| Pickled_isolat2_ent
	| Pickled_isonum_ent
	| Pickled_isopub_ent
	| Pickled_mmlextra_ent
	| Pickled_mmlalias_ent


(**	The [get_pickle] function is external, since it is actually declared
	on the C module.
*)
external get_pickle: pickle_t -> string = "get_pickle"


(**	Mapping between DTD PUBLIC identifiers and the pickle.
*)
let catalog =
	[
	(Public ("-//W3C//ENTITIES MathML 2.0 Qualified Names 1.0//EN", ""), get_pickle Pickled_mathml2_qname_1_mod);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Arrow Relations for MathML 2.0//EN", ""), get_pickle Pickled_isoamsa_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Binary Operators for MathML 2.0//EN", ""), get_pickle Pickled_isoamsb_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Delimiters for MathML 2.0//EN", ""), get_pickle Pickled_isoamsc_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Negated Relations for MathML 2.0//EN", ""), get_pickle Pickled_isoamsn_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Ordinary for MathML 2.0//EN", ""), get_pickle Pickled_isoamso_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Relations for MathML 2.0//EN", ""), get_pickle Pickled_isoamsr_ent);
	(Public ("-//W3C//ENTITIES Greek Symbols for MathML 2.0//EN", ""), get_pickle Pickled_isogrk3_ent);
	(Public ("-//W3C//ENTITIES Math Alphabets: Fraktur for MathML 2.0//EN", ""), get_pickle Pickled_isomfrk_ent);
	(Public ("-//W3C//ENTITIES Math Alphabets: Open Face for MathML 2.0//EN", ""), get_pickle Pickled_isomopf_ent);
	(Public ("-//W3C//ENTITIES Math Alphabets: Script for MathML 2.0//EN", ""), get_pickle Pickled_isomscr_ent);
	(Public ("-//W3C//ENTITIES General Technical for MathML 2.0//EN", ""), get_pickle Pickled_isotech_ent);
	(Public ("-//W3C//ENTITIES Box and Line Drawing for MathML 2.0//EN", ""), get_pickle Pickled_isobox_ent);
	(Public ("-//W3C//ENTITIES Russian Cyrillic for MathML 2.0//EN", ""), get_pickle Pickled_isocyr1_ent);
	(Public ("-//W3C//ENTITIES Non-Russian Cyrillic for MathML 2.0//EN", ""), get_pickle Pickled_isocyr2_ent);
	(Public ("-//W3C//ENTITIES Diacritical Marks for MathML 2.0//EN", ""), get_pickle Pickled_isodia_ent);
	(Public ("-//W3C//ENTITIES Added Latin 1 for MathML 2.0//EN", ""), get_pickle Pickled_isolat1_ent);
	(Public ("-//W3C//ENTITIES Added Latin 2 for MathML 2.0//EN", ""), get_pickle Pickled_isolat2_ent);
	(Public ("-//W3C//ENTITIES Numeric and Special Graphic for MathML 2.0//EN", ""), get_pickle Pickled_isonum_ent);
	(Public ("-//W3C//ENTITIES Publishing for MathML 2.0//EN", ""), get_pickle Pickled_isopub_ent);
	(Public ("-//W3C//ENTITIES Extra for MathML 2.0//EN", ""), get_pickle Pickled_mmlextra_ent);
	(Public ("-//W3C//ENTITIES Aiases for MathML 2.0//EN", ""), get_pickle Pickled_mmlalias_ent);
	]


(**	The parsed DTD.  If [None], the DTD has not been parsed yet.
*)
let static_dtd = ref None


(**	The default configuration for parsing DTD and XML.
*)
let config =
	{
	default_config with
	encoding = `Enc_utf8
	}


(********************************************************************************)
(*	{2 Public functions}							*)
(********************************************************************************)

(**	Initialisation of the MathML2 DTD.  This function can take several seconds
	to complete, but only needs to be called once.  If you don't worry about
	safety and only invoke {!unsafe_mathml_from_tex}, then you never need to
	run this function.  On the other hand, if you call {!sanitize_mathml} or
	{!safe_mathml_from_tex}, and the DTD has never been manually initialised,
	then this function will automatically be invoked.  Therefore, if you want
	predictability on the runtime performance of the sanitisation functions,
	you should invoke it during the initialisation stage of your programme.
*)
let init_dtd () =
	try
		let resolver = new Pxp_reader.lookup_id_as_string catalog in
		let dtd = parse_dtd_entity config (from_string ~alt:[resolver] (get_pickle Pickled_mathml2_dtd))
		in static_dtd := Some dtd
	with
		exc ->
			print_endline (Pxp_types.string_of_exn exc);
			failwith "Internal error during parsing of built-in MathML2 DTD"


(**	Given a string containing potentially unsafe MathML, this function makes
	sure the it conforms to the MathML2 DTD.  If safe, the function returns
	the original string.  If, however, the string does not conform to the DTD,
	an exception is raised.  See the {{:http://projects.camlcity.org/projects/pxp.html}PXP
	documentation} for the meaning of these exceptions.  Note that if the DTD
	has never been initialised, this function will automatically invoke {!init_dtd}.
*)
let sanitize_mathml unsafe_mathml =
	let rec get_dtd () = match !static_dtd with
		| Some dtd	-> dtd
		| None		-> init_dtd (); get_dtd () in
	let dtd = get_dtd () in
	let _ = Pxp_yacc.parse_content_entity config (from_string unsafe_mathml) dtd default_spec
	in unsafe_mathml


(**	Converts a string containing an equation in TeX format into another string
	containing the same equation in MathML.  No checking is done to make sure
	the result conforms to the MathML2 DTD!  If that assurance is required
	please use the {!safe_mathml_from_tex}.
*)
external unsafe_mathml_from_tex: string -> string = "unsafe_mathml_from_tex"


(**	Converts a string containing an equation in TeX format into another string
	containing the same equation in MathML.  The resulting string is checked
	to make sure it conforms to the MathML2 DTD.  If it does not, an exception
	is raised.  See the {{:http://projects.camlcity.org/projects/pxp.html}PXP
        documentation} for the meaning of these exceptions.  Note that if the DTD
        has never been initialised, this function will automatically invoke {!init_dtd}.
*)
let safe_mathml_from_tex tex_str =
	let unsafe_mathml = unsafe_mathml_from_tex tex_str
	in sanitize_mathml unsafe_mathml

