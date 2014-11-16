package sui;

import js.html.Element;
import sui.components.Grid;
import sui.controls.*;
import sui.controls.Options;

class Sui {
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

/*
  public function date(?label : String, ?defaultValue : Date, callback : Date -> Void) {
    if(null == defaultValue)
      defaultValue = Date.now();
    var control = new DateControl(defaultValue);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function color(?label : String, ?defaultValue = "#AA0000", callback : String -> Void) {
    var control = new ColorControl(defaultValue);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function float(?label : String, ?defaultValue = 0.0, ?min : Float, ?max : Float, ?step : Float = 0.01, ?allowNaN = false, callback : Float -> Void) {
    var control = (min != null && max != null) ? new FloatRangeControl(defaultValue, min, max, step) : new FloatControl(defaultValue, allowNaN);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function int(?label : String, ?defaultValue = 0, ?min : Int, ?max : Int, ?step : Int = 1, callback : Int -> Void) {
    var control = (min != null && max != null) ? new IntRangeControl(defaultValue, min, max, step) : new IntControl(defaultValue);
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
*/
  public function password(?label : String, ?defaultValue = "", ?options : OptionsText, callback : String -> Void) {
    var control = new PasswordControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function text(?label : String, ?defaultValue = "", ?options : OptionsText, callback : String -> Void) {
    var control = new TextControl(defaultValue, options);
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

  // general binding
  public function control<T>(?label : String, control : IControl<T>, callback : T -> Void) {
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    control.streams.value.subscribe(callback);
  }

  public function attach(?el : Element) {
    if(null == el)
      el = js.Browser.document.body;
    this.el.classList.add("sui-top-right");
    el.appendChild(this.el);
  }
}