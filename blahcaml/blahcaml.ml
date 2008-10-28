(********************************************************************************)
(*										*)
(********************************************************************************)

open Pxp_core_types
open Pxp_document
open Pxp_yacc


(********************************************************************************)
(*										*)
(********************************************************************************)

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


(********************************************************************************)
(*										*)
(********************************************************************************)

external get_pickle: pickle_t -> string = "get_pickle"

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


let static_dtd = ref None


let config =
	{
	default_config with
	encoding = `Enc_utf8
	}


(********************************************************************************)
(*										*)
(********************************************************************************)

let init_dtd () =
	try
		let resolver = new Pxp_reader.lookup_id_as_string catalog in
		let dtd = parse_dtd_entity config (from_string ~alt:[resolver] (get_pickle Pickled_mathml2_dtd))
		in static_dtd := Some dtd
	with
		exc -> print_endline (Pxp_types.string_of_exn exc)


let sanitize_mathml unsafe_mathml =
	let rec get_dtd () = match !static_dtd with
		| Some dtd	-> dtd
		| None		-> init_dtd (); get_dtd () in
	let dtd = get_dtd ()
	in try
                let _ = Pxp_yacc.parse_content_entity config (from_string unsafe_mathml) dtd default_spec in
		unsafe_mathml
        with
                exc ->
			print_endline (Pxp_types.string_of_exn exc);
			failwith "oops"


external unsafe_mathml_from_tex: string -> string = "unsafe_mathml_from_tex"


let safe_mathml_from_tex tex_str =
	let unsafe_mathml = unsafe_mathml_from_tex tex_str
	in sanitize_mathml unsafe_mathml

