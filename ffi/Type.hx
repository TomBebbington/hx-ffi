package ffi;

#if(!macro && (neko || cpp))
typedef Type = ffi.native.neko.Type;
#elseif java
typedef Type = ffi.native.java.Type;
#elseif(nodejs && js)
typedef Type = ffi.native.node.Type;
#else
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
	public static var POINTER(default, never):Type;
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
	public static function createStruct(elements:Array<Type>):Type;
	/** Return a string representation of the type **/
	public function toString():String;
}
#end