package sui.controls;

import dots.Html;
import dots.Query;
using thx.stream.dom.Dom;
import js.html.InputElement;

class BoolControl extends ValueControl<Bool> {
  var input : InputElement;
  public function new(value : Bool) {
    super(value);
    el = Html.parse('<div class="sui-single sui-input sui-bool"><input type="checkbox" ${value ? "checked" : ""}/></div>');
    input = cast Query.first('input', el);
    input.streamFocus().feed(_focus);
    input.streamChecked().subscribe(set);
  }

  override public function set(value : Bool) {
    input.checked = value;
    _value.set(value);
  }

  override public function focus()
    input.focus();
}