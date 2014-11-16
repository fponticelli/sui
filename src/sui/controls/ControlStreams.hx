package sui.controls;

using thx.stream.Emitter;

class ControlStreams<T> {
  public var value(default, null) : Emitter<T>;
  public var focused(default, null) : Emitter<Bool>;
  public var enabled(default, null) : Emitter<Bool>;
  public function new(value : Emitter<T>, focused : Emitter<Bool>, enabled : Emitter<Bool>) {
    this.value = value;
    this.focused = focused;
    this.enabled = enabled;
  }
}