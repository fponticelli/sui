package sui.controls;

using thx.core.Ints;
using thx.core.Nulls;
using thx.stream.dom.Dom;
import dots.Detect;
import dots.Query;
import js.html.InputElement;

class ColorControl extends ValueControl<String> {
  static var PATTERN = ~/^[#][0-9a-f]{6}$/i;
  var picker : InputElement;
  var input : InputElement;
  public function new(value : String) {
    super(value);
    el = dots.Html.parse('<div class="sui-color">
<input class="sui-input sui-color-control" type="color" value="$value" />
<input class="sui-input sui-color-text" type="text" value="$value" />
</div>');
    picker = cast Query.first('.sui-color-control', el);
    input  = cast Query.first('.sui-color-text', el);

    if(!Detect.supportsInput("color"))
      picker.style.display = "none";

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
      //.filterPluck(PATTERN.match(_))
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