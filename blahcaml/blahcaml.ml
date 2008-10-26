open Pxp_document
open Pxp_yacc


external get_pickled_dtd: unit -> string = "get_pickled_dtd"


let static_dtd = ref None


let init () =
	print_string "Initialising DTD...";
	let pickled_dtd = get_pickled_dtd () in
	let dtd : Pxp_dtd.dtd = Marshal.from_string pickled_dtd 0 in
	static_dtd := Some dtd;
	print_endline " Done!"


let sanitize_mathml unsafe_mathml =
	let rec get_dtd () = match !static_dtd with
		| Some dtd	-> dtd
		| None		-> init (); get_dtd () in
	let dtd = get_dtd ()
	in try
		let config = {default_config with encoding = `Enc_utf8} in
                let _ = Pxp_yacc.parse_content_entity config (from_string unsafe_mathml) dtd default_spec in
		unsafe_mathml
        with
                exc ->
			print_endline (Pxp_types.string_of_exn exc);
			failwith "oops"


external unsafe_mathml_from_tex: UTF8.t -> UTF8.t = "unsafe_mathml_from_tex"


let safe_mathml_from_tex tex_str =
	let unsafe_mathml = unsafe_mathml_from_tex tex_str
	in sanitize_mathml unsafe_mathml

