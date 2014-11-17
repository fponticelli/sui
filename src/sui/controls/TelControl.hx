package sui.controls;

import sui.controls.Options;

class TelControl extends BaseTextControl {
  public function new(value : String, ?options : OptionsText) {
    if(null == options)
      options = {};
    super(value, "tel", "tel", options);
  }
}