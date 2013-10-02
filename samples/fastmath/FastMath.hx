package samples.fastmath;
import ffi.*;
import ffi.lib.*;
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
		for(i in [2, 64, 12, 3.4]) {
			trace('square root of $i = ${m.sqrt(i)}');
		}
	}
} 