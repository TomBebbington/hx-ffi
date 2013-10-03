package ffi;

#if(!macro && (neko || cpp))
typedef Pointer = ffi.native.node.Pointer;
#elseif java
typedef Pointer = ffi.native.java.Pointer;
#elseif(nodejs && js)
typedef Pointer = ffi.native.neko.Pointer;
#else
/** Represents a pointer **/
extern class Pointer {
	/** Allocate the space given **/
	public function new(bytes:Int);
	/** Get the string stored at this pointer's location **/
	function getString():String;
	/** Find the pointer for the string s **/
	function fromString(s:String):Pointer;
	/** Get this pointer as a certain type at the offset given **/
	function get(type:ffi.Type, ?offset:Int):Dynamic;
	/** Get this pointer to a neko value as a neko value **/
	function getAsNekoValue():Dynamic;
	/** Get this pointer as a bytes with the length specified **/
	function getBytes(length:Int):haxe.io.BytesData;
	/** Writes to this pointer with the bytes given **/
	function setBytes(bytes:haxe.io.BytesData):Void;
}
#end