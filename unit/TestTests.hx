import haxe.unit.*;
class TestTests extends TestCase {
	var t:Tests;
	public override function setup():Void {
		super.setup();
		t = new Tests();
	}
	public function testCool() {
		assertTrue(t.get_null() == null);
		assertEquals(1337, t.get_cool_int());
		assertEquals("Oranges", t.get_cool_str());
		assertEquals(88, haxe.Int64.toInt(t.add(haxe.Int64.ofInt(34), haxe.Int64.ofInt(54))));
		t.print_str("Hello, world!\n");
	}
	public function testPerson() {
		var personPtr:ffi.Pointer = t.make_person("Tom", 234);
		assertTrue(personPtr != null);
		var name:ffi.Pointer = personPtr.get(ffi.Type.POINTER);
		assertTrue(name != null);
		assertEquals("Tom", haxe.io.Bytes.ofData(name.getBytes(3)).toString());
		assertEquals("Tom", name.getString());
		var person:Person = personPtr.get(Person.TYPE);
		assertEquals("name: Tom, age: 234", person.toString());
		assertEquals("name: Bobaffet, age: 23", new Person("Bobaffet", 23));
		assertEquals("Tom", name.getString());
	}
}
@:struct(Person => {
	var name:String;
	var age:UInt8;
})
@:lib("test/test.so")
class Tests extends ffi.lib.EasyLibrary {
	public function get_cool_int():Int;
	public function get_cool_str():String;
	public function print_str(s:String):Void;
	public function get_null():Pointer;
	public function add(a:UInt64, b:UInt64):UInt64;
	public function make_person(name:String, age:UInt16):Pointer;
}