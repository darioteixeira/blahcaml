open Pxp_document
open Pxp_yacc


let () =
	try
		let config = {default_config with encoding = `Enc_utf8} in
		let time1 = Unix.gettimeofday () in
		let dtd = parse_dtd_entity config (from_file "mathml2_dtd/mathml2.dtd") in
		let time2 = Unix.gettimeofday () in
		let marshalled_dtd = Marshal.to_string dtd [Marshal.Closures] in
		let time3 = Unix.gettimeofday () in
		(*let gzip_chan = Gzip.open_out_chan ~level:1 stdout in*)
		(*let () = Gzip.output gzip_chan marshalled_dtd 0 (String.length marshalled_dtd) in*)
		let () = print_string marshalled_dtd in
		let time4 = Unix.gettimeofday ()
		in	Printf.eprintf "DTD pickler: parsing DTD took %5.3f sec.\n" (time2 -. time1);
			Printf.eprintf "DTD pickler: marshalling DTD took %5.3f sec.\n" (time3 -. time2);
			Printf.eprintf "DTD pickler: gzipping DTD took %5.3f sec.\n" (time4 -. time3)
	with
		exc -> print_endline (Pxp_types.string_of_exn exc);

