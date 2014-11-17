package sui.controls;

import dots.Html;
import dots.Query;
import js.html.Element;
import js.html.InputElement;
import thx.core.error.AbstractMethod;
using thx.stream.dom.Dom;
import dots.Detect;

class DoubleInputControl<T> implements IControl<T> {
  public var el(default, null) : Element;
  public var input1(default, null) : InputElement;
  public var input2(default, null) : InputElement;
  public var defaultValue(default, null) : T;
  public var streams(default, null) : ControlStreams<T>;

  var values : ControlValues<T>;

  public function new(defaultValue : T, name : String, event1 : String, type1 : String, event2 : String, type2 : String, filter : T -> Bool, options : Options) {
    var template = '<div class="sui-control sui-control-double sui-type-$name"><input class="input1" type="$type1"/><input class="input2" type="$type2"/></div>';

    if(null == options)
      options = {};
    if(null == options.allownull)
      options.allownull = true;

    this.defaultValue = defaultValue;

    values  = new ControlValues(defaultValue);
    streams = new ControlStreams(values.value, values.focused, values.enabled);

    el = Html.parse(template);
    input1 = (cast Query.first('.input1', el) : InputElement);
    input2 = (cast Query.first('.input2', el) : InputElement);

    values.enabled.subscribe(function(v) if(v) {
      el.classList.add("sui-disabled");
      input1.removeAttribute("disabled");
      input2.removeAttribute("disabled");
    } else {
      el.classList.remove("sui-disabled");
      input1.setAttribute("disabled", "disabled");
      input2.setAttribute("disabled", "disabled");
    });

    values.focused.subscribe(function(v) if(v) {
      el.classList.add("sui-focused");
    } else {
      el.classList.remove("sui-focused");
    });

    setInputs(defaultValue);

    input1.streamFocus()
      .merge(input2.streamFocus())
      .feed(values.focused);
    input1.streamEvent(event1)
      .pluck(getInput1())
      .subscribe(function(v) {
        setInput2(v);
        values.value.set(v);
      });
    input2.streamEvent(event2)
      .pluck(getInput2())
      .filter(filter)
      .subscribe(function(v) {
        setInput1(v);
        values.value.set(v);
      });

    if(!options.allownull) {
      input1.setAttribute("required", "required");
      input2.setAttribute("required", "required");
    }
    if(options.autofocus)
      focus();
    if(options.disabled)
      disable();

    if(!Detect.supportsInput(type1))
      input1.style.display = "none";
  }

  function setInputs(v : T) {
    setInput1(v);
    setInput2(v);
  }

  function setInput1(v : T)
    throw new AbstractMethod();

  function setInput2(v : T)
    throw new AbstractMethod();

  function getInput1() : T
    return throw new AbstractMethod();

  function getInput2() : T
    return throw new AbstractMethod();

  public function set(v : T) {
    setInputs(v);
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
    input2.focus();

  public function blur() {
    var el = js.Browser.document.activeElement;
    if(el == input1 || el == input2)
      el.blur();
  }

  public function reset()
    set(defaultValue);
}