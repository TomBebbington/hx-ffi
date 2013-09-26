package ffi;

#if display
/** Describes a callable function's interface **/
extern class CallInterface {
	/** The type it returns **/
	public var returnType(default, never):Type;
	/** The arguments it accepts **/
	public var argTypes(default, never):Array<Type>;
	/** Constructs an empty calling interface **/
	public function new():Void;
	/** Prepares it for calling by providing type information to the API **/
	public function prep(args:Array<Type>, ret:Type):Status;
	/** Returns the result of calling fn with the arguments specified **/
	public function call(fn:Function, args:Array<Dynamic>):Dynamic;
	/** Returns a string representation of the function **/
	public function toString():String;
}
#elseif(nodejs && js)
class CallInterface {
	public var returnType(default, null):Type;
	public var argTypes(default, null):Array<Type>;
	public function new():Void {
		this.returnType = null;
		this.argTypes = null;
	}
	public function prep(args:Array<Type>, ret:Type):Status {
		this.argTypes = args;
		this.returnType = ret;
		return Status.OK;
	}
	public function call(fn:Function, args:Array<Dynamic>):Dynamic {
		for(i in 0...argTypes.length) {
			if(untyped argTypes[i].name.indexOf("int64") != -1)
				args[i] = haxe.Int64.toInt(args[i]);
		}
  		var func = Util.ffi.ForeignFunction(fn, returnType, argTypes);
		var r:Dynamic = Reflect.callMethod(null, func, args);
		return if(returnType.elements != null)
			[for(f in Reflect.fields(r))
				Reflect.field(r, f)];
		else if(untyped returnType.name.indexOf("int64") != -1)
			haxe.Int64.ofInt(r | 0);
		else r;
	}
	public function toString():String
		return (argTypes.length == 0 ? "Void" : [for(a in argTypes) a.toString()].join(" -> ")) + " -> " + returnType.toString();
}
#elseif java
class CallInterface {
	public var returnType(default, null):Type;
	public var argTypes(default, null):Array<Type>;
	public function new():Void {
		this.returnType = null;
		this.argTypes = null;
	}
	public function prep(args:Array<Type>, ret:Type):Status {
		this.argTypes = args;
		this.returnType = ret;
		return Status.OK;
	}
	public function call(fn:Function, args:Array<Dynamic>):Dynamic {
		var jnaFunc:com.sun.jna.Function = fn;
		return jnaFunc.invoke(returnType.jtype, haxe.ds.Vector.fromArrayCopy(args).toData());
	}
	public function toString():String
		return (argTypes.length == 0 ? "Void" : [for(a in argTypes) a.toString()].join(" -> ")) + " -> " + returnType.toString();
}
#else
import Type in HxType;
/** Note: ABI is assumed to be JIT_ABI_DEFAULT **/
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
		return HxType.createEnumIndex(Status, ffi_cif_prep(this, args, ret));
	public function toString():String
		return (argTypes.length == 0 ? "Void" : argTypes.map(Type.toString).join(" -> ")) + " -> " + returnType.toString();
	public inline function call(fn:Function, args:Array<Dynamic>):Dynamic {
		var r:Dynamic = ffi_cif_call(this, fn, args);
		return switch(returnType.type) {
			case ffi.Type.TYPE_SINT64, ffi.Type.TYPE_UINT64:
				haxe.Int64.make(r.high, r.low);
			default: r;
		}
	}
	static var ffi_cif_get_arg_types:Dynamic = ffi.Util.load("cif_get_arg_types", 1);
	static var ffi_cif_create:Dynamic = ffi.Util.load("cif_create", 0);
	static var ffi_cif_call:Dynamic = ffi.Util.load("cif_call", 3);
	static var ffi_cif_prep:Dynamic = ffi.Util.load("cif_prep", 3);
	static var ffi_cif_get_return_type:Dynamic = ffi.Util.load("cif_get_return_type", 1);
}
#end