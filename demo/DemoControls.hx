using dots.Html;
using dots.Query;

import sui.controls.*;

import js.Browser;

class DemoControls {
  public static function main() {
    createControlContainer("Boolean Control", new BoolControl(true));
  }

  public static function createControlContainer<T>(description : String, control : Control<T>) {
    var el = Html.parse('<div class="sample">
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