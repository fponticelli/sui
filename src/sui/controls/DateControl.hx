package sui.controls;

using StringTools;
import sui.controls.Options;
using thx.Nulls;
using thx.Strings;

class DateControl extends BaseDateControl {
  public function new(value : Date, ?options : OptionsDate) {
    super(value, "date", "date", BaseDateControl.toRFCDate, options);
  }
}