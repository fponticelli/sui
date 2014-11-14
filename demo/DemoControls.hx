using dots.Html;
using dots.Query;

import sui.controls.*;

import js.Browser;

class DemoControls {
  public static function main() {
    createControlContainer(new LabelControl("just a label, not interactive"));
    createControlContainer(new TriggerControl("click me"));
    createControlContainer(new ColorControl("#ff0000"));
    createControlContainer(new BoolControl(true));
    createControlContainer(new TextControl(null, "put text here"));
    createControlContainer(new FloatControl(7.7));
    createControlContainer(new IntControl(7));
    createControlContainer(new FloatRangeControl(7, 0, 100, 0.01));
    createControlContainer(new IntRangeControl(7, 0, 100));
  }

  public static function createControlContainer<T>(control : Control<T>) {
    var description = Type.getClassName(Type.getClass(control)).split(".").pop(),
        el = Html.parse('<div class="sample">
  <h2>$description</h2>
  <div class="container"></div>
  <div class="focus"></div>
  <div class="value"></div>
</div>');
    Browser.document.body.appendChild(el);
    var container = Query.first(".container", el),
        focus     = Query.first(".focus", el),
        value     = Query.first(".value", el);
    container.appendChild(control.el);

    control.streams.value.subscribe(function(v) {
      value.textContent = 'value: $v';
    });

    control.streams.focus.subscribe(function(v) {
      focus.textContent = 'focus: $v';
    });
  }
}