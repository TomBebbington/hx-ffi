package samples.test;
@:lib("samples/test/test.so")
@:struct(Point => {
	var x:Single;
	var y:Single;
})
class Test extends ffi.lib.EasyLibrary {
	public function fast_sqrt(a:Single):Single;
	public function make_point(x:Single, y:Single):Point;
	public function point_length(p:Point):Single;
	public static function main() {
		var t = new Test();
		trace(t.fast_sqrt(100));
		var p = t.make_point(4, 5);
		trace(p);
		trace(untyped p);
		trace(t.point_length(p));
	}
}