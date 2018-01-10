package ffi.native.neko;
abstract Pointer(Dynamic) {
	@:to public inline function getString():String
		return ffi_ptr_get_str(this, -1);
	@:from public static inline function fromString(s:String):Pointer
		return ffi_ptr_from_str(s);
	public inline function new(bytes:Int):Void
		this = ffi_ptr_alloc(bytes);
	public inline function get(t:ffi.Type, offset:Int = 0):Dynamic
		return ffi_ptr_get(this, t, offset);
	public inline function getAsNekoValue():Dynamic
		return ffi_ptr_get_val(this);
	public inline function free():Void
		ffi_ptr_free(this);
	public inline function getBytes(length:Int):haxe.io.BytesData
		return haxe.io.Bytes.ofString(ffi_ptr_get_str(this, length)).getData();
	static var ffi_ptr_get_str:Dynamic = Util.load("ptr_get_str", 2);
	static var ffi_ptr_from_str:Dynamic = Util.load("ptr_from_str", 1);
	static var ffi_ptr_free:Dynamic = Util.load("ptr_free", 1);
	static var ffi_ptr_get = Util.load("ptr_get", 3);
	static var ffi_ptr_get_val = Util.load("ptr_get_val", 1);
	static var ffi_ptr_alloc = Util.load("ptr_alloc", 1);
}