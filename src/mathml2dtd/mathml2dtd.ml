(********************************************************************************)
(*	Mathml2dtd.ml
	Copyright (c) 2008-2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open Pxp_types


(********************************************************************************)
(**	{1 Private functions}							*)
(********************************************************************************)

let mathml2_dtd = include_file "mathml2dtd.d/mathml2.dtd"
let mathml2_qname_1_mod = include_file "mathml2dtd.d/mathml2-qname-1.mod"
let isoamsa_ent = include_file "mathml2dtd.d/isoamsa.ent"
let isoamsb_ent = include_file "mathml2dtd.d/isoamsb.ent"
let isoamsc_ent = include_file "mathml2dtd.d/isoamsc.ent"
let isoamsn_ent = include_file "mathml2dtd.d/isoamsn.ent"
let isoamso_ent = include_file "mathml2dtd.d/isoamso.ent"
let isoamsr_ent = include_file "mathml2dtd.d/isoamsr.ent"
let isogrk3_ent = include_file "mathml2dtd.d/isogrk3.ent"
let isomfrk_ent = include_file "mathml2dtd.d/isomfrk.ent"
let isomopf_ent = include_file "mathml2dtd.d/isomopf.ent"
let isomscr_ent = include_file "mathml2dtd.d/isomscr.ent"
let isotech_ent = include_file "mathml2dtd.d/isotech.ent"
let isobox_ent = include_file "mathml2dtd.d/isobox.ent"
let isocyr1_ent = include_file "mathml2dtd.d/isocyr1.ent"
let isocyr2_ent = include_file "mathml2dtd.d/isocyr2.ent"
let isodia_ent = include_file "mathml2dtd.d/isodia.ent"
let isolat1_ent = include_file "mathml2dtd.d/isolat1.ent"
let isolat2_ent = include_file "mathml2dtd.d/isolat2.ent"
let isonum_ent = include_file "mathml2dtd.d/isonum.ent"
let isopub_ent = include_file "mathml2dtd.d/isopub.ent"
let mmlextra_ent = include_file "mathml2dtd.d/mmlextra.ent"
let mmlalias_ent = include_file "mathml2dtd.d/mmlalias.ent"


let catalog =
	[
	(Public ("-//W3C//ENTITIES MathML 2.0 Qualified Names 1.0//EN", ""), mathml2_qname_1_mod);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Arrow Relations for MathML 2.0//EN", ""), isoamsa_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Binary Operators for MathML 2.0//EN", ""), isoamsb_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Delimiters for MathML 2.0//EN", ""), isoamsc_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Negated Relations for MathML 2.0//EN", ""), isoamsn_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Ordinary for MathML 2.0//EN", ""), isoamso_ent);
	(Public ("-//W3C//ENTITIES Added Math Symbols: Relations for MathML 2.0//EN", ""), isoamsr_ent);
	(Public ("-//W3C//ENTITIES Greek Symbols for MathML 2.0//EN", ""), isogrk3_ent);
	(Public ("-//W3C//ENTITIES Math Alphabets: Fraktur for MathML 2.0//EN", ""), isomfrk_ent);
	(Public ("-//W3C//ENTITIES Math Alphabets: Open Face for MathML 2.0//EN", ""), isomopf_ent);
	(Public ("-//W3C//ENTITIES Math Alphabets: Script for MathML 2.0//EN", ""), isomscr_ent);
	(Public ("-//W3C//ENTITIES General Technical for MathML 2.0//EN", ""), isotech_ent);
	(Public ("-//W3C//ENTITIES Box and Line Drawing for MathML 2.0//EN", ""), isobox_ent);
	(Public ("-//W3C//ENTITIES Russian Cyrillic for MathML 2.0//EN", ""), isocyr1_ent);
	(Public ("-//W3C//ENTITIES Non-Russian Cyrillic for MathML 2.0//EN", ""), isocyr2_ent);
	(Public ("-//W3C//ENTITIES Diacritical Marks for MathML 2.0//EN", ""), isodia_ent);
	(Public ("-//W3C//ENTITIES Added Latin 1 for MathML 2.0//EN", ""), isolat1_ent);
	(Public ("-//W3C//ENTITIES Added Latin 2 for MathML 2.0//EN", ""), isolat2_ent);
	(Public ("-//W3C//ENTITIES Numeric and Special Graphic for MathML 2.0//EN", ""), isonum_ent);
	(Public ("-//W3C//ENTITIES Publishing for MathML 2.0//EN", ""), isopub_ent);
	(Public ("-//W3C//ENTITIES Extra for MathML 2.0//EN", ""), mmlextra_ent);
	(Public ("-//W3C//ENTITIES Aiases for MathML 2.0//EN", ""), mmlalias_ent);
	]


let generate () =
	try
		let resolver = new Pxp_reader.lookup_id_as_string catalog in
		let config = {default_config with encoding = `Enc_utf8;} in
		let source = Pxp_types.from_string ~alt:[resolver] mathml2_dtd
		in Pxp_dtd_parser.parse_dtd_entity config source
	with
		exc ->
			print_endline (Pxp_types.string_of_exn exc);
			failwith "Internal error during parsing of built-in MathML2 DTD"


let cache = ref None


(********************************************************************************)
(**	{1 Public functions}							*)
(********************************************************************************)

let init () = match !cache with
	| Some dtd -> ()
	| None	   -> cache := Some (generate ())


let get () = match !cache with
	| Some dtd -> dtd
	| None	   -> let dtd = generate () in cache := Some dtd; dtd

