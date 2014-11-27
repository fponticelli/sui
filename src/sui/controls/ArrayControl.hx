package sui.controls;

import js.html.ButtonElement;
import js.html.Element;
import sui.controls.Options;
import dots.Html;
import dots.Query;
using thx.stream.dom.Dom;
using thx.core.Arrays;
using thx.core.Nulls;

// TODO stream values to array container
// TODO remove element
// TODO move element up/down
// TODO propagate focus
// TODO propagate disable

class ArrayControl<T> implements IControl<Array<T>> {
  public var el(default, null) : Element;
  public var ul(default, null) : Element;
  public var addButton(default, null) : TriggerControl;
  public var defaultValue(default, null) : Array<T>;
  public var defaultElementValue(default, null) : T;
  public var streams(default, null) : ControlStreams<Array<T>>;
  public var createElementControl(default, null) : T -> IControl<T>;

  var values : ControlValues<Array<T>>;
  var elements :  Array<{
    control : IControl<T>,
    el : Element
  }>;

  public function new(defaultValue : Array<T>, defaultElementValue : T, createElementControl : T -> IControl<T>, ?options : Options) {
    var template = '<div class="sui-control sui-control-single sui-type-array"><ul class="sui-array"></ul></div>';
    options = (options).or({});
    this.defaultValue = defaultValue;
    this.defaultElementValue = defaultElementValue;
    this.createElementControl = createElementControl;
    this.elements = [];

    values  = new ControlValues(defaultValue);
    streams = new ControlStreams(values.value, values.focused, values.enabled);

    el = Html.parse(template);
    ul = Query.first('ul', el);
    addButton = new TriggerControl('<i class="sui-icon sui-icon-add"></i>', {});
    el.appendChild(addButton.el);

    addButton.streams.value.subscribe(function(_) addControl(defaultElementValue));

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

    reset();

    if(options.autofocus)
      focus();
    if(options.disabled)
      disable();
  }

  function addControl(value : T) {
    var li = Html.parse('<li class="sui-array-item">
  <!--<div class="sui-drag"><i class="sui-icon sui-icon-drag"></i></div>-->
  <div class="sui-control-container"></div>
  <!--<div class="sui-remove"><i class="sui-icon sui-icon-remove"></i></div>-->
</li>');
    ul.appendChild(li);
    var controlContainer = Query.first(".sui-control-container", li),
        control = createElementControl(value);
    controlContainer.appendChild(control.el);
    elements.push({
      control : control,
      el : li
    });
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

  public function reset() {
    elements.map(function(item) {
      //control.destroy();
      ul.removeChild(item.el);
    });
    defaultValue.pluck(addControl(_));
    set(defaultValue);
  }
}