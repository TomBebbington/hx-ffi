package ffi.native.java;
import haxe.macro.Expr;
import haxe.macro.Type;
import com.sun.jna.*;
class Type {
	public var jtype(default, null):java.lang.Class<Dynamic>;
	public var type(default, null):Int;
	public var size(get, never):Int;
	public var alignment(get, never):Int;
	public var elements(get, never):Null<Array<Type>>;
	inline function get_elements()
		return null;
	public static var VOID(default, never):Type = new Type(TYPE_VOID, untyped __java__("Void.class"));
	public static var UINT8(default, never):Type = new Type(TYPE_UINT8, untyped __java__("Byte.class"));
	public static var SINT8(default, never):Type = new Type(TYPE_SINT8, untyped __java__("Byte.class"));
	public static var UINT16(default, never):Type = new Type(TYPE_UINT16, untyped __java__("Short.class"));
	public static var SINT16(default, never):Type = new Type(TYPE_SINT16, untyped __java__("Short.class"));
	public static var UINT32(default, never):Type = new Type(TYPE_UINT32, untyped __java__("Integer.class"));
	public static var SINT32(default, never):Type = new Type(TYPE_SINT32, untyped __java__("Integer.class"));
	public static var UINT64(default, never):Type = new Type(TYPE_UINT64, untyped __java__("Long.class"));
	public static var SINT64(default, never):Type = new Type(TYPE_SINT64, untyped __java__("Long.class"));
	public static var FLOAT(default, never):Type = new Type(TYPE_FLOAT, untyped __java__("Float.class"));
	public static var DOUBLE(default, never):Type = new Type(TYPE_DOUBLE, untyped __java__("Double.class"));
	public static var UCHAR(default, never):Type = new Type(TYPE_UINT8, untyped __java__("Byte.class"));
	public static var SCHAR(default, never):Type = new Type(TYPE_SINT8, untyped __java__("Byte.class"));
	public static var USHORT(default, never):Type = new Type(TYPE_UINT16, untyped __java__("Short.class"));
	public static var SSHORT(default, never):Type = new Type(TYPE_SINT16, untyped __java__("Short.class"));
	public static var UINT(default, never):Type = new Type(TYPE_UINT32, untyped __java__("Integer.class"));
	public static var SINT(default, never):Type = new Type(TYPE_SINT32, untyped __java__("Integer.class"));
	public static var POINTER(default, never):Type = new Type(TYPE_POINTER, untyped __java__("com.sun.jna.Pointer.class"));
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
	public function new(type:Int, jtype:JClass<Dynamic>) {
		this.type = type;
		this.jtype = jtype;
	}
	inline function get_size():Int
		return Math.ceil(untyped jtype.SIZE / 8);
	inline function get_alignment()
		return get_size();
	@:keep public function toString():String
		return switch(type) {
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
			case TYPE_POINTER: "Pointer";
			default: throw 'Invalid type $type';
		};
	public static function createStruct(elements:Array<Type>):Type {
		throw "Unsupported on Java, sorry";
		return null;
	}
}