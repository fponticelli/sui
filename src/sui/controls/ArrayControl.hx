package sui.controls;

import js.html.Element;
import sui.controls.Options;
import dots.Html;
import dots.Query;
using thx.stream.dom.Dom;

class ArrayControl<T> implements IControl<Array<T>> {
  public var el(default, null) : Element;
  public var ul(default, null) : Element;
  public var defaultValue(default, null) : Array<T>;
  public var streams(default, null) : ControlStreams<Array<T>>;

  var values : ControlValues<Array<T>>;

  public function new(defaultValue : Array<T>, options : OptionsArray<T>) {
    var template = '<div class="sui-control sui-control-single sui-type-array"><ul></ul></div>';
    this.defaultValue = defaultValue;

    values  = new ControlValues(defaultValue);
    streams = new ControlStreams(values.value, values.focused, values.enabled);

    el = Html.parse(template);
    ul = Query.first('ul', el);

    values.enabled.subscribe(function(v) if(v) {
      el.classList.add("sui-disabled");
    } else {
      el.classList.remove("sui-disabled");
    });

    values.focused.subscribe(function(v) if(v) {
      el.classList.add("sui-focused");
    } else {
      el.classList.remove("sui-focused");
    });

    setValue(defaultValue);
/*
    select.streamFocus().feed(values.focused);
    select.streamEvent("change")
      .pluck(getValue())
      .feed(values.value);
*/
    if(options.autofocus)
      focus();
    if(options.disabled)
      disable();
  }

  function setValue(v : Array<T>) {

  }

  function getValue() {
    return null;
  }

  public function set(v : Array<T>) {
    setValue(v);
    values.value.set(v);
  }

  public function get() : Array<T>
    return values.value.get();

  public function isEnabled()
    return values.enabled.get();

  public function isFocused()
    return values.focused.get();

  public function disable()
    values.enabled.set(false);

  public function enable()
    values.enabled.set(true);

  public function focus() {
    // should set focus on first element
  }

  public function blur() {
    // blur current if part of ArrayControl
  }

  public function reset()
    set(defaultValue);
}