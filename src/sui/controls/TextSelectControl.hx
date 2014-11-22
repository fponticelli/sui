package sui.controls;

import sui.controls.Options;

class TextSelectControl extends SelectControl<String> {
  public function new(defaultValue : String, options : OptionsSelect<String>) {
    super(defaultValue, "select-text", options);
  }
}