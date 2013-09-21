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
	/** Get this pointer as a neko value **/
	function getValue():Dynamic;
}
#elseif java
import com.sun.jna.Pointer in JPointer;
import com.sun.jna.Memory;
abstract Pointer(JPointer) from JPointer to JPointer {
	public inline function getString():String
		return this.getString(haxe.Int64.ofInt(0));
	public inline function fromString(s:String):Pointer {
		var m = new Memory(haxe.Int64.ofInt(s.length + 1));
		m.setString(haxe.Int64.ofInt(0), s, false);
		return cast m;
	}
}
#else
abstract Pointer(Dynamic) {
	public inline function new(v:Dynamic)
		this = v;
	@:to public inline function getString() {
		return ffi_get_str(this);
	}
	@:from public static inline function fromString(s:String):Pointer
		return ffi_from_str(s);
	public inline function get(t:ffi.Type):Dynamic
		return ffi_get_ptr(this, t);
	public inline function getValue():Dynamic
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