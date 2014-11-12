package sui.controls;

using thx.core.Nulls;
using thx.stream.dom.Dom;
import js.html.InputElement;

class TextControl extends Control<String> {
  public function new(value : String, ?placeholder : String, allowEmptyString = false) {
    if(allowEmptyString && null == value)
      value = "";
    super(value);
    var input : InputElement = cast dots.Html.parse('<input type="text" value="${value.or("")}" placeholder="${null == placeholder ? "" : placeholder}" />');
    el = input;
    input.streamFocus().feed(_focus);
    var si = input.streamInput();
    if(!allowEmptyString)
      si = si.pluck(_ == "" ? null : _);
    si.subscribe(set);
  }

  override public function set(value : String) {
    (cast el : InputElement).value = value;
    _value.set(value);
  }

  override public function focus()
    (cast el : InputElement).focus();
}