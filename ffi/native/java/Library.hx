package ffi.native.java;

import com.sun.jna.NativeLibrary;

abstract Library(NativeLibrary) from NativeLibrary to NativeLibrary {
	public static var LOCAL(get, never):Library;
	static inline function get_LOCAL():Library
		return cast NativeLibrary.getProcess();
	public var name(get, never):String;
	inline function get_name():String
		return this.getName();
	public static inline function load(path:String):Library
		return cast NativeLibrary.getInstance(path);
	@:arrayAccess public inline function get(name:String):ffi.Pointer
		return cast this.getGlobalVariableAddress(name);
}