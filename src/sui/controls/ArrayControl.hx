package sui.controls;

import js.html.ButtonElement;
import js.html.Element;
import sui.controls.Options;
import dots.Html;
import dots.Query;
using thx.stream.dom.Dom;
using thx.core.Arrays;
using thx.core.Nulls;

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
    el : Element,
    index : Int
  }>;
  var arr : Array<T>;

  public function new(defaultValue : Array<T>, defaultElementValue : T, createElementControl : T -> IControl<T>, ?options : Options) {
    var template = '<div class="sui-control sui-control-single sui-type-array"><ul class="sui-array"></ul></div>';
    options = (options).or({});
    this.defaultValue = defaultValue;
    this.defaultElementValue = defaultElementValue;
    this.createElementControl = createElementControl;
    this.elements = [];
    this.arr = [];

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

    reset();

    if(options.autofocus)
      focus();
    if(options.disabled)
      disable();
  }

  function addControl(value : T) {
    var o = {
      control : createElementControl(value),
      el : Html.parse('<li class="sui-array-item">
  <!--<div class="sui-drag"><i class="sui-icon sui-icon-drag"></i></div>-->
  <div class="sui-control-container"></div>
  <div class="sui-remove"><i class="sui-icon sui-icon-remove"></i></div>
</li>'),
      index : arr.length
    };

    ul.appendChild(o.el);

    var removeElement = Query.first(".sui-icon-remove", o.el),
        controlContainer = Query.first(".sui-control-container", o.el);

    controlContainer.appendChild(o.control.el);

    removeElement.streamClick().subscribe(function(_) {
      ul.removeChild(o.el);
      elements.splice(o.index, 1);
      trace(arr);
      arr.splice(o.index, 1);
      trace(arr);
      for(i in o.index...elements.length)
        elements[i].index--;
      values.value.set(arr.copy());
    });

    elements.push(o);
    o.control.streams.value.subscribe(function(v : T){
      arr[o.index] = v;
      values.value.set(arr.copy());
    });
  }

  function setValue(v : Array<T>)
    v.pluck(addControl(_));

  public function set(v : Array<T>) {
    clear();
    setValue(v);
    values.value.set(v);
  }

  public function get() : Array<T>
    return values.value.get().copy();

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

  function clear() {
    arr = [];
    elements.map(function(item) {
      //control.destroy();
      ul.removeChild(item.el);
    });
    elements = [];
  }
}