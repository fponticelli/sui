package sui.controls;

import dots.Html;
import dots.Query;
using thx.stream.dom.Dom;
import js.html.InputElement;

class InputControl<T> extends ValueControl<T> {
  var input : InputElement;
  public function new(value : T, options : OptionsInput) {
    super(value);
    input.streamFocus().feed(_focus);
    if(null != options) {
      if(options.required)
        input.setAttribute("required", "required");
      if(options.autofocus)
        input.setAttribute("autofocus", "autofocus");
      if(options.disabled)
        disable();
    }
  }

  override public function enable() {
    if(!disabled) return;
    input.removeAttribute("disabled");
    disabled = true;
  }

  override public function disable() {
    if(disabled) return;
    input.setAttribute("disabled", "disabled");
    disabled = false;
  }

  override public function focus()
    input.focus();
}