HxFFI
=====
HxFFI is a Haxe library that allows you to quickly use native libraries quickly without any wrappers! It does this using LibFFI and uses a similar method to JNA.

Supported types
---------------
 C Type				| EasyLibrary Type			| Haxe Type			| FFI Type
--------------------|---------------------------|-------------------|---------------------------
void				| Void 						| Void 				| ffi.Type.VOID
char*				| String					| String 			| ffi.Type.POINTER
void*				| Pointer					| ffi.Pointer 		| ffi.Type.POINTER
float				| Single					| Float 			| ffi.Type.FLOAT
double				| Float						| Float 			| ffi.Type.DOUBLE
int 				| Int / SInt				| Int				| ffi.Type.INT
uint 				| UInt						| Int				| ffi.Type.UINT
long 				| Int64 / SInt64			| haxe.Int64		| ffi.Type.SINT64
ulong 				| UInt64					| haxe.Int64		| ffi.Type.UINT64
int32_t 			| Int32	/ SInt32			| Int				| ffi.Type.SINT32
uint32_t 			| UInt32					| Int				| ffi.Type.UINT32
int16_t / short 	| Int16	/ SInt16			| Int				| ffi.Type.SINT16
uint16_t / ushort 	| UInt16					| Int				| ffi.Type.UINT16
int8_t / char 		| Int8 / SInt8				| Int				| ffi.Type.SINT8
uint8_t / uchar 	| UInt8						| Int				| ffi.Type.UINT8
struct				| Struct<ordered types...>	| Array<Dynamic>	| ffi.Type.createStruct(...)