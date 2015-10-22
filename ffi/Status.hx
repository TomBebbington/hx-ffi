package ffi;

/** A CIF initialisation status. **/
@:enum abstract Status(Int) {
	/** The CIF worked on the function. **/
	var OK = 0;
	/** The type definition in the CIF does not match the function's. **/
	var BAD_TYPEDEF = 1;
	/** The Application Binary Interface in the CIF does not match the function's. **/
	var BAD_ABI = 2;
}