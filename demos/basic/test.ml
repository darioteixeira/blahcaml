(********************************************************************************)
(*	Test.ml
	Copyright (c) 2008-2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Basic example of Blahcaml.  It tests both the unsafe and safe conversion functions.
*)

let mathtex = "x = \\sqrt{2}"
let mathml = "<math><mrow><mi>x</mi><mo>=</mo><msqrt><mn>2</mn></msqrt></mrow></math>"


let () =
	let res1 = Blahcaml.unsafe_mathml_from_tex ~with_xmlns:true mathtex
	and res2 = Blahcaml.unsafe_mathml_from_tex ~with_xmlns:false mathtex
	in	Printf.printf "unsafe_mathml_from_tex (T): %s\n" res1;
		Printf.printf "unsafe_mathml_from_tex (F): %s\n" res2


let () =
	let res1 = Blahcaml.safe_mathml_from_tex ~with_xmlns:true mathtex
	and res2 = Blahcaml.safe_mathml_from_tex ~with_xmlns:false mathtex
	in	Printf.printf "safe_mathml_from_tex (T): %s\n" res1;
		Printf.printf "safe_mathml_from_tex (F): %s\n" res2



let () =
	let res1 = Blahcaml.sanitize_mathml ~with_xmlns:true mathml
	and res2 = Blahcaml.sanitize_mathml ~with_xmlns:false mathml
	in	Printf.printf "sanitize_mathml (T): %s\n" res1;
		Printf.printf "sanitize_mathml (F): %s\n" res2

