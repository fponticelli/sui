package sui.controls;

using StringTools;
import sui.controls.Options;
using thx.core.Nulls;
using thx.core.Strings;

class DateTimeControl extends BaseDateControl {
  public function new(value : Date, ?options : OptionsDate) {
    super(value, "date-time", "datetime-local", BaseDateControl.toRFCDateTimeNoSeconds, options);
  }
}