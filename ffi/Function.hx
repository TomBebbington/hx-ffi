package ffi;
#if(!macro && (neko || cpp))
typedef Function = ffi.native.neko.Function;
#elseif java
typedef Function = ffi.native.java.Function;
#elseif(nodejs && js)
typedef Function = ffi.native.node.Function;
#else
/** A pointer to a native function **/
extern class Function extends Pointer {

}
#end