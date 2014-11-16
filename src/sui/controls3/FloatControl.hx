package sui.controls;

using thx.core.Nulls;
using thx.stream.dom.Dom;
import js.html.InputElement;

class FloatControl extends ValueControl<Float> {
  public function new(value : Float, ?step : Float, ?allowNaN = false) {
    super(value);
    var sstep = null == step ? "" : 'step="$step"',
        input : InputElement = cast dots.Html.parse('<input class="sui-input sui-float" type="number" value="$value" ${sstep} />');
    el = input;
    input.streamFocus().feed(_focus);
    input.streamInput()
      .pluck(!allowNaN && Math.isNaN(input.valueAsNumber) ? 0.0 : input.valueAsNumber)
      .subscribe(set);
  }

  override public function set(value : Float) {
    (cast el : InputElement).valueAsNumber = value;
    _value.set(value);
  }

  override public function focus()
    (cast el : InputElement).focus();
}