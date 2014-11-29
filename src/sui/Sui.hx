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

  public function bool(?label : String, ?defaultValue = false, ?options : Options, callback : Bool -> Void) {
    var control = new BoolControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }
  public function array<T>(?label : String, ?defaultValue : Array<T>, ?defaultElementValue : T, createControl : T -> IControl<T>, ?options : Options, callback : Array<T> -> Void)
    return control(label, new ArrayControl((defaultValue).or([]), defaultElementValue, createControl, options), callback);


  public function date(?label : String, ?defaultValue : Date, ?options : OptionsKindDate, callback : Date -> Void) {
    if(null == defaultValue)
      defaultValue = Date.now();
    var control = switch [(options.listonly).or(false), (options.kind).or(null)] {
      case [true, _]:
        new DateSelectControl(defaultValue, options);
      case [_, DateTime]:
        new DateTimeControl(defaultValue, options);
      case _:
        new DateControl(defaultValue, options);
    }
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function color(?label : String, ?defaultValue = "#AA0000", ?options : OptionsColor, callback : String -> Void) {
    var control = new ColorControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function float(?label : String, ?defaultValue = 0.0, ?options : OptionsKindFloat, callback : Float -> Void) {
    var control = switch [(options.listonly).or(false), (options.kind).or(null)] {
      case [true, _]:
        new NumberSelectControl<Float>(defaultValue, options);
      case [_, FloatTime]:
        new TimeControl(defaultValue, options);
      case [_, _]:
        (null != options && options.min != null && options.max != null) ?
        new FloatRangeControl(defaultValue, options) :
        new FloatControl(defaultValue, options);
    };
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function int(?label : String, ?defaultValue = 0, ?options : OptionsKindInt, callback : Int -> Void) {
    var control = (options.listonly).or(false) ?
          new NumberSelectControl<Int>(defaultValue, options) :
          (null != options && options.min != null && options.max != null) ?
            new IntRangeControl(defaultValue, options) :
            new IntControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function label(?defaultValue = "", ?label : String, ?callback : String -> Void) {
    var control = new LabelControl(defaultValue);
    if(null != callback)
      control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function text(?label : String, ?defaultValue = "", ?options : OptionsKindText, callback : String -> Void) {
    var control = switch [(options.listonly).or(false), (options.kind).or(null)] {
      case [true, _]:         new TextSelectControl(defaultValue, options);
      case [_, TextEmail]:    new EmailControl(defaultValue, options);
      case [_, TextPassword]: new PasswordControl(defaultValue, options);
      case [_, TextTel]:      new TelControl(defaultValue, options);
      case [_, TextSearch]:   new SearchControl(defaultValue, options);
      case [_, TextUrl]:      new UrlControl(defaultValue, options);
      case [_, _]:            new TextControl(defaultValue, options);
    };
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function trigger(actionLabel : String, ?label : String, ?options : Options, callback : Void -> Void) {
    var control = new TriggerControl(actionLabel, options);
    control.streams.value.subscribe(function(_) callback());
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  // generic binding
  public function control<T>(?label : String, control : IControl<T>, callback : T -> Void) {
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    control.streams.value.subscribe(callback);
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