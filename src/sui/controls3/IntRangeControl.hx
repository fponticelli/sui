package sui.controls;

using thx.core.Ints;
using thx.core.Nulls;
using thx.stream.dom.Dom;
import dots.Query;
import js.html.InputElement;

class IntRangeControl extends ValueControl<Int> {
  var input : InputElement;
  var range : InputElement;
  public function new(value : Int, min : Int, max : Int, step : Int = 1) {
    super(value);
    el = dots.Html.parse('<div class="sui-range-int">
<input class="sui-input sui-range-slider-int" type="range" value="$value" step="$step" min="$min" max="$max" />
<input class="sui-input sui-range-input-int" type="number" value="$value" step="$step" min="$min" max="$max" />
</div>');
    range = cast Query.first('.sui-range-slider-int', el);
    input = cast Query.first('.sui-range-input-int', el);

    range.streamFocus()
      .merge(input.streamFocus())
      .debounce(0) // avoids the false/true switching focus from range to input
      .distinct()  // avoids double trues when switching focus from range to input
      .feed(_focus);

    range.streamInput()
      .pluck(Std.int(range.valueAsNumber))
      .subscribe(set);

    input.streamInput()
      .pluck(Std.int(input.valueAsNumber))
      .pluck(_.clamp(min, max))
      .subscribe(set);
  }

  override public function set(value : Int) {
    range.valueAsNumber = value;
    input.valueAsNumber = value;
    _value.set(value);
  }

  override public function focus()
    input.focus();
}