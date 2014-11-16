package sui.controls;

import js.html.Element;
import dots.Html;

class DataList {
  public static var nid = 0;
  public var id : String;

  public static function fromArray(container : Element, values : Array<String>)
    return new DataList(container, values.map(function(v) return { value : v, label : v }));

  public function new(container : Element, values : Array<{ label : String, value : String }>) {
    id = 'sui-dl-${++nid}';
    var datalist = Html.parse('<datalist id="$id" style="display:none">${values.map(toOption).join("")}</datalist>');
    container.appendChild(datalist);
  }

  static function toOption(o : { label : String, value : String })
    return '<option value="${StringTools.htmlEscape(o.value)}">${o.label}</option>';

  public function applyTo(el : Element) {
    el.setAttribute("list", id);
    return this;
  }
}