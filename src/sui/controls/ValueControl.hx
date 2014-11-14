package sui.controls;

import js.html.Element;
import thx.core.error.NotImplemented;
import thx.core.Timer;
import thx.stream.Value;
import thx.stream.Emitter;
import thx.core.Functions;

class ValueControl<T> extends Control<T> {
  public var defaultValue(default, null) : T;

  var _value : Value<T>;

  public function new(defaultValue : T, ?equals : T -> T -> Bool) {
    if(null == equals)
      equals = Functions.equality;
    this.defaultValue = defaultValue;
    _value = new Value(defaultValue, equals);
    super(_value);
  }

  override public function get() : T
    return _value.get();

  override public function reset()
    this.set(defaultValue);
}