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

  public function date(?label : String, ?defaultValue : Date, ?options : OptionsDate, callback : Date -> Void) {
    if(null == defaultValue)
      defaultValue = Date.now();
    var control = new DateControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function dateTime(?label : String, ?defaultValue : Date, ?options : OptionsDate, callback : Date -> Void) {
    if(null == defaultValue)
      defaultValue = Date.now();
    var control = new DateTimeControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function email(?label : String, ?defaultValue = "", ?options : OptionsText, callback : String -> Void) {
    var control = new EmailControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

/*
  public function color(?label : String, ?defaultValue = "#AA0000", callback : String -> Void) {
    var control = new ColorControl(defaultValue);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }
*/
  public function float(?label : String, ?defaultValue = 0.0, ?options : OptionsNumber<Float>, callback : Float -> Void) {
    var control = /*(options.min != null && options.max != null) ? new FloatRangeControl(defaultValue, min, max, step) :*/ new FloatControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function int(?label : String, ?defaultValue = 0, ?options : OptionsNumber<Int>, callback : Int -> Void) {
    var control = /*(options.min != null && options.max != null) ? new IntRangeControl(defaultValue, min, max, step) :*/ new IntControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function label(?defaultValue = "", ?label : String, ?options : OptionsText, ?callback : String -> Void) {
    var control = new LabelControl(defaultValue, options);
    if(null != callback)
      control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function password(?label : String, ?defaultValue = "", ?options : OptionsText, callback : String -> Void) {
    var control = new PasswordControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function search(?label : String, ?defaultValue = "", ?options : OptionsText, callback : String -> Void) {
    var control = new SearchControl(defaultValue, options);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function tel(?label : String, ?defaultValue = "", ?options : OptionsText, callback : String -> Void) {
    var control = new TelControl(defaultValue, options);
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

  public function time(?label : String, ?defaultValue : Float, ?options : OptionsTime, callback : Float -> Void) {
    if(null == defaultValue)
      defaultValue = 0;
    var control = new TimeControl(defaultValue, options);
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

  public function url(?label : String, ?defaultValue = "", ?options : OptionsText, callback : String -> Void) {
    var control = new UrlControl(defaultValue, options);
    control.streams.value.subscribe(callback);
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