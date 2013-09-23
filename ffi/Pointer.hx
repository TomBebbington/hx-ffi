package ffi;

#if (display||macro||xml)
/** Represents a pointer **/
extern class Pointer {
	/** Get the string stored at this pointer's location **/
	function getString():String;
	/** Find the pointer for the string s **/
	function fromString(s:String):Pointer;
	/** Get this pointer as a certain type **/
	function get(t:ffi.Type):Dynamic;
	/** Get this pointer to a neko value as a neko value **/
	function getAsNekoValue():Dynamic;
	/** Allocate enough space for the given type **/
	public static function alloc(t:ffi.Type):Pointer;
}
#elseif(nodejs && js)
/** Buffer **/
abstract Pointer(Dynamic) {
	@:to public inline function getString():String
		return this.readCString();
	public inline function get(t:ffi.Type):Dynamic
		return untyped t.get(Util.ref.reinterpret(this, t.size, 0));
	@:from public static inline function fromString(s:String):Pointer
		return Util.ref.allocCString(s);
	public static inline function alloc(t:ffi.Type):Pointer
		return Util.ref.alloc(t);
}
#elseif java
import com.sun.jna.Pointer in JPointer;
import com.sun.jna.Memory;
abstract Pointer(JPointer) from JPointer to JPointer {
	@:to public inline function getString():String
		return this.getString(haxe.Int64.ofInt(0));
	@:from public static function fromString(s:String):Pointer {
		var m = new Memory(haxe.Int64.ofInt(s.length + 1));
		m.setString(haxe.Int64.ofInt(0), s, false);
		return cast m;
	}
	public function get(t:ffi.Type):Dynamic {
		return switch(t.type) {
			case Type.TYPE_UINT8, Type.TYPE_SINT8: this.getByte(haxe.Int64.ofInt(0));
			case Type.TYPE_DOUBLE: this.getDouble(haxe.Int64.ofInt(0));
			case Type.TYPE_FLOAT: this.getFloat(haxe.Int64.ofInt(0));
			case Type.TYPE_UINT64, Type.TYPE_SINT64: this.getLong(haxe.Int64.ofInt(0));
			case Type.TYPE_POINTER: this.getPointer(haxe.Int64.ofInt(0));
			default: this.getInt(haxe.Int64.ofInt(0));
		}
	}
}
#else
abstract Pointer(Dynamic) {
	@:to public inline function getString():String
		return ffi_get_str(this);
	@:from public static inline function fromString(s:String):Pointer
		return ffi_from_str(s);
	public inline function get(t:ffi.Type):Dynamic
		return ffi_get_ptr(this, t);
	public inline function getAsNekoValue():Dynamic
		return ffi_get_val(this);
	public inline function free():Void
		ffi_free(this);
	static var ffi_get_str:Dynamic = Util.load("get_str", 1);
	static var ffi_from_str:Dynamic = Util.load("from_str", 1);
	static var ffi_free:Dynamic = Util.load("free", 1);
	static var ffi_get_ptr = Util.load("get_ptr", 2);
	static var ffi_get_val = Util.load("get_val", 1);
}
#end