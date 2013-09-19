package ffi.lib;

#if display
/** A runtime libary **/
extern class Library {
	/** Loads the library matching the path or returns null if it could not be loaded **/
	public static function load(path:String):Null<Library>;
	/** Loads a symbol from the library **/
	public function getSymbol(func:String):ffi.Function;
	/** Closes the library. MUST be called after using it to avoid memory leaks **/
	public function close():Void;
}
#else
abstract Library(Dynamic) {
	public static inline function load(path:String):Library
		return ffi_load_library(path);
	public inline function getSymbol(func:String):ffi.Function
		return ffi_load_symbol(this, func);
	public inline function close():Void
		ffi_close_library(this);
	static var ffi_load_library:Dynamic = ffi.Util.load("load_library", 1);
	static var ffi_close_library:Dynamic = ffi.Util.load("close_library", 1);
	static var ffi_load_symbol:Dynamic = ffi.Util.load("load_symbol", 2);
}
#end