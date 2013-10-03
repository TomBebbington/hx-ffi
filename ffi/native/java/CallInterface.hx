package ffi.native.java;

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