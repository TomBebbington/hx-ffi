package ffi;

/** A CIF initialisation status. **/
enum Status {
	/** The CIF worked on the function. **/
	OK;
	/** The type definition in the CIF does not match the function's. **/
	BAD_TYPEDEF;
	/** The Application Binary Interface in the CIF does not match the function's. **/
	BAD_ABI;
}