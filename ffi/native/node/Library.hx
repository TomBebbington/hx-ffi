package ffi.native.node;

abstract Library(Dynamic) {
	public static inline function load(path:String):Library
		return untyped __new__(Util.ffi.DynamicLibrary, path);
	@:arrayAccess public inline function get(name:String):ffi.Pointer
		return this.get(name);
}