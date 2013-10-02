package ffi.native.node;

abstract Pointer(js.Node.NodeBuffer) from js.Node.NodeBuffer to js.Node.NodeBuffer {
	public inline function new(bytes:Int):Void
		this = new js.Node.NodeBuffer(bytes);
	@:to public inline function getString():String
		return this.toString("utf8");
	public inline function get(t:ffi.Type, offset:Int = 0):Dynamic
		return cast(t, Type.NodeType<Dynamic>).get(this, offset);
	public function getBytes(length:Int):haxe.io.BytesData
		return cast this;
	public function setBytes(bytes:haxe.io.BytesData):Void
		for(i in 0...bytes.length)
			this[i] = bytes[i];
	@:from public static inline function fromString(s:String):Pointer
		return Util.ref.allocCString(s);
	@:op(A == B) public static function eq(a:Pointer, b:Pointer):Bool
		return (a == null && b == null) || (a == null && untyped b.isNull()) || (untyped a.isNull() && b == null);
	public inline function toString():String
		return untyped this.address();
}