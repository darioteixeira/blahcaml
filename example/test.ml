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
	let res2 = "<script>" ^ res in
	let res3 = Blahcaml.sanitize_mathml res2
	in Printf.printf "Sanitize : %s\n%!" res3

