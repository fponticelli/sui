package sui.controls;

import dots.Html;
import dots.Query;
using thx.stream.dom.Dom;
using thx.core.Nulls;
import js.html.InputElement;
using StringTools;

class DateControl extends InputControl<Date> {
  public static function toRFC(date : Date) {
    var y = date.getFullYear(),
        m = '${date.getMonth()+1}'.lpad('0', 2),
        d = '${date.getDate()}'.lpad('0', 2);
    return '$y-$m-$d';
  }

  public static function fromRFC(date : String) {
    var p = date.split("-"),
        y = Std.parseInt(p[0]),
        m = Std.parseInt(p[1])-1,
        d = Std.parseInt(p[2]);
    return new Date(y, m, d, 0, 0, 0);
  }

  public function new(value : Date, ?options : OptionsDate) {
    if(null == options)
      options = {};
    if(null == options.required)
      options.required = true;
    input = cast Html.parse('<input class="sui-single sui-input sui-date" type="date" value="${toRFC(value)}"/>');
    el = input;
    input = (cast el : InputElement);
    if((options.min).exists())
      input.setAttribute("min", toRFC(options.min));
    if((options.max).exists())
      input.setAttribute("max", toRFC(options.max));
    super(value, options);
    input.streamInput()
      .map(fromRFC)
      .subscribe(set);
  }

  override public function set(value : Date) {
    input.valueAsDate = value;
    _value.set(value);
  }
}