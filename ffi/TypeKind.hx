package ffi;

@:enum abstract TypeKind(Int) {
	var VOID = 0;
	var INT = 1;
	var FLOAT = 2;
	var DOUBLE = 3;
	var LONGDOUBLE = 4;
	var UINT8 = 5;
	var SINT8 = 6;
	var UINT16 = 7;
	var SINT16 = 8;
	var UINT32 = 9;
	var SINT32 = 10;
	var UINT64 = 11;
	var SINT64 = 12;
	var STRUCT = 13;
	var POINTER = 14;
}