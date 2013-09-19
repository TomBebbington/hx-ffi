import ffi.*;
import ffi.lib.*;
class Test {
	static function main() {
		var s = new Sdl();
		var screen:Pointer = s.SDL_SetVideoMode(640, 480, 0, 0);
		s.SDL_WM_SetCaption("Hello, wonderful world of Haxe!", null);
		s.SDL_Delay(2000);
		s.SDL_FreeSurface(screen);
		s.SDL_Quit();
		s.lib.close();
	}
}
@:lib("SDL")
class Sdl extends ffi.lib.EasyLibrary {
	public function SDL_Init(flags:UInt32):SInt;
	public function SDL_BlitSurface(src:Pointer, srcrect:Pointer, dest:Pointer, destrect:Pointer):Int;
	public function SDL_SetVideoMode(width:Int, height:Int, bpp:Int, flags: UInt32):Pointer;
	public function SDL_LoadBMP(filename:String):Pointer;
	public function SDL_Flip(surface:Pointer):Int;
	public function SDL_Delay(milliseconds:Int):Void;
	public function SDL_FreeSurface(surface:Pointer):Void;
	public function SDL_Quit():Void;
	public function SDL_WM_SetCaption(title:Pointer, icon:Pointer):Void;
	public function SDL_FillRect(dst:Pointer, dstrect:Pointer, color:UInt32):Int32;
} 