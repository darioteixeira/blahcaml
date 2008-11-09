(********************************************************************************)
(*	Implementation file for the Blahcaml library.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	The [Blahcaml] module defines functions for the conversion of TeX equations
	into MathML.  Important note: all the strings used in this module are assumed
	to be encoded in UTF-8.  Use {{:http://camomile.sourceforge.net/}Camomile} if
	you want to process the string's characters.
*)

open Pxp_core_types
open Pxp_document
open Pxp_yacc


(********************************************************************************)
(*	{2 Privates types and functions}					*)
(********************************************************************************)

(**	Mapping between DTD PUBLIC identifiers and the pickle.
*)
let catalog =
	[
	(Public ("-//W3C//ENTITIES MathML 2.0 Qualified Names 1.0//EN", ""), Mathml2dtd.get_mathml2_qname_1_mod ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Arrow Relations for MathML 2.0//EN", ""), Mathml2dtd.get_isoamsa_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Binary Operators for MathML 2.0//EN", ""), Mathml2dtd.get_isoamsb_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Delimiters for MathML 2.0//EN", ""), Mathml2dtd.get_isoamsc_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Negated Relations for MathML 2.0//EN", ""), Mathml2dtd.get_isoamsn_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Ordinary for MathML 2.0//EN", ""), Mathml2dtd.get_isoamso_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Relations for MathML 2.0//EN", ""), Mathml2dtd.get_isoamsr_ent ());
	(Public ("-//W3C//ENTITIES Greek Symbols for MathML 2.0//EN", ""), Mathml2dtd.get_isogrk3_ent ());
	(Public ("-//W3C//ENTITIES Math Alphabets: Fraktur for MathML 2.0//EN", ""), Mathml2dtd.get_isomfrk_ent ());
	(Public ("-//W3C//ENTITIES Math Alphabets: Open Face for MathML 2.0//EN", ""), Mathml2dtd.get_isomopf_ent ());
	(Public ("-//W3C//ENTITIES Math Alphabets: Script for MathML 2.0//EN", ""), Mathml2dtd.get_isomscr_ent ());
	(Public ("-//W3C//ENTITIES General Technical for MathML 2.0//EN", ""), Mathml2dtd.get_isotech_ent ());
	(Public ("-//W3C//ENTITIES Box and Line Drawing for MathML 2.0//EN", ""), Mathml2dtd.get_isobox_ent ());
	(Public ("-//W3C//ENTITIES Russian Cyrillic for MathML 2.0//EN", ""), Mathml2dtd.get_isocyr1_ent ());
	(Public ("-//W3C//ENTITIES Non-Russian Cyrillic for MathML 2.0//EN", ""), Mathml2dtd.get_isocyr2_ent ());
	(Public ("-//W3C//ENTITIES Diacritical Marks for MathML 2.0//EN", ""), Mathml2dtd.get_isodia_ent ());
	(Public ("-//W3C//ENTITIES Added Latin 1 for MathML 2.0//EN", ""), Mathml2dtd.get_isolat1_ent ());
	(Public ("-//W3C//ENTITIES Added Latin 2 for MathML 2.0//EN", ""), Mathml2dtd.get_isolat2_ent ());
	(Public ("-//W3C//ENTITIES Numeric and Special Graphic for MathML 2.0//EN", ""), Mathml2dtd.get_isonum_ent ());
	(Public ("-//W3C//ENTITIES Publishing for MathML 2.0//EN", ""), Mathml2dtd.get_isopub_ent ());
	(Public ("-//W3C//ENTITIES Extra for MathML 2.0//EN", ""), Mathml2dtd.get_mmlextra_ent ());
	(Public ("-//W3C//ENTITIES Aiases for MathML 2.0//EN", ""), Mathml2dtd.get_mmlalias_ent ());
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
		let dtd = parse_dtd_entity config (from_string ~alt:[resolver] (Mathml2dtd.get_mathml2_dtd ()))
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

