(********************************************************************************)
(*	Test.ml
	Copyright (c) 2008-2013 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Example using Blahcaml inside Ocsigen/Eliom module.
*)

open Eliom_content
open Html5.F


let test_service =
	Eliom_service.service 
		~path: [""]
		~get_params: Eliom_parameter.unit
		()


let equation =
	let mathml = Blahcaml.safe_mathml_from_tex "y = \\frac{y^2}{\\sqrt{y-1}}" in
	let elem : [> `Div] Html5.F.elt = Html5.F.unsafe_data mathml in
	elem


let test_handler () () =
	Lwt.return
		(html
			(head (title (pcdata "Test")) [])
			(body [equation]))


let () =
	Eliom_registration.Html5.register test_service test_handler

