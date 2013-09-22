import haxe.unit.*;
class TestTests extends TestCase {
	var t:Tests;
	public override function setup():Void {
		super.setup();
		t = new Tests();
	}
	public function testCool() {
		assertEquals(null, t.get_null());
		assertEquals(1337, t.get_cool_int());
		trace(t.get_cool_str());
		assertEquals("Oranges", t.get_cool_str());
		var p:ffi.Pointer = "hello, world!\n";
		t.print_str(p);
	}
}
@:lib("test/test.so")
class Tests extends ffi.lib.EasyLibrary {
	public function get_cool_int():Int;
	public function get_cool_str():String;
	public function print_str(s:String):Void;
	public function get_null():Pointer;
}