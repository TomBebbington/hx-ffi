HxFFI
=====
HxFFI is a Haxe library that allows you to quickly use native libraries quickly without any wrappers! It does this using LibFFI and uses a similar method to JNA.

Type mappings
-------------
| C Type			| Haxe Type			| Runtime Haxe Type |
|-------------------|-------------------|-------------------|
| char*				| String			| String 			|
| void*				| Pointer			| ffi.Pointer 		|
| float				| Single			| Float 			|
| double			| Float				| Float 			|
| int 				| Int				| Int				|
| uint 				| UInt				| Int				|
| long 				| Int64				| haxe.Int64		|
| ulong 			| UInt64			| haxe.Int64		|
| int32_t 			| Int32				| Int				|
| uint32_t 			| UInt32			| Int				|
| int16_t / short 	| Int16				| Int				|
| uint16_t / ushort | UInt16			| Int				|
| int8_t / char 	| Int8				| Int				|
| uint8_t / uchar 	| UInt8				| Int				|