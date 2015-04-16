package sui.controls;

import dots.Html;
import dots.Query;
import js.html.DOMElement as Element;

class LabelControl implements IControl<String> {
  public var el(default, null) : Element;
  public var output(default, null) : Element;
  public var defaultValue(default, null) : String;
  public var streams(default, null) : ControlStreams<String>;

  var values : ControlValues<String>;

  public function new(defaultValue : String) {
    var template = '<div class="sui-control sui-control-single sui-type-label"><output>$defaultValue</output></div>';

    this.defaultValue = defaultValue;

    values  = new ControlValues(defaultValue);
    streams = new ControlStreams(values.value, values.focused, values.enabled);

    el = Html.parse(template);
    output = Query.first("output", el);

    values.enabled.subscribe(function(v) if(v) {
      el.classList.add("sui-disabled");
    } else {
      el.classList.remove("sui-disabled");
    });
  }

  public function set(v : String) {
    output.innerHTML = v;
    values.value.set(v);
  }

  public function get() : String
    return values.value.get();

  public function isEnabled()
    return values.enabled.get();

  public function isFocused()
    return values.focused.get();

  public function disable()
    values.enabled.set(false);

  public function enable()
    values.enabled.set(true);

  public function focus() {}

  public function blur() {}

  public function reset()
    set(defaultValue);
}