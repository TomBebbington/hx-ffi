package ffi.lib;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.*;
using haxe.macro.ComplexTypeTools;
#if display
/** An easily extendible and portable quick way for defining a library in Haxe **/
extern class EasyLibrary {
	/** The underlying library **/
	public var lib(default, null):Library;
	/** The name of the library **/
	public var name(default, null):String;
	/** Loads the library with the given name/path or throws an error **/
	public function new(name:String):Void;
}
#else
#if sys
using sys.io.File;
using sys.FileSystem;
#end
using Lambda;
import ffi.lib.EasyLibrary;
@:autoBuild(ffi.lib.EasyLibrary.build()) class EasyLibrary {
	public static var EXTENSION:String = #if sys switch(Sys.systemName()) {
		case "Windows": "dll";
		case "Mac": "dynlib";
		default: "so";
	} #elseif nodejs
		switch(untyped process.platform) {
			case "darwin", "mac": "dylib";
			case "win32": "dll";
			default: "so";
		}
	#end;
	public var lib(default, null):Library;
	public var name(default, null):String;
	public function new(nameOrPath:String) {
		this.name = nameOrPath;
		if(name.indexOf("/") != -1)
			name = name.substr(name.lastIndexOf("/") + 1);
		var path = #if(nodejs && js && !macro)
			switch(untyped process.platform) {
				case _ if(js.Node.fs.existsSync(nameOrPath) && nameOrPath.indexOf(".") != -1):
					nameOrPath;
				case _ if(js.Node.fs.existsSync('$nameOrPath.$EXTENSION')):
					'$nameOrPath.$EXTENSION';
				case "win32":
					'$nameOrPath.dll';
				case "mac", "darwin":
					'$nameOrPath.dynlib';
				default:
					'lib$nameOrPath.so';
			}
		#elseif sys switch(Sys.systemName()) {
			case _ if(nameOrPath.exists() && nameOrPath.indexOf(".") != -1):
				nameOrPath;
			case _ if('$nameOrPath.$EXTENSION'.exists()):
				'$nameOrPath.$EXTENSION';
			case "Linux", "BSD" if(nameOrPath.indexOf("/") == -1 && nameOrPath.indexOf(".") == -1):
				'lib$nameOrPath.so';
			case "Windows":
				'$nameOrPath.dll';
			default: nameOrPath;
		} #end;
		#if(debug&&!nodejs)
			Sys.println('Loading lib $nameOrPath from $path');
		#end
		this.lib = Library.load(path);
	}
	public inline function toString():String
		return name;
	#if macro
	macro static function build():Array<Field>
		return Builder.build();
	#end
}
#end
#if macro
class Builder {
	public var fields:Array<Field>;
	public var inits:Array<Expr>;
	public var structs:Array<String>;
	public var cifs:Map<String, String>; // type.toString -> cif name
	public function new(fs:Array<Field>) {
		this.fields = fs;
		this.structs = [];
		this.inits = [];
		this.cifs = new Map<String, String>();
	}
	function parseStruct(e:Expr):Expr {
		return switch(e.expr) {
			case EBlock(es):
				var elements = [];
				for(ie in es)
					switch(ie.expr) {
						case EVars(vars):
							for(va in vars) {
								elements.push(toFFIType(va.type));
							}
						default: throw "Bad struct";
					}
				return macro ffi.Type.createStruct(${{expr: EArrayDecl(elements), pos: e.pos}});
			default: throw "Bad struct";
		};
	}
	static function funcToType(f:Function):String {
		return (f.args.length == 0 ? "Void -> ": [for(a in f.args) a.type.toString() + " -> "].join(""))+f.ret.toString();
	}
	public function run():Array<Field> {
		var nfs:Array<Field> = [];
		var localMeta = Context.getLocalClass().get().meta.get();
		for(me in localMeta)
			switch(me) {
				case {name: ":struct", params: [{expr: EBinop(OpArrow, {expr:EConst(CIdent(structName))}, inner)}]}:
					structs.push(structName);
					var td:TypeDefinition = {
						pack: Context.getLocalClass().get().pack,
						name: structName,
						kind: TypeDefKind.TDAbstract(macro:Array<Dynamic>, [], []),
						pos: Context.currentPos(),
						params: [],
						meta: [],
						isExtern: false,
						fields: {
							var fs = [];
							var i = 0;
							switch(inner.expr) {
								case EBlock(es):
									var fields = [];
									for(e in es)
										switch(e.expr) {
											case EVars(vars):
												for(v in vars) {
													fields.push({name: v.name, type: v.type});
													var asHaxe = toHaxeType(v.type);
													fs.push({meta: null, access: [APublic], doc: null, name: v.name, pos: e.pos, kind: FieldType.FProp("get", "set", asHaxe)});
													fs.push({meta: null, access: [APrivate, AInline], doc: null, name: 'get_${v.name}', pos: e.pos, kind: FieldType.FFun({
														ret: asHaxe,
														params: [],
														args: [],
														expr: macro return ${convertToHaxe(macro this[$v{i}], v.type)}
													})});
													fs.push({meta: null, access: [APrivate, AInline], doc: null, name: 'set_${v.name}', pos: e.pos, kind: FieldType.FFun({
														ret: asHaxe,
														params: [],
														args: [{name: "v", opt: false, type: asHaxe}],
														expr: macro {
															this[$v{i}] = v;
															return v;
														}
													})});
													i++;
												}
											default:
										}
									var fieldDesc = {expr: EArrayDecl([for(f in fields) macro $v{f.name}+": "+$i{"get_"+f.name}()]), pos: inner.pos};
									
									fs.push({meta: [{pos: inner.pos, params: [], name: ":to"}], access: [APublic, AInline], doc: null, name: "toString", pos: inner.pos, kind: FieldType.FFun({
										ret: macro:String,
										params: [],
										args: [],
										expr: macro return $fieldDesc.join(", ")
									})});
									fs.push({meta: null, doc: null, pos: inner.pos, name: "TYPE", kind: FieldType.FVar(macro:ffi.Type, parseStruct(inner)), access: [APublic, AStatic]});
									var initExpr:Expr = {expr: EArrayDecl([for(f in fields) convertFromHaxe({expr:EConst(CIdent(f.name)), pos: inner.pos}, f.type)]), pos: inner.pos};
									fs.push({meta: null, access: [APublic, AInline], doc: null, name: "new", pos: inner.pos, kind: FieldType.FFun({
										ret: macro:Void,
										params: [],
										args: [for(f in fields) {name: f.name, opt: true, type: toHaxeType(f.type)}],
										expr: macro this = $initExpr
									})});
								default:
							}
							fs;
						}
					};
					Context.defineType(td);
					#if debug
					Sys.println(new haxe.macro.Printer().printTypeDefinition(td));
					#end
				default:
			}
		for(f in fields) {
			if(Lambda.has(f.access, AStatic) || Lambda.has(f.access, AInline)) {
				nfs.push(f);
				continue;
			}
			switch(f.kind) {
				case FVar(type, expr):
					f.kind = FieldType.FProp("get", "never", type);
					nfs.push(f);
					var getExpr = macro return this.lib[$v{f.name}].get(${toFFIType(type)});
					var getter = Reflect.copy(f);
					getter.name = 'get_${f.name}';
					getter.kind = FFun({expr: convertToHaxe(getExpr, type), ret: toHaxeType(type), args: []});
					nfs.push(getter);
				case FFun(ofc):
					var ef = Reflect.copy(f);
					ef.kind = FieldType.FFun(Reflect.copy(ofc));
					var nfc:Function = ef.kind.getParameters()[0];
					nfc.args = [for(a in nfc.args)
						{name: a.name, type: toHaxeType(a.type), opt: a.opt}];
					nfc.ret = toHaxeType(nfc.ret);
					var of = Reflect.copy(f);
					of.name = '_sym_${f.name}';
					of.kind = FieldType.FVar(macro:ffi.Function);
					inits.push(macro $i{of.name} = lib[$v{f.name}]);
					nfs.push(of);
					var type = funcToType(ofc);
					var cifname = if(!cifs.exists(type)) {
						var cif = Reflect.copy(ef);
						var rx = ~/[^a-zA-Z0-9_]/g;
						cif.name = '_cif_${rx.replace(type, "")}';
						cif.kind = FieldType.FVar(macro:ffi.CallInterface);
						inits.push(macro $i{cif.name} = new ffi.CallInterface());
						nfs.push(cif);
						inits.push(macro $i{cif.name}.prep(${{expr: EArrayDecl([for(a in ofc.args) toFFIType(a.type)]), pos: Context.currentPos()}}, ${toFFIType(f.kind.getParameters()[0].ret)}));
						cifs.set(type, cif.name);
						cif.name;
					} else {
						cifs.get(type);
					}
					var fexpr = macro $i{cifname}.call($i{of.name}, ${{pos: ef.pos, expr: EArrayDecl([for(a in nfc.args) ${convertFromHaxe(macro $i{a.name}, a.type)}])}});
					#if !debug fexpr = macro try $fexpr catch(e:Dynamic) throw e+" in "+$v{f.name}; #end
					f.kind = FieldType.FFun({
						ret: nfc.ret,
						params: [],
						args: nfc.args,
						expr: switch(nfc.ret) {
							case macro:Void: fexpr;
							default: macro return ${convertToHaxe(fexpr, nfc.ret)}
						}
					});
					nfs.push(f);
				default:
			}
		}
		var libName:String = null;
		for(me in localMeta)
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
		#if debug
		trace(new haxe.macro.Printer().printTypeDefinition({
			pos: Context.currentPos(),
			params: [],
			pack: [],
			name: libName,
			meta: [],
			kind: TypeDefKind.TDClass(),
			isExtern: false,
			fields: nfs
		}));
		#end
		return nfs;
	}
	public function convertToHaxe(v:Expr, t:ComplexType) {
		return switch(t) {
			case macro:Void: v;
			case macro:String: macro {
				var p:ffi.Pointer = $v;
				return p.getString();
			};
			case macro:Bool: macro $v > 0;
			default: v;
		};
	}
	public function convertFromHaxe(v:Expr, t:ComplexType) {
		return switch(t) {
			case macro:Void: v;
			case macro:String: macro ffi.Pointer.fromString($v);
			case macro:Bool: macro $v ? 1 : 0;
			default: v;
		};
	}
	public function toHaxeType(c:ComplexType):ComplexType {
		return switch(c) {
			case macro:Int64, macro:haxe.Int64, macro:UInt64, macro:haxe.UInt64, macro:Long, macro:ULong: macro:haxe.Int64;
			case TPath({pack: [], params: [], name: name}) if(name.indexOf("Int") != -1): macro:Int;
			case macro:Float, macro:Single: macro:Float;
			case TPath({pack: [], params: _, name: "Pointer"}): macro:ffi.Pointer;
			case TPath({pack: [], params: [], name: name}) if(structs.has(name)): TPath({params: [], pack: [], name: name});
			default: c;
		};
	}
	public function toFFIType(c:ComplexType):Expr {
		return switch(c) {
			case macro:String: macro ffi.Type.POINTER;
			case macro:Float: macro ffi.Type.DOUBLE;
			case macro:Single: macro ffi.Type.FLOAT;
			case TPath({pack: [], params: _, name: "Pointer"}):
				macro ffi.Type.POINTER;
			case macro:Bool: macro ffi.Type.UINT8;
			case TPath({pack: [], params: [], name: name}) if(structs.has(name)):
				macro $i{name}.TYPE;
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