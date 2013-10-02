package ffi.native.neko;

@:allow(ffi)
class Util {
	static inline function toHaxe(v:Dynamic):Dynamic
		return neko.Lib.nekoToHaxe(v);
	static inline function fromHaxe(v:Dynamic):Dynamic
		return neko.Lib.haxeToNeko(v);
	static inline function load(fname:String, args:Int):Dynamic
		return #if neko neko #else cpp #end.Lib.load("ffi", 'hx_ffi_$fname', args);
	#if(!macro && neko)
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