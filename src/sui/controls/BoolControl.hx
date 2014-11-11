package sui.controls;

using thx.stream.dom.Dom;
import js.html.InputElement;

class BoolControl extends Control<Bool> {
  public function new(value : Bool) {
    super(value);
    var input : InputElement = cast dots.Html.parse('<input type="checkbox" ${value ? "checked" : ""}/>');
    el = input;
    input.streamFocus().feed(_focus);
    input.streamChecked().feed(_value);
  }

  override public function set(value : Bool)
    (cast el : InputElement).checked = value;

  override public function focus()
    (cast el : InputElement).focus();
}