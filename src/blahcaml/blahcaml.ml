(********************************************************************************)
(*	Blahcaml.ml
	Copyright (c) 2008-2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open Pxp_types
open Pxp_tree_parser
open Pxp_document


(********************************************************************************)
(**	{1 Private functions and values}					*)
(********************************************************************************)

(**	Interface to the C function that actually does the conversion.
*)
external unsafe_mathml_from_tex_stub: string -> string = "unsafe_mathml_from_tex_stub"


(********************************************************************************)
(**	{1 Public exceptions}							*)
(********************************************************************************)

(**	Exception raised when the Blahtex core routines encounter an error parsing
	the TeX equation.
*)
exception Blahtex_error of string


(**	Exception raised when an error occurs during the conversion to/from UTF8
	(if the string containing the TeX equation is not valid UTF8, for example).
*)
exception Unicode_error


(**	Exception raised when even though a fragment conforms to the MathML DTD,
	the top-level element is not [math].
*)
exception Invalid_root


(********************************************************************************)
(**	{1 Public functions and values}						*)
(********************************************************************************)

(**	Performs a manual initialisation of the MathML2 DTD.  The DTD must be
	initialised before any of the safety-related functions are invoked
	(these functions are {!sanitize_mathml} and {!safe_mathml_from_tex}).
	Note that this function is automatically called if the DTD has never
	been initialised and you invoke one of the safety-related functions.
	Therefore, even though there is no obligation to manually invoke this
	function, because the initialisation can take several seconds to complete,
	if you want predictability on the runtime performance of your application
	you should invoke this function upon initialisation.  Note also that this
	function simply calls the low-level function {!Mathml2dtd.init}; therefore,
	 if you are already doing a low-level initialisation you will not need to
	do it again by invoking this function.
*)
let init_dtd () =
	Mathml2dtd.init ()


(**	Given a string containing potentially unsafe MathML, this function makes sure
	the it conforms to the MathML2 DTD.  If safe, the function returns the original
	string.  If, however, the string does not conform to the DTD, a PXP exception
	is raised.  See the {{:http://projects.camlcity.org/projects/pxp.html}PXP
	documentation} for the meaning of these exceptions.  Note that if the DTD
	has never been initialised, this function will automatically do so upon
	its first invocation (see {!init_dtd} for more information).
*)
let sanitize_mathml ?(with_xmlns = true) unsafe_mathml =
	let config = {default_config with encoding = `Enc_utf8} in
	let source = Pxp_types.from_string unsafe_mathml in
	let dtd = Mathml2dtd.get () in
	let spec = Pxp_tree_parser.default_spec in
	let tree = Pxp_tree_parser.parse_content_entity config source dtd spec in
	let () = if tree#node_type <> T_element "math" then raise Invalid_root in
	let tweaker node = match node#node_type with
		| T_element _ ->
			let triager (attname, attvalue) = match attname with
				| "xmlns" -> false
				| "xmlns:xlink" -> false
				| _ -> true
			in node#set_attributes (List.filter triager node#attributes)
		| _ -> () in
	let () = Pxp_document.iter_tree ~pre:tweaker tree in
	let atts = if with_xmlns then [("xmlns", Value "http://www.w3.org/1998/Math/MathML")] else [] in
	let () = tree#set_attributes atts in
	let buffer = Buffer.create 16 in
	let () = tree#display (`Out_buffer buffer) `Enc_utf8
	in Buffer.contents buffer


(**	Converts a string containing an equation in TeX format into another string
	containing the same equation in MathML.  No checking is done to make sure
	the result conforms to the MathML2 DTD!  If that assurance is required
	please use the {!safe_mathml_from_tex}.  If the optional boolean parameter
	[with_xmlns] is true, this function will add the standard MathML namespace
	to the [<math>] element.  Should the Blahtex core routines detect an error
	in the TeX equation, an exception of either {!Blahtex_error} or
	{!Unicode_error} will be raised.
*)
let unsafe_mathml_from_tex ?(with_xmlns = true) tex_str =
	let start_tag = if with_xmlns then "<math xmlns=\"http://www.w3.org/1998/Math/MathML\">" else "<math>"
	and end_tag = "</math>"
	and content = unsafe_mathml_from_tex_stub tex_str
	in start_tag ^ content ^ end_tag


(**	Converts a string containing an equation in TeX format into another string
	containing the same equation in MathML.  If the optional boolean parameter
        [with_xmlns] is true, this function will add the standard MathML namespace
        to the [<math>] element.  The resulting string is checked to make sure it
	conforms to the MathML2 DTD.  If it does not, a PXP exception is raised.
	See the {{:http://projects.camlcity.org/projects/pxp.html}PXP documentation}
	for the meaning of these exceptions.  Also, if the Blahtex core routines
	detect an error in the TeX equation, an exception of either {!Blahtex_error}
	or {!Unicode_error} will be raised.  Note that if the DTD has never been
	initialised, this function will automatically do so upon its first invocation
	(see {!init_dtd} for more information).
*)
let safe_mathml_from_tex ?(with_xmlns = true) tex_str =
	let unsafe_mathml = unsafe_mathml_from_tex ~with_xmlns tex_str
	in sanitize_mathml ~with_xmlns unsafe_mathml


(********************************************************************************)
(**	{1 Module initialisation}						*)
(********************************************************************************)

let () =
	Callback.register_exception "blahtex_error" (Blahtex_error "");
	Callback.register_exception "unicode_error" Unicode_error

