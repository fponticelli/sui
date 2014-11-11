package sui.controls;

using thx.core.Nulls;
using thx.stream.dom.Dom;
import js.html.InputElement;

class TextControl extends Control<String> {
  public function new(value : String, allowEmptyString = false) {
    if(allowEmptyString && null == value)
      value = "";
    super(value);
    var input : InputElement = cast dots.Html.parse('<input type="text" value="${value.or("")}" />');
    el = input;
    input.streamFocus().feed(_focus);
    var si = input.streamInput();
    if(!allowEmptyString)
      si = si.map(function(v) return v == "" ? null : v);
    si.subscribe(set);
  }

  override public function set(value : String) {
    (cast el : InputElement).value = value;
    _value.set(value);
  }

  override public function focus()
    (cast el : InputElement).focus();
}