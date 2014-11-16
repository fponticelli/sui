package sui.controls;

import sui.controls.Options;

class PasswordControl extends BaseTextControl {
  public function new(value : String, ?options : OptionsText) {
    super(value, "text", "password", options);
  }
}