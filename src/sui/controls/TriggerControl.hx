package sui.controls;

using thx.core.Nil;
using thx.core.Nulls;
using thx.stream.Emitter;
using thx.stream.Stream;
using thx.stream.dom.Dom;
import dots.Html;
import js.html.ButtonElement;

class TriggerControl extends Control<Nil> {
  public function new(label : String) {
    var button : ButtonElement = cast Html.parse('<button class="sui-button">$label</button>');
    el = button;
    var emitter = button.streamClick().toNil();
    super(emitter);
    button.streamFocus().feed(_focus);
  }

  override public function get() : Nil
    return nil;

  override public function set(value : Nil)
    (cast el : ButtonElement).click();

  override public function reset()
    set(nil);

  override public function focus()
    (cast el : ButtonElement).focus();
}