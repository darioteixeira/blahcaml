(********************************************************************************)
(*	Main.ml
	Copyright (c) 2008-2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Example using Blahcaml inside Ocsigen/Eliom module.
*)

open XHTML.M


let test_service =
	Eliom_services.new_service 
		~path: [""]
		~get_params: Eliom_parameters.unit
		()


let equation =
	let mathml = Blahcaml.safe_mathml_from_tex "y = \\frac{y^2}{\\sqrt{y-1}}" in
	let elem : [> `Div] XHTML.M.elt = XHTML.M.unsafe_data mathml in
	elem


let test_handler sp () () =
	Lwt.return
		(html
			(head (title (pcdata "Test")) [])
			(body [equation]))


let () =
	Eliom_predefmod.Xhtml.register test_service test_handler

