import haxe.unit.*;
class Unit {
	static function main() {
		var r = new TestRunner();
		r.add(new TestMath());
		r.add(new TestTests());
		r.run();
	}
}