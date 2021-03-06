package sui.controls;

import sui.controls.Options;

class EmailControl extends BaseTextControl {
  public function new(value : String, ?options : OptionsText) {
    if(null == options)
      options = {};
    if(null == options.placeholder)
      options.placeholder = "name@example.com";
    super(value, "email", "email", options);
  }
}