package sui.controls;

import sui.controls.Options;

class DateSelectControl<Date> extends SelectControl<Date> {
  public function new(defaultValue : Date, options : OptionsSelect<Date>) {
    super(defaultValue, "select-date", options);
  }
}