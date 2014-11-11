package sui.controls;

using thx.core.Nulls;
using thx.stream.dom.Dom;
import js.html.InputElement;

class FloatRangeControl extends Control<Float> {
  public function new(value : Float, min : Float, max : Float, ?step : Float) {
    super(value);
    var sstep = null == step ? "" : 'step="$step"',
        input : InputElement = cast dots.Html.parse('<input type="range" value="$value" $sstep min="$min" max="$max" />');
    el = input;
    input.streamFocus().feed(_focus);
    input.streamInput()
      .map(function(_) return input.valueAsNumber)
      .feed(_value);
  }

  override public function set(value : Float)
    (cast el : InputElement).valueAsNumber = value;

  override public function focus()
    (cast el : InputElement).focus();
}