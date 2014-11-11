package sui.controls;

using thx.core.Nulls;
using thx.stream.dom.Dom;
import js.html.InputElement;

class IntRangeControl extends Control<Int> {
  public function new(value : Int, min : Int, max : Int, step : Int = 1) {
    super(value);
    var input : InputElement = cast dots.Html.parse('<input type="range" value="$value" step="$step" min="$min" max="$max" />');
    el = input;
    input.streamFocus().feed(_focus);
    input.streamInput()
      .map(function(_) return Std.int(input.valueAsNumber))
      .feed(_value);
  }

  override public function set(value : Int)
    (cast el : InputElement).valueAsNumber = value;

  override public function focus()
    (cast el : InputElement).focus();
}