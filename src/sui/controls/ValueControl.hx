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

/*

class Control<T> {
  public var el(default, null) : Element;
  public var defaultValue(default, null) : T;
  public var streams(default, null) : ControlStreams<T>;

  var _value : Value<T>;
  var _focus : Value<Bool>;

  public function new(defaultValue : T, ?equals : T -> T -> Bool) {
    if(null == equals)
      equals = Functions.equality;
    this.defaultValue = defaultValue;
    _value = new Value(defaultValue);
    _focus = new Value(false);
    streams = new ControlStreams(_value, _focus);
  }

  public function get() : T
    return _value.get();

  public function set(v : T)
    throw new NotImplemented();

  public function focus()
    throw new NotImplemented();

  public function reset()
    this.set(defaultValue);
}

class ControlStreams<T> {
  public var value(default, null) : Emitter<T>;
  public var focus(default, null) : Emitter<Bool>;
  public function new(value : Emitter<T>, focus : Emitter<Bool>) {
    this.value = value;
    this.focus = focus;
  }
}
*/