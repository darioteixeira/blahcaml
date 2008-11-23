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

(**	The parsed DTD.  If [None], the DTD has not been parsed yet.
*)
let static_dtd = ref None


(********************************************************************************)
(*	{2 Public types and functions}						*)
(********************************************************************************)

(**	Exception raised when there's an error.
*)
exception Blahtex_error of string


(**	Initialises the MathML2DTD.  This must be done before any of the "safe"
	functions are invoked.  Note that this function is automatically called
	if the DTD has never been initialised and you invoke one of the "safe"
	functions, [sanitize_mathml] or [safe_mathml_from_tex].  Because the
	initialisation can take several seconds to complete, if you want
	predictability on the runtime performance of your application, you
	should invoke this function upon initialisation of your programme.
*)
let init_dtd () =
	static_dtd := Some (Mathml2dtd.get_dtd ())


(**	Given a string containing potentially unsafe MathML, this function makes
	sure the it conforms to the MathML2 DTD.  If safe, the function returns
	the original string.  If, however, the string does not conform to the DTD,
	an exception is raised.  See the {{:http://projects.camlcity.org/projects/pxp.html}PXP
	documentation} for the meaning of these exceptions.  Note that if the DTD
	has never been initialised, this function will automatically do so upon
	its first invocation.  This operation can take several seconds to complete;
	therefore if you want predictability on the runtime performance of your
	application, invoke [init_dtd] upon initialisation of your programme.
*)
let sanitize_mathml unsafe_mathml =
	let rec get_dtd () = match !static_dtd with
		| Some dtd	-> dtd
		| None		-> init_dtd (); get_dtd () in
	let dtd = get_dtd () in
	let config = {default_config with encoding = `Enc_utf8} in
	let _ = parse_content_entity config (from_string unsafe_mathml) dtd default_spec
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


(********************************************************************************)
(*	{2 Module initialisation}						*)
(********************************************************************************)

let () = Callback.register_exception "blahtex_error" (Blahtex_error "")

