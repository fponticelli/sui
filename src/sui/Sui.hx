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

#if (haxe_ver >= 3.200)
import haxe.Constraints.IMap;
#else
import Map.IMap;
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

  public function enumMap<TKey, TValue>(?label : String, ?defaultValue : IMap<TKey, TValue>, createKeyControl : TKey -> IControl<TKey>, createValueControl : TValue -> IControl<TValue>, ?options : Options, callback : IMap<TKey, TValue> -> Void)
    return control(label, createEnumMap(defaultValue, createKeyControl, createValueControl, options), callback);

  public function float(?label : String, ?defaultValue = 0.0, ?options : OptionsKindFloat, callback : Float -> Void)
    return control(label, createFloat(defaultValue, options), callback);

  public function folder(label : String) {
    var sui = new Sui(),
        header = {
          el : dots.Html.parse('<header class="sui-folder">$label</header>')
        };
    sui.grid.el.classList.add("sui-grid-inner");
    grid.add(VerticalPair(header, sui.grid));
    return sui;
  }

  public function int(?label : String, ?defaultValue = 0, ?options : OptionsKindInt, callback : Int -> Void)
    return control(label, createInt(defaultValue, options), callback);

  public function intMap<T>(?label : String, ?defaultValue : IMap<Int, T>, createValueControl : T -> IControl<T>, ?options : Options, callback : IMap<Int, T> -> Void)
    return control(label, createIntMap(defaultValue, function(v) return createInt(v), createValueControl, options), callback);

  public function label(?defaultValue = "", ?label : String, ?callback : String -> Void)
    return control(label, createLabel(defaultValue), callback);

  public function objectMap<TKey : {}, TValue>(?label : String, ?defaultValue : IMap<TKey, TValue>, createKeyControl : TKey -> IControl<TKey>, createValueControl : TValue -> IControl<TValue>, ?options : Options, callback : IMap<TKey, TValue> -> Void)
    return control(label, createObjectMap(defaultValue, createKeyControl, createValueControl, options), callback);

  public function stringMap<T>(?label : String, ?defaultValue : IMap<String, T>, createValueControl : T -> IControl<T>, ?options : Options, callback : IMap<String, T> -> Void)
    return control(label, createStringMap(defaultValue, function(v) return createText(v), createValueControl, options), callback);

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
    return switch [(options.listonly).or(false), (options.kind).or(DateOnly)] {
      case [true, _]:
        new DateSelectControl(defaultValue, options);
      case [_, DateTime]:
        new DateTimeControl(defaultValue, options);
      case _:
        new DateControl(defaultValue, options);
    };
  }

  static public function createEnumMap<TKey, TValue>(?defaultValue : IMap<TKey, TValue>, createKeyControl : TKey -> IControl<TKey>, createValueControl : TValue -> IControl<TValue>, ?options : Options)
    return new MapControl(cast defaultValue, function() return new haxe.ds.EnumValueMap<TKey, TValue>(), createKeyControl, createValueControl, options);

  static public function createFloat(?defaultValue = 0.0, ?options : OptionsKindFloat)
    return switch [(options.listonly).or(false), (options.kind).or(FloatNumber)] {
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

  static public function createIntMap<TValue>(?defaultValue : IMap<Int, TValue>, createKeyControl : Int -> IControl<Int>, createValueControl : TValue -> IControl<TValue>, ?options : Options)
    return new MapControl(defaultValue, function() return new haxe.ds.IntMap<TValue>(), createKeyControl, createValueControl, options);

  static public function createLabel(?defaultValue = "", ?label : String, ?callback : String -> Void)
    return new LabelControl(defaultValue);

  static public function createObjectMap<TKey : {}, TValue>(?defaultValue : IMap<TKey, TValue>, createKeyControl : TKey -> IControl<TKey>, createValueControl : TValue -> IControl<TValue>, ?options : Options)
    return new MapControl(defaultValue, function() return new haxe.ds.ObjectMap<TKey, TValue>(), createKeyControl, createValueControl, options);

  static public function createStringMap<TValue>(?defaultValue : IMap<String, TValue>, createKeyControl : String -> IControl<String>, createValueControl : TValue -> IControl<TValue>, ?options : Options)
    return new MapControl(defaultValue, function() return new haxe.ds.StringMap<TValue>(), createKeyControl, createValueControl, options);

  static public function createText(?defaultValue = "", ?options : OptionsKindText)
    return switch [(options.listonly).or(false), (options.kind).or(PlainText)] {
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
    this.el.classList.add((anchor).or(el == Browser.document.body ? Anchor.topRight : Anchor.append));
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
      case TInst(cls, params):
        var fields : Array<Expr> = [];
        cls.get().fields.get().map(function(field) {
          if(!field.isPublic) return;
          var name = field.name;
          switch field.kind {
            case FVar(_, _):
              var createControl = bindType(field.type);
              // TODO remove cast
              var expr = macro sui.control($v{field.name}, $e{createControl}(o.$name), function(v) o.$name = cast v);
              fields.push(expr);
            case FMethod(_):
              var arity = thx.macro.MacroTypes.getArity(Context.follow(field.type));
              if(arity != 0) return;
              var expr = macro sui.control(Sui.createTrigger($v{name}), function(_) o.$name());
              fields.push(expr);
          }
        });
        macro {
          var sui = $e{sui},
              o = $e{variable};
          var folder = sui.folder($v{id});
          $b{fields};
          folder;
        };
      case TAbstract(_.toString() => "Bool", _):
        macro $e{sui}.bool($v{id}, $e{variable}, function(v) $e{variable} = v);
      case TAbstract(_.toString() => "Float", _):
        macro $e{sui}.float($v{id}, $e{variable}, function(v) $e{variable} = v);
      case TAbstract(_.toString() => "Int", _):
        macro $e{sui}.int($v{id}, $e{variable}, function(v) $e{variable} = v);
      case TAbstract(_.toString() => "Map", args):
        var createValueControl = bindType(args[1]);
        switch args[0] {
          case TInst(_.toString() => "Int", _):
            macro $e{sui}.intMap(
              $v{id},
              $e{variable},
              function(v) return $e{createValueControl}(v),
              function(v) $e{variable} = cast v);
          case TInst(_.toString() => "String", _):
            macro $e{sui}.stringMap(
              $v{id},
              $e{variable},
              function(v) return $e{createValueControl}(v),
              function(v) $e{variable} = cast v);
          // TODO enum, object
          case _:
            Context.error('unsupported map/key parameter ${args[0]}', variable.pos);
        }
      case TAbstract(_.toString() => t, e):
        Context.error('unsupported abstract $t, $e', variable.pos);
      case TFun([],TAbstract(_.toString() => "Void",[])):
        macro $e{sui}.trigger($v{id}, $e{variable});
      case _:
        Context.error('unsupported type $type', variable.pos);
    };
  }
#if macro
  public static function bindType(type : haxe.macro.Type) : Expr {
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
      case TAbstract(_.toString() => "Map", args):
        var createKeyControl   = bindType(args[0]),
            createValueControl = bindType(args[1]);
        switch args[0] {
          case TInst(_.toString() => "Int", _):
            macro function(v) return Sui.createIntMap(
              v,
              function(v) return $e{createKeyControl}(v),
              function(v) return $e{createValueControl}(v)
            );
          case TInst(_.toString() => "String", _):
            macro function(v) return Sui.createStringMap(
              v,
              function(v) return $e{createKeyControl}(v),
              function(v) return $e{createValueControl}(v)
            );
          // TODO enum, object
          case _:
            Context.error('unsupported map/key parameter ${args[0]}', Context.currentPos());
        }
      case TAbstract(_.toString() => t, e):
        Context.error('unsupported abstract $t, $e', Context.currentPos());
//      case TAbstract(_.toString() => "Map", e):
//        trace(e);
//        macro Sui.createIntMap;
      case TFun([],TAbstract(_.toString() => "Void",[])):
        macro Sui.createTrigger;
      case _:
        Context.error('unsupported type $type', Context.currentPos());
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