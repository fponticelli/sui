package sui.controls;

using StringTools;
import sui.controls.Options;
using thx.core.Nulls;
using thx.core.Strings;

class BaseDateControl extends SingleInputControl<Date> {
  var dateToString : Date -> String;
  public function new(value : Date, name : String, type : String, dateToString : Date -> String, ?options : OptionsDate) {
    if(null == options)
      options = {};

    this.dateToString = dateToString;

    super(value, "input", name, type, options);

    if(null != options.autocomplete)
      input.setAttribute('autocomplete', options.autocomplete ? 'on' : 'off');

    if(null != options.min)
      input.setAttribute('min', dateToString(options.min));
    if(null != options.max)
      input.setAttribute('max', dateToString(options.max));

    if(null != options.list)
      new DataList(el, options.list.map(function(o) {
        return {
          label : o.label,
          value : dateToString(o.value)
        };
      })).applyTo(input);
    else if(null != options.values)
      new DataList(el, options.values.map(function(o) {
        return {
          label : o.toString(),
          value : dateToString(o)
        };
      })).applyTo(input);
  }

  override function setInput(v : Date)
    input.value = dateToString(v);

  override function getInput() : Date
    return input.value.isEmpty() ? null : fromRFC(input.value);

  public static function toRFCDate(date : Date) {
    var y = date.getFullYear(),
        m = '${date.getMonth()+1}'.lpad('0', 2),
        d = '${date.getDate()}'.lpad('0', 2);
    return '$y-$m-$d';
  }

  public static function toRFCDateTime(date : Date) {
    var d = toRFCDate(date),
        hh = '${date.getHours()}'.lpad('0', 2),
        mm = '${date.getMinutes()}'.lpad('0', 2),
        ss = '${date.getSeconds()}'.lpad('0', 2);
    return '${d}T$hh:$mm:$ss';
  }

  public static function fromRFC(date : String) {
    var dp = date.split("T")[0],
        dt = (date.split("T")[1]).or("00:00:00"),
        p = dp.split("-"),
        y = Std.parseInt(p[0]),
        m = Std.parseInt(p[1])-1,
        d = Std.parseInt(p[2]),
        t = dt.split(":"),
        hh = Std.parseInt(t[0]),
        mm = Std.parseInt(t[1]),
        ss = Std.parseInt(t[2]);
    return new Date(y, m, d, hh, mm, ss);
  }
}