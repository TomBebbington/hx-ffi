package ffi;
#if (display||xml)
/** Some random utilities used around the library - do not use from outside the library **/
extern class Util {
}
#elseif js
@:allow(ffi)
class Util {
	public static var ffi(default, never):Dynamic = untyped __js__("require('ffi')");
}
#elseif (neko || cpp)
@:allow(ffi)
class Util {
	static inline function toHaxe(v:Dynamic):Dynamic
		return #if neko neko.Lib.nekoToHaxe(v) #else v #end;
	static inline function fromHaxe(v:Dynamic):Dynamic
		return #if neko neko.Lib.haxeToNeko(v) #else v #end;
	static inline function load(fname:String, args:Int):Dynamic
		return #if neko neko.Lib.load("ffi", 'hx_ffi_$fname', args) #elseif cpp cpp.Lib.load("ffi", 'hx_ffi_$fname', args) #else #error "Unsupported" #end;
	#if (neko && !macro)
	static function __init__():Void {
		var init = neko.Lib.load("ffi", "neko_init", 5);
		if(init != null) {
			init(
				function(s) return new String(s),
				function(len:Int) { var r = []; if (len > 0) r[len - 1] = null; return r; },
				null,
				true,
				false);
		} else
			throw "Could not find Neko API interface. Invalid library?";
	}
	#end
}
#end