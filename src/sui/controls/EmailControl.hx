package sui.controls;

import sui.controls.Options;

class EmailControl extends BaseTextControl {
  public function new(value : String, ?options : OptionsText) {
    super(value, "email", "email", options);
  }
}