package sui.controls;

using thx.core.Ints;
using thx.core.Nulls;
using thx.stream.dom.Dom;
import dots.Query;
import js.html.InputElement;

class ColorControl extends Control<String> {
  static var PATTERN = ~/^[#][0-9a-f]{6}$/i;
  var input : InputElement;
  var picker : InputElement;
  public function new(value : String) {
    super(value);
    el = dots.Html.parse('<div>
<input type="color" value="$value" />
<input type="text" value="$value" />
</div>');
    picker = cast Query.first('[type="color"]', el);
    input = cast Query.first('[type="text"]', el);

    picker.streamFocus()
      .merge(input.streamFocus())
      .debounce(0)
      .distinct()
      .feed(_focus);

    picker.streamInput()
      .pluck(picker.value)
      .subscribe(set);

    input.streamInput()
      .pluck(input.value)
      .filterPluck(PATTERN.match(_))
      .subscribe(set);
  }

  override public function set(value : String) {
    picker.value = value;
    input.value = value;
    _value.set(value);
  }

  override public function focus()
    input.focus();
}