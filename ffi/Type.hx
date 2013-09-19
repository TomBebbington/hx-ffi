package ffi;

#if display
/** A native type **/
extern class Type {
	/** The type represented as an int **/
	public var type(default, never):Int;
	/** The size of the type, in bytes **/
	public var size(default, never):Int;
	/** The alignment of the type, in bytes **/
	public var alignment(default, never):Int;
	/** The elements belonging to this type if this is a struct, or null otherwise **/
	public var elements(default, never):Null<Array<Type>>;
	/** Void type **/
	public static var VOID(default, never):Type;
	/** Unsigned 8-bit integer type **/
	public static var UINT8(default, never):Type;
	/** Signed 8-bit integer type **/
	public static var SINT8(default, never):Type;
	/** Unsigned 16-bit integer type **/
	public static var UINT16(default, never):Type;
	/** Signed 16-bit integer type **/
	public static var SINT16(default, never):Type;
	/** Unsigned 32-bit integer type **/
	public static var UINT32(default, never):Type;
	/** Signed 32-bit integer type **/
	public static var SINT32(default, never):Type;
	/** Unsigned 64-bit integer type **/
	public static var UINT64(default, never):Type;
	/** Signed 64-bit integer type **/
	public static var SINT64(default, never):Type;
	/** 32-bit float type **/
	public static var FLOAT(default, never):Type;
	/** 64-bit float type **/
	public static var DOUBLE(default, never):Type;
	/** Unsigned char type **/
	public static var UCHAR(default, never):Type;
	/** Signed char type **/
	public static var SCHAR(default, never):Type;
	/** Unsigned short type **/
	public static var USHORT(default, never):Type;
	/** Signed short type **/
	public static var SSHORT(default, never):Type;
	/** Unsigned native int type **/
	public static var UINT(default, never):Type;
	/** Signed native int type **/
	public static var SINT(default, never):Type;
	/** Pointer type **/
	public static var Pointer(default, never):Type;
	/** Void type **/
	public static var TYPE_VOID(default, never):Int;
	/** Native integer type **/
	public static var TYPE_INT(default, never):Int;
	/** 32-bit floating-point type **/
	public static var TYPE_FLOAT(default, never):Int;
	/** 64-bit floating-point type **/
	public static var TYPE_DOUBLE(default, never):Int;
	/** 128-bit floating-point type **/
	public static var TYPE_LONGDOUBLE(default, never):Int;
	/** Unsigned 8-bit integer type **/
	public static var TYPE_UINT8(default, never):Int;
	/** Signed 8-bit integer type **/
	public static var TYPE_SINT8(default, never):Int;
	/** Unsigned 16-bit integer type **/
	public static var TYPE_UINT16(default, never):Int;
	/** Signed 16-bit integer type **/
	public static var TYPE_SINT16(default, never):Int;
	/** Unsigned 32-bit integer type **/
	public static var TYPE_UINT32(default, never):Int;
	/** Signed 32-bit integer type **/
	public static var TYPE_SINT32(default, never):Int;
	/** Unsigned 64-bit integer type **/
	public static var TYPE_UINT64(default, never):Int;
	/** Signed 64-bit integer type **/
	public static var TYPE_SINT64(default, never):Int;
	/** Struct type **/
	public static var TYPE_STRUCT(default, never):Int;
	/** Pointer type **/
	public static var TYPE_POINTER(default, never):Int;
	/** Creates a struct with the specified elements **/
	public static function createStruct(elements:Array<String>):Type;
	/** Return a string representation of the type **/
	public function toString():String;
}
#else
import Type in HxType;
import haxe.ds.Vector;
abstract Type(Dynamic) {
	public static var VOID(default, never):Type = ffi.Util.load("type_void", 0)();
	public static var UINT8(default, never):Type = ffi.Util.load("type_uint8", 0)();
	public static var SINT8(default, never):Type = ffi.Util.load("type_sint8", 0)();
	public static var UINT16(default, never):Type = ffi.Util.load("type_uint16", 0)();
	public static var SINT16(default, never):Type = ffi.Util.load("type_sint16", 0)();
	public static var UINT32(default, never):Type = ffi.Util.load("type_uint32", 0)();
	public static var SINT32(default, never):Type = ffi.Util.load("type_sint32", 0)();
	public static var UINT64(default, never):Type = ffi.Util.load("type_uint64", 0)();
	public static var SINT64(default, never):Type = ffi.Util.load("type_sint64", 0)();
	public static var FLOAT(default, never):Type = ffi.Util.load("type_float", 0)();
	public static var DOUBLE(default, never):Type = ffi.Util.load("type_double", 0)();
	public static var UCHAR(default, never):Type = ffi.Util.load("type_uchar", 0)();
	public static var SCHAR(default, never):Type = ffi.Util.load("type_schar", 0)();
	public static var USHORT(default, never):Type = ffi.Util.load("type_ushort", 0)();
	public static var SSHORT(default, never):Type = ffi.Util.load("type_sshort", 0)();
	public static var UINT(default, never):Type = ffi.Util.load("type_uint", 0)();
	public static var SINT(default, never):Type = ffi.Util.load("type_sint", 0)();
	public static var POINTER(default, never):Type = ffi.Util.load("type_pointer", 0)();
	public static inline var TYPE_VOID:Int = 0;
	public static inline var TYPE_INT:Int = 1;
	public static inline var TYPE_FLOAT:Int = 2;
	public static inline var TYPE_DOUBLE:Int = 3;
	public static inline var TYPE_LONGDOUBLE:Int = 4;
	public static inline var TYPE_UINT8:Int = 5;
	public static inline var TYPE_SINT8:Int = 6;
	public static inline var TYPE_UINT16:Int = 7;
	public static inline var TYPE_SINT16:Int = 8;
	public static inline var TYPE_UINT32:Int = 9;
	public static inline var TYPE_SINT32:Int = 10;
	public static inline var TYPE_UINT64:Int = 11;
	public static inline var TYPE_SINT64:Int = 12;
	public static inline var TYPE_STRUCT:Int = 13;
	public static inline var TYPE_POINTER:Int = 14;
	public static inline function createStruct(elements:Array<Type>):Type
		return ffi_make_struct_type(elements);
	@:to public function toString():String {
		var t = get_type();
		var es = get_elements();
		return switch(t) {
			case TYPE_VOID: "Void";
			case TYPE_INT: "Int";
			case TYPE_FLOAT: "Single";
			case TYPE_DOUBLE: "Double";
			case TYPE_LONGDOUBLE: "LongDouble";
			case TYPE_UINT8: "UInt8";
			case TYPE_SINT8: "Int8";
			case TYPE_UINT16: "UInt16";
			case TYPE_SINT16: "Int16";
			case TYPE_UINT32: "UInt32";
			case TYPE_SINT32: "Int32";
			case TYPE_UINT64: "UInt64";
			case TYPE_SINT64: "Int64";
			case TYPE_STRUCT: "{" + [for(e in 0...es.length) es[e].toString()].join(", ") + "}";
			case TYPE_POINTER: "Pointer";
			default: throw 'Invalid type $t';
		};
	}
	inline function get_alignment():Int
		return ffi_get_type_alignment(this);
	inline function get_type():Int
		return ffi_get_type_type(this);
	inline function get_size():Int
		return ffi_get_type_size(this);
	inline function get_elements():Array<Type>
		return ffi_type_get_elements(this);
	public var type(get, never):Int;
	public var size(get, never):Int;
	public var alignment(get, never):Int;
	public var elements(get, never):Null<Array<Type>>;
	static var ffi_get_type_alignment:Dynamic = ffi.Util.load("get_type_alignment", 1);
	static var ffi_get_type_type:Dynamic = ffi.Util.load("get_type_type", 1);
	static var ffi_get_type_size:Dynamic = ffi.Util.load("get_type_size", 1);
	static var ffi_make_struct_type:Dynamic = ffi.Util.load("make_struct_type", 1);
	static var ffi_type_get_elements:Dynamic = ffi.Util.load("type_get_elements", 1);
}
#end