package sui.controls;

import js.html.DOMElement as Element;
import js.html.SelectElement;
import dots.Html;
import dots.Query;
import sui.controls.Options;
using thx.core.Arrays;
using thx.core.Nulls;
using thx.stream.dom.Dom;

class SelectControl<T> implements IControl<T> {
  public var el(default, null) : Element;
  public var select(default, null) : SelectElement;
  public var defaultValue(default, null) : T;
  public var streams(default, null) : ControlStreams<T>;

  var options : Array<T>;
  var values : ControlValues<T>;
  var count : Int = 0;

  function new(defaultValue : T, name : String, options : OptionsSelect<T>) {
    var template = '<div class="sui-control sui-control-single sui-type-$name"><select></select></div>';
    if(null == options)
      throw " A select control requires an option object with values or list set";
    if(null == options.values && null == options.list)
      throw " A select control requires either the values or list option";
    if(null == options.allownull)
      options.allownull = false;
    this.defaultValue = defaultValue;

    values  = new ControlValues(defaultValue);
    streams = new ControlStreams(values.value, values.focused, values.enabled);

    el = Html.parse(template);
    select = (cast Query.first('select', el) : SelectElement);

    values.enabled.subscribe(function(v) if(v) {
      el.classList.add("sui-disabled");
      select.removeAttribute("disabled");
    } else {
      el.classList.remove("sui-disabled");
      select.setAttribute("disabled", "disabled");
    });

    values.focused.subscribe(function(v) if(v) {
      el.classList.add("sui-focused");
    } else {
      el.classList.remove("sui-focused");
    });

    this.options = [];

    (options.allownull ? [{ label : (options.labelfornull).or("- none -"), value : null }] : []).concat(
    (options.list)
      .or(options.values.pluck({ value : _, label : Std.string(_) })))
      .pluck(addOption(_.label, _.value));

    setInput(defaultValue);

    select.streamFocus().feed(values.focused);
    select.streamEvent("change")
      .pluck(getInput())
      .feed(values.value);

    if(options.autofocus)
      focus();
    if(options.disabled)
      disable();
  }

  public function addOption(label : String, value : T) {
    var index  = count++,
        option = Html.parse('<option>$label</option>');
    options[index] = value;
    select.appendChild(option);
    return option;
  }

  function setInput(v : T) {
    var index = options.indexOf(v);
    if(index < 0) throw 'value "$v" is not included in this select control';
    select.selectedIndex = index;
  }

  function getInput() {
    return options[select.selectedIndex];
  }

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
    select.focus();

  public function blur()
    select.blur();

  public function reset()
    set(defaultValue);
}