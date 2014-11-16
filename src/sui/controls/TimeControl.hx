package sui.controls;

using StringTools;
import sui.controls.Options;

class TimeControl extends SingleInputControl<Float> {
  public function new(value : Float, ?options : OptionsTime) {
    if(null == options)
      options = {};
    super(value, "input", "time", "time", options);

    if(null != options.autocomplete)
      input.setAttribute('autocomplete', options.autocomplete ? 'on' : 'off');

    if(null != options.min)
      input.setAttribute('min', timeToString(options.min));
    if(null != options.max)
      input.setAttribute('max', timeToString(options.max));

    if(null != options.list)
      new DataList(el, options.list.map(function(o) {
        return {
          label : o.label,
          value : timeToString(o.value)
        };
      })).applyTo(input);
    else if(null != options.values)
      new DataList(el, options.values.map(function(o) {
        return {
          label : timeToString(o),
          value : timeToString(o)
        };
      })).applyTo(input);
  }

  public static function timeToString(t : Float) {
    var h = Math.floor(t / 3600000);
    t -= h * 3600000;
    var m = Math.floor(t / 60000);
    t -= m * 60000;
    var s = t / 1000,
        hh = '$h'.lpad("0", 2),
        mm = '$m'.lpad("0", 2),
        ss = (s >= 10 ? '' : '0') + s;
    return '$hh:$mm:$ss';
  }

  public static function stringToTime(t : String) : Float {
    var p = t.split(":"),
        h = Std.parseInt(p[0]),
        m = Std.parseInt(p[1]),
        s = Std.parseFloat(p[2]);
    return s * 1000 + m * 60000 + h * 3600000;
  }

  override function setInput(v : Float)
    input.value = timeToString(v);

  override function getInput() : Float
    return stringToTime(input.value);
}