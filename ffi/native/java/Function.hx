package ffi.native.java;
import com.sun.jna.Function in JFunction;
abstract Function(JFunction) from JFunction to JFunction {
	@:to public inline function toPointer():Pointer
		return cast this;
	@:from public static inline function fromPointer(p:Pointer):Function
		return cast JFunction.getFunction(p);
}