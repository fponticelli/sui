using dots.Html;
using dots.Query;

import sui.components.*;
import sui.controls.*;

import js.Browser;

class DemoControls {
  public static function main() {
    var ui = new sui.Sui();
    ui.bool("boolean", function(v) trace('bool: $v'));
    ui.dateTime("date time", {
        list : [{ label : "birthday", value : Date.fromString("1972-05-02 16:01:00") }, { label : "other", value : Date.fromString("1974-06-09") }, { label : "today", value : Date.now() }]
      }, function(v) trace('date time: $v'));
    ui.date("date", {
        list : [{ label : "birthday", value : Date.fromString("1972-05-02") }, { label : "today", value : Date.now() }]
      }, function(v) trace('date: $v'));
    ui.email("email", "", function(v) trace('email: $v'));
    ui.password("secret", "", {
        placeholder : "shhh"
      }, function(v) trace('password: $v'));
    ui.text("text", "", {
        placeholder : "placeholder"
      }, function(v) trace('string: $v'));
    ui.text(null, "", {
        placeholder : "libs",
        values : ["haxe", "thx", "sui"]
      }, function(v) trace('string: $v'));
    ui.time("time", 3600000 * 23, {
        values : [0, 60000, 3600000]
      }, function(t) trace('time: $t'));
    ui.color("color", {
        list : [{ value : "#FF0000", label : "red" }, { value : "#00FF00", label : "blue" }, { value : "#0000FF", label : "green" }]
      }, function(v) trace('color: $v'));
    ui.float("float",  function(v) trace('float: $v'));
    ui.float("float range", 0.5, {
        step : 0.01,
        min  : 0.0,
        max  : 1.0,
        values : [0, 0.5, 1]
      }, function(v) trace('float range: $v'));
    ui.int("int", {
        list : [{ label : "one", value : 1}, { label : "two", value : 2}, { label : "three", value : 3}]
      }, function(v) trace('int: $v'));
    ui.int("int range", 20, {
        min : 10,
        max : 30
      }, function(v) trace('int range: $v'));
    ui.label("temp").set("hello there");
    ui.search("search", "", function(v) trace('search: $v'));
    ui.tel("tel", "", function(v) trace('tel: $v'));
    ui.trigger("trigger", function() trace("triggered"));
    ui.url("url", "", function(v) trace('url: $v'));


    var obj = {
      name : "Sui",
      info : {
        age : 0.1
      }
    };
    ui.bind(obj.name);
    ui.bind(obj.info.age);

    var a = 12;
    ui.bind(a);

    ui.attach();

    var grid = new Grid();
    Browser.document.body.appendChild(grid.el);
    grid.add(Single(new LabelControl("I act like a title")));
    grid.add(HorizontalPair(new LabelControl("got it?"), new BoolControl(true)));
    grid.add(VerticalPair(new LabelControl("name"), new TextControl("sui")));

    createControlContainer(new LabelControl("just a label, not interactive"));
    createControlContainer(new TriggerControl("click me"));
    createControlContainer(new ColorControl("#ff0000"));
    createControlContainer(new BoolControl(true));
    createControlContainer(new TextControl(null, { placeholder : "put text here" }));
    createControlContainer(new FloatControl(7.7));
    createControlContainer(new IntControl(7));
    createControlContainer(new FloatRangeControl(7, { min : 0, max : 100, step : 0.01 }));
    createControlContainer(new IntRangeControl(7, { min : 0, max : 100 }));
  }

  public static function createControlContainer<T>(control : IControl<T>) {
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

    control.streams.focused.subscribe(function(v) {
      focus.textContent = 'focus: $v';
    });
  }
}