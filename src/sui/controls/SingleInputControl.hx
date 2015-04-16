package sui.controls;

import dots.Html;
import dots.Query;
import js.html.DOMElement as Element;
import js.html.InputElement;
import thx.core.error.AbstractMethod;
using thx.stream.dom.Dom;

class SingleInputControl<T> implements IControl<T> {
  public var el(default, null) : Element;
  public var input(default, null) : InputElement;
  public var defaultValue(default, null) : T;
  public var streams(default, null) : ControlStreams<T>;

  var values : ControlValues<T>;

  public function new(defaultValue : T, event : String, name : String, type : String, options : Options) {
    var template = '<div class="sui-control sui-control-single sui-type-$name"><input type="$type"/></div>';

    if(null == options)
      options = {};
    if(null == options.allownull)
      options.allownull = true;

    this.defaultValue = defaultValue;

    values  = new ControlValues(defaultValue);
    streams = new ControlStreams(values.value, values.focused, values.enabled);

    el = Html.parse(template);
    input = (cast Query.first('input', el) : InputElement);

    values.enabled.subscribe(function(v) if(v) {
      el.classList.add("sui-disabled");
      input.removeAttribute("disabled");
    } else {
      el.classList.remove("sui-disabled");
      input.setAttribute("disabled", "disabled");
    });

    values.focused.subscribe(function(v) if(v) {
      el.classList.add("sui-focused");
    } else {
      el.classList.remove("sui-focused");
    });

    setInput(defaultValue);

    input.streamFocus().feed(values.focused);
    input.streamEvent(event)
      .pluck(getInput())
      .feed(values.value);

    if(!options.allownull)
      input.setAttribute("required", "required");
    if(options.autofocus)
      focus();
    if(options.disabled)
      disable();
  }

  function setInput(v : T)
    throw new AbstractMethod();

  function getInput() : T
    return throw new AbstractMethod();

  public function set(v : T) {
    setInput(v);
    values.value.set(v);
  }

  public function get() : T
    return values.value.get();

  public function isEnabled()
    return values.enabled.get();

  public function isFocused()
    return values.focused.get();

  public function disable()
    values.enabled.set(false);

  public function enable()
    values.enabled.set(true);

  public function focus()
    input.focus();

  public function blur()
    input.blur();

  public function reset()
    set(defaultValue);
}