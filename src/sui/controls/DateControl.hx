package sui.controls;

using StringTools;
import sui.controls.Options;
using thx.core.Nulls;
using thx.core.Strings;

class DateControl extends BaseDateControl {
  public function new(value : Date, ?options : OptionsDate) {
    super(value, "date", "date", BaseDateControl.toRFCDate, options);
  }
}