(********************************************************************************)
(*	Implementation file for the Blahcaml library.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open Pxp_core_types
open Pxp_document
open Pxp_yacc


(********************************************************************************)
(**	{2 Privates types and functions}					*)
(********************************************************************************)

(**	The parsed DTD.  If [None], the DTD has not been parsed yet.
*)
let static_dtd = ref None


(********************************************************************************)
(**	{2 Public exceptions}							*)
(********************************************************************************)

(**	Exception raised when the Blahtex core routines encounter an error parsing
	the TeX equation.
*)
exception Blahtex_error of string


(**	Exception raised when an error occurs during the conversion to/from UTF8
	(if the string containing the TeX equation is not valid UTF8, for example).
*)
exception Unicode_converter_error


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

(**	Performs a manual initialisation of the MathML2 DTD.  The DTD must be
	initialised before any of the "safe" functions are invoked (the safe
	functions are {!sanitize_mathml} and {!safe_mathml_from_tex}).  Note
	that this function is automatically called if the DTD has never been
	initialised and you invoke one of the safe functions.   Therefore,
	even though there is no obligation to manually invoke this function,
	because the initialisation can take several seconds to complete, if
	you want predictability on the runtime performance of your application
	you should invoke this function upon initialisation.
*)
let init_dtd () =
	static_dtd := Some (Mathml2dtd.get_dtd ())


(**	Given a string containing potentially unsafe MathML, this function makes
	sure the it conforms to the MathML2 DTD.  If safe, the function returns
	the original string.  If, however, the string does not conform to the DTD,
	a PXP exception is raised.  See the {{:http://projects.camlcity.org/projects/pxp.html}PXP
	documentation} for the meaning of these exceptions.  Note that if the DTD
	has never been initialised, this function will automatically do so upon
	its first invocation (see {!init_dtd} for more information).
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
	please use the {!safe_mathml_from_tex}.  If the Blahtex core routines
	detect an error in the TeX equation, an exception of either {!Blahtex_error}
	or {!Unicode_converter_error} will be raised.
*)
external unsafe_mathml_from_tex: string -> string = "unsafe_mathml_from_tex"


(**	Converts a string containing an equation in TeX format into another string
	containing the same equation in MathML.  The resulting string is checked
	to make sure it conforms to the MathML2 DTD.  If it does not, a PXP exception
	is raised.  See the {{:http://projects.camlcity.org/projects/pxp.html}PXP
        documentation} for the meaning of these exceptions.  Also, if the Blahtex
	core routines detect an error in the TeX equation, an exception of either
	{!Blahtex_error} or {!Unicode_converter_error} will be raised.  Note that
	if the DTD has never been initialised, this function will automatically do
	so upon its first invocation (see {!init_dtd} for more information).
*)
let safe_mathml_from_tex tex_str =
	let unsafe_mathml = unsafe_mathml_from_tex tex_str
	in sanitize_mathml unsafe_mathml


(********************************************************************************)
(**	{2 Module initialisation}						*)
(********************************************************************************)

let () =
	Callback.register_exception "blahtex_error" (Blahtex_error "");
	Callback.register_exception "unicode_converter_error" Unicode_converter_error

