package sui;

import js.html.Element;
import sui.components.Grid;
import sui.controls.*;

class Sui {
  public var el(default, null) : Element;
  var grid : Grid;
  public function new() {
    grid = new Grid();
    el = grid.el;
  }

  public function bool(?label : String, ?defaultValue = false, callback : Bool -> Void) {
    var control = new BoolControl(defaultValue);
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

  public function float(?label : String, ?defaultValue = 0.0, ?step : Float, ?min : Float, ?max : Float, ?allowNaN = false, callback : Float -> Void) {
    var control = (min != null && max != null) ? new FloatRangeControl(defaultValue, min, max, step) : new FloatControl(defaultValue, allowNaN);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function int(?label : String, ?defaultValue = 0, ?step : Int, ?min : Int, ?max : Int, callback : Int -> Void) {
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

  public function text(?label : String, ?defaultValue = "", ?placeholder : String, ?allowEmptyText = true, callback : String -> Void) {
    var control = new TextControl(defaultValue, placeholder, allowEmptyText);
    control.streams.value.subscribe(callback);
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  public function trigger(actionLabel : String, ?label : String, callback : Void -> Void) {
    var control = new TriggerControl(actionLabel);
    control.streams.value.subscribe(function(_) callback());
    grid.add(null == label ? Single(control) : HorizontalPair(new LabelControl(label), control));
    return control;
  }

  // general binding
  public function control<T>(?label : String, control : Control<T>, callback : T -> Void) {
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