package sui.macro;

import haxe.macro.Context;
import thx.macro.Macros;

class Embed {
  macro public static function file(path : String) {
    var suiPath = Macros.getModulePath("sui.Sui").split("/").slice(0, -2).join("/")+"/../";
    path = suiPath + path;
    Context.registerModuleDependency("sui.Sui", path);
    var content = sys.io.File.getContent(path);
    return macro $v{content};
  }
}