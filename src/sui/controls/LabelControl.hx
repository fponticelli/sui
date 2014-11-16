package sui.controls;

import sui.controls.Options;

class LabelControl extends BaseTextControl {
  public function new(value : String, ?options : OptionsText) {
    super(value, "label", "text", options);
    input.setAttribute("readonly", "readonly");
  }
}