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

## TODO

### API
  * macro automap field/variable to control
  * append to container (with position and close controls)

### Controls

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