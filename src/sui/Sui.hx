package sui;

#if !macro
import js.Browser;
import js.html.Element;
import sui.components.Grid;
import sui.controls.*;
import sui.controls.Options;
using thx.core.Nulls;
#else
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
using thx.core.Strings;
#end


class Sui {
#if !macro
  public var el(default, null) : Element;
  var grid : Grid;
  public function new() {
    grid = new Grid();
    el = grid.el;
  }

  public function array<T>(?label : String, ?defaultValue : Array<T>, ?defaultElementValue : T, createControl : T -> IControl<T>, ?options : Options, callback : Array<T> -> Void)
    return control(label, new ArrayControl((defaultValue).or([]), defaultElementValue, createControl, options), callback);

  public function bool(?label : String, ?defaultValue = false, ?options : Options, callback : Bool -> Void)
    return control(label, new BoolControl(defaultValue, options), callback);

  public function date(?label : String, ?defaultValue : Date, ?options : OptionsKindDate, callback : Date -> Void) {
    if(null == defaultValue)
      defaultValue = Date.now();
    var ctrl = switch [(options.listonly).or(false), (options.kind).or(null)] {
      case [true, _]:
        new DateSelectControl(defaultValue, options);
      case [_, DateTime]:
        new DateTimeControl(defaultValue, options);
      case _:
        new DateControl(defaultValue, options);
    }
    return control(label, ctrl, callback);
  }

  public function color(?label : String, ?defaultValue = "#AA0000", ?options : OptionsColor, callback : String -> Void)
    return control(label, new ColorControl(defaultValue, options), callback);

  public function float(?label : String, ?defaultValue = 0.0, ?options : OptionsKindFloat, callback : Float -> Void) {
    var ctrl = switch [(options.listonly).or(false), (options.kind).or(null)] {
      case [true, _]:
        new NumberSelectControl<Float>(defaultValue, options);
      case [_, FloatTime]:
        new TimeControl(defaultValue, options);
      case [_, _]:
        (null != options && options.min != null && options.max != null) ?
        new FloatRangeControl(defaultValue, options) :
        new FloatControl(defaultValue, options);
    };
    return control(label, ctrl, callback);
  }

  public function int(?label : String, ?defaultValue = 0, ?options : OptionsKindInt, callback : Int -> Void) {
    var ctrl = (options.listonly).or(false) ?
          new NumberSelectControl<Int>(defaultValue, options) :
          (null != options && options.min != null && options.max != null) ?
            new IntRangeControl(defaultValue, options) :
            new IntControl(defaultValue, options);
    return control(label, ctrl, callback);
  }

  public function label(?defaultValue = "", ?label : String, ?callback : String -> Void)
    return control(label, new LabelControl(defaultValue), callback);

  public function text(?label : String, ?defaultValue = "", ?options : OptionsKindText, callback : String -> Void) {
    var ctrl = switch [(options.listonly).or(false), (options.kind).or(null)] {
      case [true, _]:         new TextSelectControl(defaultValue, options);
      case [_, TextEmail]:    new EmailControl(defaultValue, options);
      case [_, TextPassword]: new PasswordControl(defaultValue, options);
      case [_, TextTel]:      new TelControl(defaultValue, options);
      case [_, TextSearch]:   new SearchControl(defaultValue, options);
      case [_, TextUrl]:      new UrlControl(defaultValue, options);
      case [_, _]:            new TextControl(defaultValue, options);
    };
    return control(label, ctrl, callback);
  }

  public function trigger(actionLabel : String, ?label : String, ?options : Options, callback : Void -> Void)
    return control(label, new TriggerControl(actionLabel, options), function(_) callback());

  // generic binding
  public function control<T, TControl : IControl<T>>(?label : String, control : TControl, callback : T -> Void) : TControl {
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    control.streams.value.subscribe(callback);
    return control;
  }

  public function attach(?el : Element, ?anchor : Anchor) {
    if(null == el) {
      el = Browser.document.body;
    }
    this.el.classList.add((anchor).or(el == Browser.document.body ? topRight : append));
    el.appendChild(this.el);
  }

  static function __init__() {
#if (sui_embed_css == 1)
    dots.Dom.addCss(sui.macro.Embed.file("css/sui.css"));
#end
  }
#end

  // label (readonly?)
  macro public function bind(sui : ExprOf<Sui>, variable : Expr) {
    //trace(sui);
    var id = switch variable.expr {
            case EField(e, field):
              (ExprTools.toString(e) + "." + field).split(".").slice(1).join(".");
            case EConst(CIdent(id)):
              id;
            case _:
              Context.error('invalid expression $variable', variable.pos);
          },
        type = Context.typeof(variable);
    id = id.humanize();
    return switch type {
      case TInst(_.toString() => "String", _):
        macro $e{sui}.text($v{id}, $e{variable}, function(v) $e{variable} = v);
      case TInst(_.toString() => "Date", _):
        macro $e{sui}.date($v{id}, $e{variable}, function(v) $e{variable} = v);
      case TAbstract(_.toString() => "Bool", _):
        macro $e{sui}.bool($v{id}, $e{variable}, function(v) $e{variable} = v);
      case TAbstract(_.toString() => "Float", _):
        macro $e{sui}.float($v{id}, $e{variable}, function(v) $e{variable} = v);
      case TAbstract(_.toString() => "Int", _):
        macro $e{sui}.int($v{id}, $e{variable}, function(v) $e{variable} = v);
      case TFun([],TAbstract(_.toString() => "Void",[])):
        macro $e{sui}.trigger($v{id}, $e{variable});
      case _: Context.error('unsupported type $type', variable.pos);
    };
  }
}

@:enum abstract Anchor(String) to String {
  public var topLeft = "sui-top-left";
  public var topRight = "sui-top-right";
  public var bottomLeft = "sui-bottom-left";
  public var bottomRight = "sui-bottom-right";
  public var fill = "sui-fill";
  public var append = "sui-append";
}