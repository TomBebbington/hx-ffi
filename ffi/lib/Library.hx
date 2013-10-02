package ffi.lib;

#if(!macro && (neko || cpp))
typedef Library = ffi.native.neko.Library;
#elseif java
typedef Library = ffi.native.java.Library;
#elseif(nodejs && js)
typedef Library = ffi.native.node.Library;
#else
/** A runtime shared libary - a .dll on Windows, a .so on Linux and a .dynlib on Mac OS X **/
extern class Library {
	/** The local library **/
	public static var LOCAL(default, never):Library;
	/** The name of the library **/
	public var name(default, never):String;
	/** Loads the library at the path specified - in the case of an error it will throw the low-level error **/
	public static function load(path:String):Library;
	/** Loads a symbol from the library **/
	public function get(name:String):ffi.Pointer;
}
#end