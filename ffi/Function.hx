package ffi;
#if(!macro && !doc && (neko || cpp))
typedef Function = ffi.native.neko.Function;
#elseif(!doc && java)
typedef Function = ffi.native.java.Function;
#elseif(!doc && nodejs && js)
typedef Function = ffi.native.node.Function;
#else
/** A pointer to a native function **/
extern class Function extends Pointer {

}
#end