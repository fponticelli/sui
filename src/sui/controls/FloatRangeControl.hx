package sui.controls;

using thx.core.Nulls;
using thx.stream.dom.Dom;
import dots.Query;
import js.html.InputElement;
using thx.core.Floats;

class FloatRangeControl extends Control<Float> {
  var input : InputElement;
  var range : InputElement;
  public function new(value : Float, min : Float, max : Float, ?step : Float, ?allowNaN = false) {
    super(value);
    var sstep = null == step ? "" : 'step="$step"';
    el = dots.Html.parse('<div>
<input type="range" value="$value" $sstep min="$min" max="$max" />
<input type="number" value="$value" $sstep min="$min" max="$max" />
</div>');
    range = cast Query.first('[type="range"]', el);
    input = cast Query.first('[type="number"]', el);

    range.streamFocus()
      .merge(input.streamFocus())
      .debounce(0)
      .distinct()
      .feed(_focus);

    range.streamInput()
      .map(function(_) return range.valueAsNumber)
      .subscribe(set);

    input.streamInput()
      .map(function(_) return !allowNaN && Math.isNaN(input.valueAsNumber) ? 0.0 : input.valueAsNumber)
      .map(function(v) return v.clamp(min, max))
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