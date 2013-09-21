package ffi;
#if display
/** A pointer to a native function **/
extern class Function extends Pointer {

}
#elseif java
import com.sun.jna.Function in JFunction;
abstract Function(JFunction) from JFunction to JFunction {
	@:to public inline function toPointer():Pointer
		return cast this;
}
#else
abstract Function(Dynamic) to Pointer {

}
#end