package sui.controls;

import dots.Html;
import dots.Query;
import js.html.DOMElement as Element;
import js.html.ButtonElement;
import thx.Nil;
using thx.stream.dom.Dom;

class TriggerControl implements IControl<Nil> {
  public var el(default, null) : Element;
  public var button(default, null) : ButtonElement;
  public var defaultValue(default, null) : Nil;
  public var streams(default, null) : ControlStreams<Nil>;

  var values : ControlValues<Nil>;

  public function new(label : String, ?options : Options) {
    var template = '<div class="sui-control sui-control-single sui-type-trigger"><button>$label</button></div>';

    if(null == options)
      options = {};

    defaultValue = nil;

    el = Html.parse(template);
    button = (cast Query.first('button', el) : ButtonElement);

    values  = new ControlValues(nil);
    var emitter = button.streamClick().toNil();
    streams = new ControlStreams(emitter, values.focused, values.enabled);

    values.enabled.subscribe(function(v) if(v) {
      el.classList.add("sui-disabled");
      button.removeAttribute("disabled");
    } else {
      el.classList.remove("sui-disabled");
      button.setAttribute("disabled", "disabled");
    });

    values.focused.subscribe(function(v) if(v) {
      el.classList.add("sui-focused");
    } else {
      el.classList.remove("sui-focused");
    });

    button.streamFocus().feed(values.focused);

    if(options.autofocus)
      focus();
    if(options.disabled)
      disable();
  }

  public function set(v : Nil)
    button.click();

  public function get() : Nil
    return nil;

  public function isEnabled()
    return values.enabled.get();

  public function isFocused()
    return values.focused.get();

  public function disable()
    values.enabled.set(false);

  public function enable()
    values.enabled.set(true);

  public function focus()
    button.focus();

  public function blur()
    button.blur();

  public function reset()
    set(defaultValue);
}