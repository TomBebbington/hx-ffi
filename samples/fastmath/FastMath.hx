package samples.fastmath;
import ffi.*;
import ffi.lib.*;
@:lib("m")
class FastMath extends ffi.lib.EasyLibrary {
	public function cos(f:Float):Float;
	public function sin(f:Float):Float;
	public function tan(f:Float):Float;
	public function acos(f:Float):Float;
	public function asin(f:Float):Float;
	public function atan(f:Float):Float;
	public function atan2(a:Float, b:Float):Float;
	public function pow(a:Float, b:Float):Float;
	public function sqrt(f:Float):Float;
	public function floor(f:Float):Float;
	public function ceil(f:Float):Float;
	static function main() {
		var m = new FastMath();
		for(a in Sys.args()) {
			var i = Std.parseFloat(a);
			Sys.println('square root of $i = ${m.sqrt(i)}');
		}
	}
} 