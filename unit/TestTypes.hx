import haxe.unit.*;
import ffi.Type.*;
class TestTypes extends TestCase {
	public function testInt():Void {
		assertEquals(4, SINT32.size);
		assertEquals(null, SINT32.elements);
	}
	public function testStruct():Void {
		var s = createStruct([SINT32, UINT32]);
		assertEquals("{Int32, UInt32}", s.toString());
	}
}