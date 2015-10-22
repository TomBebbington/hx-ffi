package ffi.native.neko;

abstract CallInterface(Dynamic) {
	public var returnType(get, never):Type;
	public var argTypes(get, never):Array<Type>;
	inline function get_returnType():Type
		return ffi_cif_get_return_type(this);
	inline function get_argTypes():Array<Type>
		return ffi_cif_get_arg_types(this);
	public inline function new()
		this = ffi_cif_create();
	public inline function prep(args:Array<Type>, ret:Type):Status
		return ffi_cif_prep(this, args, ret);
	public function toString():String
		return (argTypes.length == 0 ? "Void" : argTypes.map(Type.toString).join(" -> ")) + " -> " + returnType.toString();
	public inline function call(fn:Function, args:Array<Dynamic>):Dynamic {
		var r:Dynamic = ffi_cif_call(this, fn, args);
		return switch(returnType.kind) {
			case SINT64 | UINT64:
				haxe.Int64.make(r.high, r.low);
			default: r;
		}
	}
	static var ffi_cif_get_arg_types:Dynamic = Util.load("cif_get_arg_types", 1);
	static var ffi_cif_create:Dynamic = Util.load("cif_create", 0);
	static var ffi_cif_call:Dynamic = Util.load("cif_call", 3);
	static var ffi_cif_prep:Dynamic = Util.load("cif_prep", 3);
	static var ffi_cif_get_return_type:Dynamic = Util.load("cif_get_return_type", 1);
}