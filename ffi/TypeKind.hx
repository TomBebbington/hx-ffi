package ffi;

/**
	A unique integer identifier for a type.
**/
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
	public function toString():String
		return switch(this) {
			case TypeKind.VOID: "Void";
			case TypeKind.INT: "Int";
			case TypeKind.FLOAT: "Single";
			case TypeKind.DOUBLE: "Float";
			case TypeKind.LONGDOUBLE: "Double";
			case TypeKind.UINT8: "UInt8";
			case TypeKind.SINT8: "SInt8";
			case TypeKind.UINT16: "UInt16";
			case TypeKind.SINT16: "SInt16";
			case TypeKind.UINT32: "UInt32";
			case TypeKind.SINT32: "SInt32";
			case TypeKind.UINT64: "UInt64";
			case TypeKind.SINT64: "SInt64";
			case TypeKind.STRUCT: "Struct";
			case TypeKind.POINTER: "Pointer";
			default: "Unknown";
		};
}