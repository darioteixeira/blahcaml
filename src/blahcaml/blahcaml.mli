(********************************************************************************)
(*	Interface file for the Blahcaml library.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

val init_dtd: unit -> unit
val sanitize_mathml: string -> string
val unsafe_mathml_from_tex: string -> string
val safe_mathml_from_tex: string -> string

