package sui.controls;

using thx.core.Nulls;
using thx.stream.dom.Dom;
import js.html.OutputElement;

class LabelControl extends ValueControl<String> {
  public function new(value : String, ?placeholder : String) {
    if(null == value)
      value = "";
    super(value);
    el = cast dots.Html.parse('<output>$value</output>');
  }

  override public function set(value : String) {
    el.textContent = value;
    _value.set(value);
  }

  // labels do not have focus ... at least for now
  override public function focus() {}
}