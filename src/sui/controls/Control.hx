package sui.controls;

import js.html.Element;
import thx.core.error.NotImplemented;
import thx.core.Timer;
import thx.stream.Emitter;
import thx.stream.Value;
import thx.core.Functions;

class Control<T> {
  public var el(default, null) : Element;
  public var streams(default, null) : ControlStreams<T>;

  var _focus : Value<Bool>;

  public function new(valueEmitter : Emitter<T>) {
    _focus = new Value(false);
    streams = new ControlStreams(valueEmitter, _focus);
  }

  public function get() : T
    throw new NotImplemented();

  public function set(v : T)
    throw new NotImplemented();

  public function focus()
    throw new NotImplemented();

  public function reset()
    throw new NotImplemented();
}

class ControlStreams<T> {
  public var value(default, null) : Emitter<T>;
  public var focus(default, null) : Emitter<Bool>;
  public function new(value : Emitter<T>, focus : Emitter<Bool>) {
    this.value = value;
    this.focus = focus;
  }
}