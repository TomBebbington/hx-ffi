package ffi.native.node;
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