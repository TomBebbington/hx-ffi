package ffi;

abstract Pointer(Dynamic) {
	@:to public inline function getString() {
		return ffi_get_str(this);
	}
	@:from public static inline function fromString(s:String):Pointer
		return ffi_from_str(s);
	public inline function free():Void
		ffi_free(this);
	static var ffi_get_str:Dynamic = Util.load("get_str", 1);
	static var ffi_from_str:Dynamic = Util.load("from_str", 1);
	static var ffi_free:Dynamic = Util.load("free", 1);
}