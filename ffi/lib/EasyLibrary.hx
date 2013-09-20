package ffi.lib;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.*;
#if display
/** An easily extendible and portable quick way for defining a library in Haxe **/
extern class EasyLibrary {
	/** The underlying library **/
	public var lib(default, null):Library;
	/** Loads the library with the name/path or throws an error **/
	public function new(name:String):Void;
}
#else
@:autoBuild(ffi.lib.EasyLibrary.Builder.build()) class EasyLibrary {
	public var lib(default, null):Library;
	public function new(name:String) {
		this.lib = Library.load(name);
		if(lib == null)
			throw 'Could not load library "$name"';
	}
}
#end
#if macro
class Builder {
	public var fields:Array<Field>;
	public function new(fs:Array<Field>) {
		this.fields = fs;
	}
	public function run():Array<Field> {
		var nfs = [];
		var inits = [];
		for(f in fields) {
			if(Lambda.has(f.access, AStatic) || Lambda.has(f.access, AInline)) {
				nfs.push(f);
				continue;
			}
			var ofc:Function = cast f.kind.getParameters()[0];
			switch(f.kind) {
				case FFun(fc):
					var pr = new haxe.macro.Printer();
					var ef = Reflect.copy(f);
					ef.kind = FieldType.FFun(Reflect.copy(ofc));
					var nfc:Function = ef.kind.getParameters()[0];
					nfc.args = [for(a in nfc.args)
						{name: a.name, type: toHaxeType(a.type), opt: a.opt}];
					nfc.ret = toHaxeType(nfc.ret);
					var of = Reflect.copy(f);
					of.name = '_sym_${f.name}';
					of.kind = FieldType.FVar(macro:ffi.Function);
					inits.push(macro $i{of.name} = lib.getSymbol($v{f.name}));
					nfs.push(of);
					var cif = Reflect.copy(ef);
					cif.name = '_cif_${f.name}';
					cif.kind = FieldType.FVar(macro:ffi.Cif);
					inits.push(macro $i{cif.name} = new ffi.Cif());
					nfs.push(cif);
					inits.push(macro $i{cif.name}.prep(${{expr: EArrayDecl([for(a in ofc.args) toFFIType(a.type)]), pos: Context.currentPos()}}, ${toFFIType(f.kind.getParameters()[0].ret)}));
					var fexpr = macro $i{cif.name}.call($i{of.name}, ${{pos: cif.pos, expr: EArrayDecl([for(a in nfc.args) macro $i{a.name}])}});
					f.kind = FieldType.FFun({
						ret: nfc.ret,
						params: [],
						args: nfc.args,
						expr: (ComplexTypeTools.toString(nfc.ret) == "Void") ? fexpr : macro return $fexpr
					});
					nfs.push(f);
				default:
			}
		}
		var libName:String = null;
		for(me in Context.getLocalClass().get().meta.get())
			switch(me) {
				case {name: ":lib"| "lib"| ":library"| "library" | "nlib" | ":nlib", params: [{expr: EConst(CString(name))}]}:
					libName = name;
				default:
			}
		if(libName == null)
			throw "Library path or native name must be specified";
		var initBlock = {expr: EBlock(inits), pos: Context.currentPos()};
		nfs.push({access: [APublic], pos: Context.currentPos(), name: "new", kind: FieldType.FFun({ret: macro:Void, params: [], args: [], expr: macro  {
			super($v{libName});
			$initBlock;
		}})});
		return nfs;
	}
	public function toHaxeType(c:ComplexType):ComplexType {
		return switch(c) {
			case macro:Int64, macro:haxe.Int64, macro:UInt64, macro:haxe.UInt64: macro:haxe.Int64;
			case TPath({pack: [], params: [], name: name}) if(name.indexOf("Int") != -1): macro:Int;
			case macro:Float, macro:Single: macro:Float;
			case TPath({pack: [], params: _, name: "Pointer"}): macro:ffi.Pointer;
			default: c;
		};
	}
	public function toFFIType(c:ComplexType):Expr {
		return switch(c) {
			case macro:String: macro ffi.Type.POINTER;
			case macro:Float: macro ffi.Type.DOUBLE;
			case macro:Single: macro ffi.Type.DOUBLE;
			case TPath({pack: [], params: _, name: "Pointer"}):
				macro ffi.Type.POINTER;
			case TPath({pack: [], params: [], name: name}):
				var ename = name.toUpperCase();
				if(StringTools.startsWith(ename, "INT"))
					ename = "S" + ename;
				macro ffi.Type.$ename;
			default: throw 'Unsupported type ${haxe.macro.ComplexTypeTools.toString(c)}';
		}
	}
	public static function build():Array<Field> {
		var fs = Context.getBuildFields();
		return new Builder(fs).run();
	}
}
#end