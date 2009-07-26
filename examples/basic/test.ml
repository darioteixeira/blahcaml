(********************************************************************************)
(*	Test.ml
	Copyright (c) 2008-2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Basic example of Blahcaml.  It tests both the unsafe and safe conversion
	functions.
*)

let () =
	let tex = "x=\\frac{y}{2}" in
	let res = Blahcaml.unsafe_mathml_from_tex tex
	in Printf.printf "Unsafe   : %s\n%!" res


let () =
	let tex = "x=\\frac{y}{2}" in
	let res = Blahcaml.safe_mathml_from_tex tex
	in Printf.printf "Safe     : %s\n%!" res


let () =
	let tex = "x=\\frac{y}{2}" in
	let res = Blahcaml.unsafe_mathml_from_tex tex in
	let res2 = Blahcaml.sanitize_mathml res
	in Printf.printf "Sanitize : %s\n%!" res2

