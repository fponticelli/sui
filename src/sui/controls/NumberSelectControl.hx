package sui.controls;

import sui.controls.Options;

class NumberSelectControl<T : Float> extends SelectControl<T> {
  public function new(defaultValue : T, options : OptionsSelect<T>) {
    super(defaultValue, "select-number", options);
  }
}