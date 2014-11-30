using dots.Html;
using dots.Query;

import sui.components.*;
import sui.controls.*;
import sui.controls.MapControl;
import sui.controls.Options;

import js.Browser;

class DemoControls {
  public static function main() {
    var ui = new sui.Sui();
    ui.bool("boolean", function(v) trace('bool: $v'));
    ui.date("date time", {
        kind : DateTime,
        list : [{ label : "birthday", value : Date.fromString("1972-05-02 16:01:00") }, { label : "other", value : Date.fromString("1974-06-09") }, { label : "today", value : Date.now() }]
      }, function(v) trace('date time: $v'));
    ui.date("date", {
        list : [{ label : "birthday", value : Date.fromString("1972-05-02") }, { label : "today", value : Date.now() }]
      }, function(v) trace('date: $v'));
    ui.text("email", "", {
        kind : TextEmail,
      }, function(v) trace('email: $v'));
    ui.text("secret", "", {
        kind : TextPassword,
        placeholder : "shhh"
      }, function(v) trace('password: $v'));
    ui.text("text", "", {
        placeholder : "placeholder"
      }, function(v) trace('string: $v'));
    ui.text(null, "", {
        placeholder : "libs",
        values : ["haxe", "thx", "sui"]
      }, function(v) trace('string: $v'));
    ui.float("time", 3600000 * 23, {
        kind : FloatTime,
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
    ui.text("search", "", {
        kind : TextSearch
      }, function(v) trace('search: $v'));
    ui.text("tel", "", {
        kind : TextTel
      }, function(v) trace('tel: $v'));
    ui.trigger("trigger", function() trace("triggered"));
    ui.text("url", "", {
        kind : TextUrl
      }, function(v) trace('url: $v'));


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

    createControlContainer(new MapControl([
        1 => "thx",
        3 => "sui",
        4 => "haxe"
      ],
      function() return new Map<Int, String>(),
      function(key) return new IntControl(key),
      function(value) return new TextControl(value)));

    createControlContainer(new ArrayControl([1,2,3],
      5,
      function(value) return new IntRangeControl(value,  { min : 0, max : 10 })));
    createControlContainer(new ArrayControl(["a", "b", "c"],
      "",
      function(value) return new TextControl(value)));

    var createInnerArrayControl = function(v) {
      return new ArrayControl(
        v,
        "",
        function(v) return new TextControl(v),
        {}
      );
    };

    createControlContainer(new ArrayControl(
      [["a", "b", "c"], ["a", "b"], ["a"]],
      ["x", "y"],
      createInnerArrayControl,
      {}));

    createControlContainer(new TextSelectControl("sui", { values : ["thx", "sui", "haxe"], allownull : true }));
    createControlContainer(new NumberSelectControl(3, { values : [1,2,3,4,5,6]}));
    createControlContainer(new NumberSelectControl(0.3, { values : [0.1,0.2,0.3,0.4,0.5,0.6]}));

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
        el = Html.parse('<div class="sample" style="width:200px;float:left;margin:0 20px 20px">
  <h2>$description</h2>
  <div class="container"></div>
  <div class="focus"></div>
  <div class="value"></div>
</div>');
    Browser.document.getElementById("container").appendChild(el);
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