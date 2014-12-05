package sui.controls;

import js.html.ButtonElement;
import js.html.Element;
import sui.controls.Options;
import dots.Html;
import dots.Query;
using thx.stream.dom.Dom;
using thx.stream.Emitter;
using thx.core.Arrays;
using thx.core.Iterators;
using thx.core.Nulls;

class MapControl<TKey, TValue> implements IControl<Map<TKey, TValue>> {
  public var el(default, null) : Element;
  public var tbody(default, null) : Element;
  public var addButton(default, null) : Element;
  public var defaultValue(default, null) : Map<TKey, TValue>;
  public var streams(default, null) : ControlStreams<Map<TKey, TValue>>;
  public var createMap(default, null) : Void -> Map<TKey, TValue>;
  public var createKeyControl(default, null) : TKey -> IControl<TKey>;
  public var createValueControl(default, null) : TValue -> IControl<TValue>;
  public var length(default, null) : Int;

  var values : ControlValues<Map<TKey, TValue>>;
  var elements :  Array<{
    controlKey : IControl<TKey>,
    controlValue : IControl<TValue>,
    el : Element,
    index : Int
  }>;

  public function new(?defaultValue : Map<TKey, TValue>, createMap : Void -> Map<TKey, TValue>, createKeyControl : TKey -> IControl<TKey>, createValueControl : TValue -> IControl<TValue>, ?options : Options) {
    var template = '<div class="sui-control sui-control-single sui-type-array">
<table class="sui-map"><tbody></tbody></table>
<div class="sui-array-add"><i class="sui-icon sui-icon-add"></i></div>
</div>';
    options = (options).or({});
    if(null == defaultValue)
      defaultValue = createMap();
    this.defaultValue = defaultValue;
    this.createMap = createMap;
    this.createKeyControl = createKeyControl;
    this.createValueControl = createValueControl;
    this.elements = [];
    length = 0;

    values  = new ControlValues(defaultValue);
    streams = new ControlStreams(values.value, values.focused.debounce(0), values.enabled);

    el = Html.parse(template);
    tbody = Query.first('tbody', el);
    addButton = Query.first('.sui-icon-add', el);

    addButton.streamClick().subscribe(function(_) addControl(null, null));

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
      elements.pluck(if(v){
          _.controlKey.enable();
          _.controlValue.enable();
        } else {
          _.controlKey.disable();
          _.controlValue.disable();
        });
      });

    setValue(defaultValue);

    reset();

    if(options.autofocus)
      focus();
    if(options.disabled)
      disable();
  }

  function addControl(key : TKey, value : TValue) {
    var o = {
      controlKey : createKeyControl(key),
      controlValue : createValueControl(value),
      el : Html.parse('<tr class="sui-map-item">
<td class="sui-map-key"></td>
<td class="sui-map-value"></td>
<td class="sui-remove"><i class="sui-icon sui-icon-remove"></i></td>
</tr>'),
      index : length++
    };

    tbody.appendChild(o.el);

    var removeElement = Query.first(".sui-icon-remove", o.el),
        controlKeyContainer = Query.first(".sui-map-key", o.el),
        controlValueContainer = Query.first(".sui-map-value", o.el);

    controlKeyContainer.appendChild(o.controlKey.el);
    controlValueContainer.appendChild(o.controlValue.el);

    removeElement.streamClick().subscribe(function(_) {
      tbody.removeChild(o.el);
      elements.splice(o.index, 1);
      for(i in o.index...elements.length)
        elements[i].index--;
      length--;
      updateValue();
    });

    elements.push(o);

    o.controlKey.streams.value
      .toNil()
      .merge(o.controlValue.streams.value.toNil())
      .subscribe(function(_) updateValue());

    o.controlKey.streams
      .focused
      .merge(o.controlValue.streams.focused)
      .subscribe(o.el.subscribeToggleClass("sui-focus"));

    o.controlKey.streams
      .focused
      .merge(o.controlValue.streams.focused)
      .feed(values.focused);
  }

  function setValue(v : Map<TKey, TValue>)
    v.keys().pluck(addControl(_, v.get(_)));

  function getValue() : Map<TKey, TValue> {
    var map = createMap();
    elements.map(function(o) {
      var k = o.controlKey.get(),
          v = o.controlValue.get();
      if(k == null || map.exists(k)) {
        o.controlKey.el.classList.add("sui-invalid");
        return;
      }
      o.controlKey.el.classList.remove("sui-invalid");
      map.set(k, v);
    });
    return map;
  }

  function updateValue()
    values.value.set(getValue());

  public function set(v : Map<TKey, TValue>) {
    clear();
    setValue(v);
    values.value.set(v);
  }

  public function get() : Map<TKey, TValue>
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
      elements.last().controlValue.focus();

  public function blur() {
    var el = js.Browser.document.activeElement;
    elements
      .filterPluck(_.controlKey.el == el || _.controlValue.el == el)
      .first().with(el.blur());
  }

  public function reset()
    set(defaultValue);

  function clear() {
    length = 0;
    elements.map(function(item) {
      //control.destroy();
      tbody.removeChild(item.el);
    });
    elements = [];
  }
}