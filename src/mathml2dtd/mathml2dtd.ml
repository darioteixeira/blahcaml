(********************************************************************************)
(*	Implementation file for Mathml2dtd.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open Pxp_types
open Pxp_document
open Pxp_yacc


(********************************************************************************)
(*	{2 Private functions}							*)
(********************************************************************************)

(**	Externally defined functions that return the text of the various
	individual files constituting the DTD.
*)

external get_mathml2_dtd:		unit -> string = "get_mathml2_dtd" 
external get_mathml2_qname_1_mod:	unit -> string = "get_mathml2_qname_1_mod" 
external get_isoamsa_ent:		unit -> string = "get_isoamsa_ent" 
external get_isoamsb_ent:		unit -> string = "get_isoamsb_ent" 
external get_isoamsc_ent:		unit -> string = "get_isoamsc_ent" 
external get_isoamsn_ent:		unit -> string = "get_isoamsn_ent" 
external get_isoamso_ent:		unit -> string = "get_isoamso_ent" 
external get_isoamsr_ent:		unit -> string = "get_isoamsr_ent" 
external get_isogrk3_ent:		unit -> string = "get_isogrk3_ent" 
external get_isomfrk_ent:		unit -> string = "get_isomfrk_ent" 
external get_isomopf_ent:		unit -> string = "get_isomopf_ent" 
external get_isomscr_ent:		unit -> string = "get_isomscr_ent" 
external get_isotech_ent:		unit -> string = "get_isotech_ent" 
external get_isobox_ent:		unit -> string = "get_isobox_ent" 
external get_isocyr1_ent:		unit -> string = "get_isocyr1_ent" 
external get_isocyr2_ent:		unit -> string = "get_isocyr2_ent" 
external get_isodia_ent:		unit -> string = "get_isodia_ent" 
external get_isolat1_ent:		unit -> string = "get_isolat1_ent" 
external get_isolat2_ent:		unit -> string = "get_isolat2_ent" 
external get_isonum_ent:		unit -> string = "get_isonum_ent" 
external get_isopub_ent:		unit -> string = "get_isopub_ent" 
external get_mmlextra_ent:		unit -> string = "get_mmlextra_ent" 
external get_mmlalias_ent:		unit -> string = "get_mmlalias_ent" 


(**	Mapping between DTD PUBLIC identifiers and the pickle.
*)
let catalog =
	[
	(Public ("-//W3C//ENTITIES MathML 2.0 Qualified Names 1.0//EN", ""), get_mathml2_qname_1_mod ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Arrow Relations for MathML 2.0//EN", ""), get_isoamsa_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Binary Operators for MathML 2.0//EN", ""), get_isoamsb_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Delimiters for MathML 2.0//EN", ""), get_isoamsc_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Negated Relations for MathML 2.0//EN", ""), get_isoamsn_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Ordinary for MathML 2.0//EN", ""), get_isoamso_ent ());
	(Public ("-//W3C//ENTITIES Added Math Symbols: Relations for MathML 2.0//EN", ""), get_isoamsr_ent ());
	(Public ("-//W3C//ENTITIES Greek Symbols for MathML 2.0//EN", ""), get_isogrk3_ent ());
	(Public ("-//W3C//ENTITIES Math Alphabets: Fraktur for MathML 2.0//EN", ""), get_isomfrk_ent ());
	(Public ("-//W3C//ENTITIES Math Alphabets: Open Face for MathML 2.0//EN", ""), get_isomopf_ent ());
	(Public ("-//W3C//ENTITIES Math Alphabets: Script for MathML 2.0//EN", ""), get_isomscr_ent ());
	(Public ("-//W3C//ENTITIES General Technical for MathML 2.0//EN", ""), get_isotech_ent ());
	(Public ("-//W3C//ENTITIES Box and Line Drawing for MathML 2.0//EN", ""), get_isobox_ent ());
	(Public ("-//W3C//ENTITIES Russian Cyrillic for MathML 2.0//EN", ""), get_isocyr1_ent ());
	(Public ("-//W3C//ENTITIES Non-Russian Cyrillic for MathML 2.0//EN", ""), get_isocyr2_ent ());
	(Public ("-//W3C//ENTITIES Diacritical Marks for MathML 2.0//EN", ""), get_isodia_ent ());
	(Public ("-//W3C//ENTITIES Added Latin 1 for MathML 2.0//EN", ""), get_isolat1_ent ());
	(Public ("-//W3C//ENTITIES Added Latin 2 for MathML 2.0//EN", ""), get_isolat2_ent ());
	(Public ("-//W3C//ENTITIES Numeric and Special Graphic for MathML 2.0//EN", ""), get_isonum_ent ());
	(Public ("-//W3C//ENTITIES Publishing for MathML 2.0//EN", ""), get_isopub_ent ());
	(Public ("-//W3C//ENTITIES Extra for MathML 2.0//EN", ""), get_mmlextra_ent ());
	(Public ("-//W3C//ENTITIES Aiases for MathML 2.0//EN", ""), get_mmlalias_ent ());
	]


(********************************************************************************)
(*	{2 Public functions}							*)
(********************************************************************************)

(**	Returns the parsed MathML2 DTD as a PXP value.  This function can take
	several seconds to complete.
*)
let get_dtd () =
	try
		let resolver = new Pxp_reader.lookup_id_as_string catalog in
		let config = {default_config with encoding = `Enc_utf8} in
		let dtd = parse_dtd_entity config (from_string ~alt:[resolver] (get_mathml2_dtd ()))
		in dtd
	with
		exc ->
			print_endline (Pxp_types.string_of_exn exc);
			failwith "Internal error during parsing of built-in MathML2 DTD"

