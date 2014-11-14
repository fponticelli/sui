package sui;

import js.html.Element;
import sui.components.Grid;
import sui.controls.*;

class Sui {
  public var el(default, null) : Element;
  var grid : Grid;
  public function new() {
    grid = new Grid();
    el = grid.el;
  }

  public function bind<T>(?label : String, control : Control<T>, callback : T -> Void) {
    if(null == label) {
      grid.add(Single(control));
    } else {
      grid.add(HorizontalPair(new LabelControl(label), control));
    }
    control.streams.value.subscribe(callback);
  }
}