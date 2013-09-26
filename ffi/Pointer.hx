package ffi;

#if (display||macro||xml)
/** Represents a pointer **/
extern class Pointer {
	/** Allocate the space given **/
	public function new(bytes:Int);
	/** Get the string stored at this pointer's location **/
	function getString():String;
	/** Find the pointer for the string s **/
	function fromString(s:String):Pointer;
	/** Get this pointer as a certain type at the offset given **/
	function get(type:ffi.Type, ?offset:Int):Dynamic;
	/** Get this pointer to a neko value as a neko value **/
	function getAsNekoValue():Dynamic;
	/** Get this pointer as a bytes with the length specified **/
	function getBytes(length:Int):haxe.io.BytesData;
}
#elseif(nodejs && js)
/** Buffer **/
abstract Pointer(js.Node.NodeBuffer) {
	@:to public inline function getString():String
		return this.toString("utf8");
	public inline function get(t:ffi.Type, offset:Int = 0):Dynamic
		return untyped t.get(Util.ref.reinterpret(this, t.size, offset));
	@:from public static inline function fromString(s:String):Pointer
		return Util.ref.allocCString(s);
	public static inline function alloc(bytes:Int):Pointer
		return Util.ref.alloc(bytes);
	@:op(A == B) public static function eq(a:Pointer, b:Pointer):Bool
		return (a == null && b == null) || (a == null && untyped b.isNull()) || (untyped a.isNull() && b == null);
}
#elseif java
import com.sun.jna.Pointer in JPointer;
import com.sun.jna.Memory;
abstract Pointer(JPointer) from JPointer to JPointer {
	public inline function new(bytes:Int)
		return cast new Memory(haxe.Int64.ofInt(bytes));
	@:to public inline function getString():String
		return this.getString(haxe.Int64.ofInt(0));
	@:from public static function fromString(s:String):Pointer {
		var m = new Memory(haxe.Int64.ofInt(s.length + 1));
		m.setString(haxe.Int64.ofInt(0), s, false);
		return cast m;
	}
	public inline function getBytes(length:Int):haxe.io.BytesData
		return this.getByteArray(haxe.Int64.ofInt(0), length);

	public function get(t:ffi.Type, offset:Int = 0):Dynamic {
		var off64 = haxe.Int64.ofInt(offset);
		return switch(t.type) {
			case Type.TYPE_UINT8, Type.TYPE_SINT8: this.getByte(off64);
			case Type.TYPE_UINT16, Type.TYPE_SINT16: this.getShort(off64);
			case Type.TYPE_UINT64, Type.TYPE_SINT64: this.getLong(off64);
			case Type.TYPE_DOUBLE: this.getDouble(off64);
			case Type.TYPE_FLOAT: this.getFloat(off64);
			case Type.TYPE_POINTER: this.getPointer(off64);
			default: this.getInt(off64);
		}
	}
}
#else
abstract Pointer(Dynamic) {
	@:to public inline function getString():String
		return ffi_get_str(this);
	@:from public static inline function fromString(s:String):Pointer
		return ffi_from_str(s);
	public inline function get(t:ffi.Type, offset:Int = 0):Dynamic
		return ffi_get_ptr(this, t, offset);
	public inline function getAsNekoValue():Dynamic
		return ffi_get_val(this);
	public inline function free():Void
		ffi_free(this);
	static var ffi_get_str:Dynamic = Util.load("get_str", 1);
	static var ffi_from_str:Dynamic = Util.load("from_str", 1);
	static var ffi_free:Dynamic = Util.load("free", 1);
	static var ffi_get_ptr = Util.load("get_ptr", 3);
	static var ffi_get_val = Util.load("get_val", 1);
}
#end