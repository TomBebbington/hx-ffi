package ffi.native.node;

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
	public var type(get, never):Int;
	public var size(get, never):Int;
	public var alignment(get, never):Int;
	public var elements(get, never):Null<Array<Type>>;
	inline function get_elements():Array<Type>
		return this.fields == null ? null : [for(f in Reflect.fields(this.fields)) Reflect.field(this.fields, f).type];
	function get_type():Int
		return switch(this.name) {
			case "void": TYPE_VOID;
			case "int", "uint": TYPE_INT;
			case "float": TYPE_FLOAT;
			case "double": TYPE_DOUBLE;
			case "uint8": TYPE_UINT8;
			case "int8": TYPE_SINT8;
			case "uint16": TYPE_UINT16;
			case "int16": TYPE_SINT16;
			case "uint32": TYPE_UINT32;
			case "int32": TYPE_SINT32;
			case "uint64": TYPE_UINT64;
			case "int64": TYPE_SINT64;
			case "StructType": TYPE_STRUCT;
			case all: throw 'Unrecognised type $all';
		};
	inline function get_alignment():Int
		return this.alignment;
	inline function get_size():Int
		return this.size;
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
			case TYPE_STRUCT: "{" + [for(e in elements) e.toString()].join(", ") + "}";
			case TYPE_POINTER: "Pointer";
			default: throw 'Invalid type $type';
		};
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
}