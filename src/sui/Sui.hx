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
    return control(label, createArray(defaultValue, defaultElementValue, createControl, options), callback);

  public function bool(?label : String, ?defaultValue = false, ?options : Options, callback : Bool -> Void)
    return control(label, createBool(defaultValue, options), callback);

  public function color(?label : String, ?defaultValue = "#AA0000", ?options : OptionsColor, callback : String -> Void)
    return control(label, createColor(defaultValue, options), callback);

  public function date(?label : String, ?defaultValue : Date, ?options : OptionsKindDate, callback : Date -> Void)
    return control(label, createDate(defaultValue, options), callback);

  public function float(?label : String, ?defaultValue = 0.0, ?options : OptionsKindFloat, callback : Float -> Void)
    return control(label, createFloat(defaultValue, options), callback);

  public function int(?label : String, ?defaultValue = 0, ?options : OptionsKindInt, callback : Int -> Void)
    return control(label, createInt(defaultValue, options), callback);

  public function label(?defaultValue = "", ?label : String, ?callback : String -> Void)
    return control(label, createLabel(defaultValue), callback);

  public function text(?label : String, ?defaultValue = "", ?options : OptionsKindText, callback : String -> Void)
    return control(label, createText(defaultValue, options), callback);

  public function trigger(actionLabel : String, ?label : String, ?options : Options, callback : Void -> Void)
    return control(label, new TriggerControl(actionLabel, options), function(_) callback());

  // statics
  static public function createArray<T>(?defaultValue : Array<T>, ?defaultElementValue : T, createControl : T -> IControl<T>, ?options : Options)
    return new ArrayControl((defaultValue).or([]), defaultElementValue, createControl, options);

  static public function createBool(?defaultValue = false, ?options : Options)
    return new BoolControl(defaultValue, options);

  static public function createColor(?defaultValue = "#AA0000", ?options : OptionsColor)
    return new ColorControl(defaultValue, options);

  static public function createDate(?defaultValue : Date, ?options : OptionsKindDate) {
    if(null == defaultValue)
      defaultValue = Date.now();
    return switch [(options.listonly).or(false), (options.kind).or(null)] {
      case [true, _]:
        new DateSelectControl(defaultValue, options);
      case [_, DateTime]:
        new DateTimeControl(defaultValue, options);
      case _:
        new DateControl(defaultValue, options);
    };
  }

  static public function createFloat(?defaultValue = 0.0, ?options : OptionsKindFloat)
    return switch [(options.listonly).or(false), (options.kind).or(null)] {
      case [true, _]:
        new NumberSelectControl<Float>(defaultValue, options);
      case [_, FloatTime]:
        new TimeControl(defaultValue, options);
      case [_, _]:
        (null != options && options.min != null && options.max != null) ?
        new FloatRangeControl(defaultValue, options) :
        new FloatControl(defaultValue, options);
    };

  static public function createInt(?defaultValue = 0, ?options : OptionsKindInt)
    return (options.listonly).or(false) ?
          new NumberSelectControl<Int>(defaultValue, options) :
          (null != options && options.min != null && options.max != null) ?
            new IntRangeControl(defaultValue, options) :
            new IntControl(defaultValue, options);

  static public function createLabel(?defaultValue = "", ?label : String, ?callback : String -> Void)
    return new LabelControl(defaultValue);

// TODO how to instantiate the right MapControl?
//  static public function createMap<TKey, TValue>(?defaultValue : Map<TKey, TValue>, createKeyControl : TKey -> IControl<TKey>, createValueControl : TValue -> IControl<TValue>, ?options : Options)
//    return new MapControl(defaultValue, defaultElementValue, createControl, options);

  static public function createText(?defaultValue = "", ?options : OptionsKindText)
    return switch [(options.listonly).or(false), (options.kind).or(null)] {
      case [true, _]:         new TextSelectControl(defaultValue, options);
      case [_, TextEmail]:    new EmailControl(defaultValue, options);
      case [_, TextPassword]: new PasswordControl(defaultValue, options);
      case [_, TextTel]:      new TelControl(defaultValue, options);
      case [_, TextSearch]:   new SearchControl(defaultValue, options);
      case [_, TextUrl]:      new UrlControl(defaultValue, options);
      case [_, _]:            new TextControl(defaultValue, options);
    };

  static public function createTrigger(actionLabel : String, ?options : Options)
    return new TriggerControl(actionLabel, options);

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
      case TInst(_.toString() => "Array", t):
        var f = bindType(t[0]);
        macro $e{sui}.array($v{id}, $e{variable}, null,
          function(v) return $e{f}(v),
          function(v) $e{variable} = v);
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
#if macro
  public static function bindType(type : haxe.macro.Type) {
    return switch type {
      case TInst(_.toString() => "String", _):
        macro Sui.createText;
      case TInst(_.toString() => "Date", _):
        macro Sui.createDate;
      case TInst(_.toString() => "Array", t):
        var f = bindType(t[0]);
        macro function(v) return Sui.createArray(v, null, function(v) return $e{f}(v), null);
      case TAbstract(_.toString() => "Bool", _):
        macro Sui.createBool;
      case TAbstract(_.toString() => "Float", _):
        macro Sui.createFloat;
      case TAbstract(_.toString() => "Int", _):
        macro Sui.createInt;
      case TFun([],TAbstract(_.toString() => "Void",[])):
        macro Sui.createTrigger;
      case _: Context.error('unsupported type $type', Context.currentPos());
    };
  }
#end
}

@:enum abstract Anchor(String) to String {
  public var topLeft = "sui-top-left";
  public var topRight = "sui-top-right";
  public var bottomLeft = "sui-bottom-left";
  public var bottomRight = "sui-bottom-right";
  public var fill = "sui-fill";
  public var append = "sui-append";
}