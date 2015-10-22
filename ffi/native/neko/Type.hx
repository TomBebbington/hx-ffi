package ffi.native.neko;

import ffi.TypeKind;

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
	public static inline function createStruct(elements:Array<Type>):Type
		return ffi_make_struct_type(elements);
	public inline function toString():String
		return get_kind().toString();

	inline function get_alignment():Int
		return ffi_get_type_alignment(this);
	inline function get_kind():TypeKind
		return cast ffi_get_type_type(this);
	inline function get_size():Int
		return ffi_get_type_size(this);
	inline function get_elements():Array<Type>
		return ffi_type_get_elements(this);
	public var kind(get, never):TypeKind;
	public var size(get, never):Int;
	public var alignment(get, never):Int;
	public var elements(get, never):Null<Array<Type>>;
	static var ffi_get_type_alignment:Dynamic = Util.load("get_type_alignment", 1);
	static var ffi_get_type_type:Dynamic = Util.load("get_type_type", 1);
	static var ffi_get_type_size:Dynamic = Util.load("get_type_size", 1);
	static var ffi_make_struct_type:Dynamic = Util.load("make_struct_type", 1);
	static var ffi_type_get_elements:Dynamic = Util.load("type_get_elements", 1);
}