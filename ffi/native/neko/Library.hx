package ffi.native.neko;

import sys.io.*;

abstract Library(Dynamic) {
	public static inline var LOCAL:Library = null;
	public static inline function load(path:String):Library
		return ffi_load_library(path);
	@:arrayAccess public inline function get(name:String):ffi.Pointer
		return ffi_load_symbol(this, name);
	public inline function close():Void
		ffi_close_library(this);
	static var ffi_load_library:Dynamic = Util.load("load_library", 1);
	static var ffi_close_library:Dynamic = Util.load("close_library", 1);
	static var ffi_load_symbol:Dynamic = Util.load("load_symbol", 2);
}