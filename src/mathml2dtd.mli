(********************************************************************************)
(*	Mathml2dtd.mli
	Copyright (c) 2008-2012 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	The [Mathml2dtd] module provides low-level access to the MathML2 DTD.
	Normally, you do not need to access this module directly, because the
	facilities of the {!Blahcaml} module should suffice for most users.
*)

(********************************************************************************)
(**	{1 Public functions}							*)
(********************************************************************************)

(**	Performs a manual initialisation of the MathML2 DTD.  Note that the DTD
	will automatically be initialised if {!get} is called on an uninitialised
	DTD, and therefore the invocation of this function is not mandatory.
	However, because the initialisation may take several seconds to complete,
	if you require predictability on the runtime performance of your application,
	you should invoke this function upon startup.  Subsequent invocations will
	make use of a cached value, and thus return immediately.
*)
val init: unit -> unit

(**	Returns the MathML2 DTD as a PXP value.  If this function is invoked for
	the first time, and a manual initialisation with {!init} was not made, then
	the DTD will have to be initialised, which may take several seconds.  Note
	that subsequent invocations will return a cached result, and will therefore
	complete instantaneously.
*)
val get: unit -> Pxp_dtd.dtd

