package ffi.lib;

#if(display||xml||macro)
/** A runtime libary **/
extern class Library {
	/** Loads the library at the path - in the case of an error it will throw the low-level error **/
	public static function load(path:String):Library;
	/** Loads a symbol from the library **/
	public function get(name:String):ffi.Pointer;
}
#elseif(nodejs && js)
abstract Library(Dynamic) {
	public static inline function load(path:String):Library
		return untyped __new__(Util.ffi.DynamicLibrary, path);
	@:arrayAccess public inline function get(name:String):ffi.Pointer
		return this.get(name);
}
#elseif java
import com.sun.jna.NativeLibrary;
abstract Library(NativeLibrary) from NativeLibrary to NativeLibrary {
	public static inline function load(path:String):Library
		return cast NativeLibrary.getInstance(path);
	@:arrayAccess public inline function get(name:String):ffi.Pointer
		return cast this.getFunction(name);
}
#else
import sys.io.*;
abstract Library(Dynamic) {
	public static inline function load(path:String):Library
		return ffi_load_library(path);
	@:arrayAccess public inline function get(func:String):ffi.Function
		return ffi_load_symbol(this, func);
	public inline function close():Void
		ffi_close_library(this);
	static var ffi_load_library:Dynamic = ffi.Util.load("load_library", 1);
	static var ffi_close_library:Dynamic = ffi.Util.load("close_library", 1);
	static var ffi_load_symbol:Dynamic = ffi.Util.load("load_symbol", 2);
}
#end