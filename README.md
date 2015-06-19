# SUI
## Simple User Interface: Html + Haxe

Example:

```haxe
var ui = new sui.Sui();
ui.bool("boolean", function(v) trace('bool: $v'));
ui.color("color", {
    list : [
      { value : "#FF0000", label : "red" },
      { value : "#00FF00", label : "blue" },
      { value : "#0000FF", label : "green" }]
  }, function(v) trace('color: $v'));
ui.int("int range", 20, {
    min : 10,
    max : 30
  }, function(v) trace('int range: $v'));
ui.trigger("trigger", function() trace("triggered"));
ui.attach();
```

[A live sample of some of the available controls](https://rawgit.com/fponticelli/sui/master/bin/controls.html).

## TODO

### API
  * Sui.add(): macro automap field/variable to control
  * append to container (with position and close controls)
  * Sui.hide()/Sui.show() (with default keyboard control H)
  * Sui.open()/Sui.close()
  * presets? save/restore?
  * listen?

### Controls

  * folder (with open/collapse)
  * select string (options)
  * select float
  * select int
  * select date
  * text area
  * objects and nested objects
  * arrays
  * unstructured objects (create field together with values)


### Inspiration

[dat-gui](http://workshop.chromeexperiments.com/examples/gui/#1--Basic-Usage)
