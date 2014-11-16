package sui.controls;

using thx.core.Nulls;
using thx.stream.dom.Dom;
import dots.Query;
import js.html.InputElement;
using thx.core.Floats;

class FloatRangeControl extends ValueControl<Float> {
  var input : InputElement;
  var range : InputElement;
  public function new(value : Float, min : Float, max : Float, ?step : Float, ?allowNaN = false) {
    super(value);
    var sstep = null == step ? "" : 'step="$step"';
    el = dots.Html.parse('<div class="sui-range-float">
<input class="sui-input sui-range-slider-float" type="range" value="$value" $sstep min="$min" max="$max"/>
<input class="sui-input sui-range-input-float" type="number" value="$value" $sstep min="$min" max="$max"/>');
    range = cast Query.first('.sui-range-slider-float', el);
    input = cast Query.first('.sui-range-input-float', el);

    range.streamFocus()
      .merge(input.streamFocus())
      .debounce(0)
      .distinct()
      .feed(_focus);

    range.streamInput()
      .pluck(range.valueAsNumber)
      .subscribe(set);

    input.streamInput()
      .pluck(!allowNaN && Math.isNaN(input.valueAsNumber) ? 0.0 : input.valueAsNumber)
      .pluck(_.clamp(min, max))
      .subscribe(set);
  }

  override public function set(value : Float) {
    range.valueAsNumber = value;
    input.valueAsNumber = value;
    _value.set(value);
  }

  override public function focus()
    input.focus();
}