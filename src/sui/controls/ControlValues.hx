package sui.controls;

using thx.stream.Value;

class ControlValues<T> {
  public var value(default, null) : Value<T>;
  public var focused(default, null) : Value<Bool>;
  public var enabled(default, null) : Value<Bool>;

  public function new(defaultValue : T) {
    value = new Value(defaultValue);
    focused = new Value(false);
    enabled = new Value(true);
  }
}