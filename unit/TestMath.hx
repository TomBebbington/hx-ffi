import haxe.unit.*;
class TestMath extends TestCase {
	var m:NativeMath;
	public override function setup():Void {
		super.setup();
		m = new NativeMath();
	}
	public function testSqrt():Void {
		assertEquals(10.0, m.sqrt(100));
		assertEquals(2.0, m.sqrt(4));
	}
	public function testPow():Void {
		assertEquals(4.0, m.pow(2, 2));
		assertEquals(25.0, m.pow(5, 2));
		assertEquals(21.0, m.pow(m.sqrt(21), 2));
		assertEquals(256.0, m.pow(2, 8));
	}
	public function testTrig():Void {
		assertEquals(-1.0, m.cos(Math.PI));
		assertEquals(0.0, m.sin(0));
	}
	public function testCbrt():Void {
		for(i in 2...50) {
			var ix:Float = i;
			assertEquals(ix, Math.round(m.cbrt(m.pow(ix, 3))));
		}
	}
	public function testRound():Void {
		assertEquals(-3.0, m.round(-3.4));
		assertEquals(3, haxe.Int64.toInt(m.llround(3.2)));
	}
}
@:lib("m")
class NativeMath extends ffi.lib.EasyLibrary {
	public function cos(x:Float):Float;
	public function tan(x:Float):Float;
	public function sin(x:Float):Float;
	public function acos(x:Float):Float;
	public function atan(x:Float):Float;
	public function asin(x:Float):Float;
	public function sqrt(x:Float):Float;
	public function cbrt(x:Float):Float;
	public function pow(x:Float, y:Float):Float;
	public function round(x:Float):Float;
	public function llround(x:Float):Int64;
}