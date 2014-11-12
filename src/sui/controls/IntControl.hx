package sui.controls;

using thx.core.Nulls;
using thx.stream.dom.Dom;
import js.html.InputElement;

class IntControl extends Control<Int> {
  public function new(value : Int, step : Int = 1) {
    super(value);
    var input : InputElement = cast dots.Html.parse('<input type="number" value="$value" step="$step" />');
    el = input;
    input.streamFocus().feed(_focus);
    input.streamInput()
      .pluck(Std.int(input.valueAsNumber))
      .subscribe(set);
  }

  override public function set(value : Int) {
    (cast el : InputElement).valueAsNumber = value;
    _value.set(value);
  }

  override public function focus()
    (cast el : InputElement).focus();
}