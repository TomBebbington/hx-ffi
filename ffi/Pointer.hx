package ffi;

#if(!macro && (neko || cpp))
typedef Pointer = ffi.native.neko.Pointer;
#elseif java
typedef Pointer = ffi.native.java.Pointer;
#elseif(nodejs && js)
typedef Pointer = ffi.native.node.Pointer;
#else
/** Represents a pointer **/
extern class Pointer {
	/**
		Allocate the number of bytes given.
		@param bytes The number of bytes to allocate for.
	**/
	public function new(bytes:Int);
	/**
		Get the string stored at this pointer's location.
		@return The string stored.
	**/
	function getString():String;
	/**
		Allocate a pointer for the string given.
		@param text The string to allocate for.
		@return The pointer allocated.
	**/
	function fromString(text:String):Pointer;
	/**
		Get this pointer as a certain type at the offset given.
		@param type The type to get the pointer as.
		@param offset The offset to add to this pointer.
		@return The content of this pointer.
	**/
	function get(type:ffi.Type, ?offset:Int):Dynamic;
	/**
		Get this pointer to a neko value as a neko value.
		@return The value.
	**/
	function getAsNekoValue():Dynamic;
	/**
		Get this pointer as a bytes with the length specified.
		@param length The length of the bytes to get.
		@return The bytes.
	**/
	function getBytes(length:Int):haxe.io.BytesData;

	/**
		Writes to this pointer with the bytes given.
		@param bytes The bytes to set.
	**/
	function setBytes(bytes:haxe.io.BytesData):Void;
}
#end