package ffi;

#if(!macro && (neko || cpp))
typedef CallInterface = ffi.native.neko.CallInterface;
#elseif java
typedef CallInterface = ffi.native.java.CallInterface;
#elseif(nodejs && js)
typedef CallInterface = ffi.native.node.CallInterface;
#else
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
#end