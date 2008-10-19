let () =
	let tex = "x=\\frac{y}{2}" in
	let res = Blahcaml.unsafe_mathml_from_tex tex
	in print_endline res


