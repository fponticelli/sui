package sui.macro;

import haxe.macro.Context;

class Embed {
  macro public static function file(path : String) {
    path = Sys.getCwd() + path;
    Context.registerModuleDependency("sui.Sui", path);
    var content = sys.io.File.getContent(path);
    return macro $v{content};
  }
}