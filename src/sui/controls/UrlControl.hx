package sui.controls;

import sui.controls.Options;

class UrlControl extends BaseTextControl {
  public function new(value : String, ?options : OptionsText) {
    if(null == options)
      options = {};
    if(null == options.placeholder)
      options.placeholder = "http://example.com";
    super(value, "url", "url", options);
  }
}