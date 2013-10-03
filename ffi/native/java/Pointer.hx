package ffi.native.java;

import com.sun.jna.Pointer in JPointer;
import com.sun.jna.Memory;
abstract Pointer(JPointer) from JPointer to JPointer {
	public inline function new(bytes:Int)
		this = cast new Memory(haxe.Int64.ofInt(bytes));
	@:to public inline function getString():String
		return this.getString(haxe.Int64.ofInt(0));
	@:from public static function fromString(s:String):Pointer {
		var m = new Memory(haxe.Int64.ofInt(s.length + 1));
		m.setString(haxe.Int64.ofInt(0), s, false);
		return cast m;
	}
	public inline function getBytes(length:Int):haxe.io.BytesData
		return this.getByteArray(haxe.Int64.ofInt(0), length);

	public function get(t:ffi.Type, offset:Int = 0):Dynamic {
		var off64 = haxe.Int64.ofInt(offset);
		return switch(t.type) {
			case Type.TYPE_UINT8, Type.TYPE_SINT8: this.getByte(off64);
			case Type.TYPE_UINT16, Type.TYPE_SINT16: this.getShort(off64);
			case Type.TYPE_UINT64, Type.TYPE_SINT64: this.getLong(off64);
			case Type.TYPE_DOUBLE: this.getDouble(off64);
			case Type.TYPE_FLOAT: this.getFloat(off64);
			case Type.TYPE_POINTER: this.getPointer(off64);
			default: this.getInt(off64);
		}
	}
	@:to public inline function toFunction():Function
		return cast com.sun.jna.Function.getFunction(untyped this);
}