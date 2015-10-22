package ffi;

#if(!macro && !doc && (neko || cpp))
typedef CallInterface = ffi.native.neko.CallInterface;
#elseif(!doc && java)
typedef CallInterface = ffi.native.java.CallInterface;
#elseif(!doc && nodejs && js)
typedef CallInterface = ffi.native.node.CallInterface;
#else
/** Describes a callable function's interface. **/
extern class CallInterface {
	/** The type this function returns. **/
	public var returnType(default, never):Type;
	/** The types of the arguments this function accepts. **/
	public var argTypes(default, never):Array<Type>;
	/** Constructs an empty calling interface. **/
	public function new():Void;
	/**
		Prepares it for calling by providing type information to the API.
		@param args The types of the arguments this function accepts.
		@param ret The return type of this function.
		@return The status of this action.
	**/
	public function prep(args:Array<Type>, ret:Type):Status;
	/**
		Calls the function with the arguments given.
		@param fn The function to call.
		@param args The arguments to call it with.
		@return The return value of the function.
	**/
	public function call(fn:Function, args:Array<Dynamic>):Dynamic;

	/** Returns a string representation of the function. **/
	public function toString():String;
}
#end