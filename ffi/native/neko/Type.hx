package ffi.native.neko;
import Type in HxType;
import haxe.ds.Vector;
abstract Type(Dynamic) {
	public static var VOID(default, never):Type = Util.load("type_void", 0)();
	public static var UINT8(default, never):Type = Util.load("type_uint8", 0)();
	public static var SINT8(default, never):Type = Util.load("type_sint8", 0)();
	public static var UINT16(default, never):Type = Util.load("type_uint16", 0)();
	public static var SINT16(default, never):Type = Util.load("type_sint16", 0)();
	public static var UINT32(default, never):Type = Util.load("type_uint32", 0)();
	public static var SINT32(default, never):Type = Util.load("type_sint32", 0)();
	public static var UINT64(default, never):Type = Util.load("type_uint64", 0)();
	public static var SINT64(default, never):Type = Util.load("type_sint64", 0)();
	public static var FLOAT(default, never):Type = Util.load("type_float", 0)();
	public static var DOUBLE(default, never):Type = Util.load("type_double", 0)();
	public static var UCHAR(default, never):Type = Util.load("type_uchar", 0)();
	public static var SCHAR(default, never):Type = Util.load("type_schar", 0)();
	public static var USHORT(default, never):Type = Util.load("type_ushort", 0)();
	public static var SSHORT(default, never):Type = Util.load("type_sshort", 0)();
	public static var UINT(default, never):Type = Util.load("type_uint", 0)();
	public static var SINT(default, never):Type = Util.load("type_sint", 0)();
	public static var POINTER(default, never):Type = Util.load("type_pointer", 0)();
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
	@:to @:keep public function toString():String {
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
	static var ffi_get_type_alignment:Dynamic = Util.load("get_type_alignment", 1);
	static var ffi_get_type_type:Dynamic = Util.load("get_type_type", 1);
	static var ffi_get_type_size:Dynamic = Util.load("get_type_size", 1);
	static var ffi_make_struct_type:Dynamic = Util.load("make_struct_type", 1);
	static var ffi_type_get_elements:Dynamic = Util.load("type_get_elements", 1);
}