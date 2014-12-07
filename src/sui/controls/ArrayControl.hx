package sui.controls;

import js.html.ButtonElement;
import js.html.Element;
import sui.controls.Options;
import dots.Html;
import dots.Query;
using thx.stream.dom.Dom;
using thx.stream.Emitter;
using thx.core.Arrays;
using thx.core.Nulls;

class ArrayControl<T> implements IControl<Array<T>> {
  public var el(default, null) : Element;
  public var ul(default, null) : Element;
  public var addButton(default, null) : Element;
  public var defaultValue(default, null) : Array<T>;
  public var defaultElementValue(default, null) : T;
  public var streams(default, null) : ControlStreams<Array<T>>;
  public var createElementControl(default, null) : T -> IControl<T>;
  public var length(default, null) : Int;

  var values : ControlValues<Array<T>>;
  var elements :  Array<{
    control : IControl<T>,
    el : Element,
    index : Int
  }>;

  public function new(defaultValue : Array<T>, defaultElementValue : T, createElementControl : T -> IControl<T>, ?options : Options) {
    var template = '<div class="sui-control sui-control-single sui-type-array">
<ul class="sui-array"></ul>
<div class="sui-array-add"><i class="sui-icon sui-icon-add"></i></div>
</div>';
    options = (options).or({});
    this.defaultValue = defaultValue;
    this.defaultElementValue = defaultElementValue;
    this.createElementControl = createElementControl;
    this.elements = [];
    length = 0;

    values  = new ControlValues(defaultValue);
    streams = new ControlStreams(values.value, values.focused.debounce(0), values.enabled);

    el = Html.parse(template);
    ul = Query.first('ul', el);
    addButton = Query.first('.sui-icon-add', el);

    addButton.streamClick().subscribe(function(_) addControl(defaultElementValue));

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

    values.enabled
      .negate()
      .subscribe(el.subscribeToggleClass("sui-disabled"));

    values.enabled.subscribe(function(v) {
      elements.pluck(v ? _.control.enable() : _.control.disable());
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
    <div class="sui-move"><i class="sui-icon-mini sui-icon-up"></i><i class="sui-icon-mini sui-icon-down"></i></div>
    <div class="sui-control-container"></div>
    <div class="sui-remove"><i class="sui-icon sui-icon-remove"></i></div>
</li>'),
      index : length++
    };

    ul.appendChild(o.el);

    var removeElement = Query.first(".sui-icon-remove", o.el),
        upElement = Query.first(".sui-icon-up", o.el),
        downElement = Query.first(".sui-icon-down", o.el),
        controlContainer = Query.first(".sui-control-container", o.el);

    controlContainer.appendChild(o.control.el);

    removeElement.streamClick().subscribe(function(_) {
      ul.removeChild(o.el);
      elements.splice(o.index, 1);
      for(i in o.index...elements.length)
        elements[i].index--;
      length--;
      updateValue();
    });

    elements.push(o);
    o.control.streams.value.subscribe(function(_) updateValue());
    o.control.streams
      .focused
      .subscribe(o.el.subscribeToggleClass("sui-focus"));

    o.control.streams
      .focused
      .feed(values.focused);

    upElement.streamClick()
      .subscribe(function(_) {
        var pos = o.index,
            prev = elements[pos-1];
        elements[pos] = prev;
        elements[pos-1] = o;
        prev.index = pos;
        o.index = pos - 1;
        ul.insertBefore(o.el, prev.el);
        updateValue();
      });

    downElement.streamClick()
      .subscribe(function(_) {
        var pos = o.index,
            next = elements[pos+1];
        elements[pos] = next;
        elements[pos+1] = o;
        next.index = pos;
        o.index = pos + 1;
        ul.insertBefore(next.el, o.el);
        updateValue();
      });
  }

  function setValue(v : Array<T>)
    v.pluck(addControl(_));

  function getValue()
    return elements.pluck(_.control.get());

  function updateValue()
    values.value.set(getValue());

  public function set(v : Array<T>) {
    clear();
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

  public function focus()
    if(elements.length > 0)
      elements.last().control.focus();

  public function blur() {
    var el = js.Browser.document.activeElement;
    elements
      // TODO el could just contain _.control.el
      .filterPluck(_.control.el == el)
      .first().with(el.blur());
  }

  public function reset()
    set(defaultValue);

  function clear() {
    length = 0;
    elements.map(function(item) {
      //control.destroy();
      ul.removeChild(item.el);
    });
    elements = [];
  }
}