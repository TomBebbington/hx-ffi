package ffi.native.node;

import ffi.TypeKind;

extern class NodeType<T> {
	var name:String;
	var size:Int;
	var indirection:Int;
	var alignment:Int;
	var fields:Null<Dynamic<NodeType<Dynamic>>>;
	function get(b:js.Node.NodeBuffer, offset:Int):T;
	function set(b:js.Node.NodeBuffer, offset:Int, value:T):Void;
}

abstract Type(NodeType<Dynamic>) from NodeType<Dynamic> to NodeType<Dynamic> {
	public var kind(get, never): TypeKind;
	public var size(get, never):Int;
	public var alignment(get, never):Int;
	public var elements(get, never):Null<Array<Type>>;
	inline function get_elements():Array<Type>
		return this.fields == null ? null : [for(f in Reflect.fields(this.fields)) Reflect.field(this.fields, f).type];
	function get_kind():TypeKind
		return switch(this.name) {
			case "void": TypeKind.VOID;
			case "int", "uint": TypeKind.INT;
			case "float": TypeKind.FLOAT;
			case "double": TypeKind.DOUBLE;
			case "uint8": TypeKind.UINT8;
			case "int8": TypeKind.SINT8;
			case "uint16": TypeKind.UINT16;
			case "int16": TypeKind.SINT16;
			case "uint32": TypeKind.UINT32;
			case "int32": TypeKind.SINT32;
			case "uint64": TypeKind.UINT64;
			case "int64": TypeKind.SINT64;
			case "StructType": TypeKind.STRUCT;
			case all: throw 'Unrecognised type $all';
		};
	inline function get_alignment():Int
		return this.alignment;
	inline function get_size():Int
		return this.size;
	public inline function toString():String
		return get_kind().toString();
	public static function createStruct(elements:Array<Type>):Type {
		var obj:Dynamic = {};
		for(i in 0...elements.length)  {
			if(elements[i] == null)
				throw '$elements contains null element';
			Reflect.setField(obj, 'e$i', elements[i]);
		}
		return Util.struct(obj);
	}
	public static var VOID(default, never):Type = Util.ref.types.void;
	public static var UINT8(default, never):Type = Util.ref.types.uint8;
	public static var SINT8(default, never):Type = Util.ref.types.int8;
	public static var UINT16(default, never):Type = Util.ref.types.uint16;
	public static var SINT16(default, never):Type = Util.ref.types.int16;
	public static var UINT32(default, never):Type = Util.ref.types.uint32;
	public static var SINT32(default, never):Type = Util.ref.types.int32;
	public static var UINT64(default, never):Type = Util.ref.types.uint64;
	public static var SINT64(default, never):Type = Util.ref.types.int64;
	public static var FLOAT(default, never):Type = Util.ref.types.float;
	public static var DOUBLE(default, never):Type = Util.ref.types.double;
	public static var UCHAR(default, never):Type = Util.ref.types.uchar;
	public static var SCHAR(default, never):Type = Util.ref.types.char;
	public static var USHORT(default, never):Type = Util.ref.types.ushort;
	public static var SSHORT(default, never):Type = Util.ref.types.short;
	public static var UINT(default, never):Type = Util.ref.types.uint;
	public static var SINT(default, never):Type = Util.ref.types.int;
	public static var POINTER(default, never):Type = Util.ref.refType(Util.ref.types.void);
}