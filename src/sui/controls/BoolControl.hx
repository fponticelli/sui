package sui.controls;

import dots.Html;
import dots.Query;
using thx.stream.dom.Dom;
import js.html.InputElement;

class BoolControl extends InputControl<Bool> {
  public function new(value : Bool, ?options : ControlOptions) {
    el = Html.parse('<div class="sui-single sui-input sui-bool"><input type="checkbox" ${value ? "checked" : ""}/></div>');
    var input = (cast Query.first('input', el) : InputElement);
    super(value, input, options);
    input.streamChecked().subscribe(set);
  }

  override public function set(value : Bool) {
    input.checked = value;
    _value.set(value);
  }
}