package sui.controls;

import sui.controls.Options;

class SearchControl extends BaseTextControl {
  public function new(value : String, ?options : OptionsText) {
    if(null == options)
      options = {};
//    if(null == options.placeholder)
//      options.placeholder = "http://example.com";
    super(value, "search", "search", options);
  }
}