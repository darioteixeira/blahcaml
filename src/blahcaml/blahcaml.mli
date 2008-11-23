(********************************************************************************)
(*	Interface file for the Blahcaml library.

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


(********************************************************************************)
(**	{2 Public exceptions}							*)
(********************************************************************************)

exception Blahtex_error of string
exception Unicode_converter_error


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val init_dtd: unit -> unit
val sanitize_mathml: string -> string
val unsafe_mathml_from_tex: string -> string
val safe_mathml_from_tex: string -> string

