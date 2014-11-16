package sui.controls;

import js.html.Element;

interface  IControl<T> {
  public var el(default, null) : Element;
  public var defaultValue(default, null) : T;
  public var streams(default, null) : ControlStreams<T>;

  public function set(v : T) : Void;
  public function get() : T;

  public function isEnabled() : Bool;
  public function isFocused() : Bool;

  public function disable() : Void;
  public function enable() : Void;

  public function focus() : Void;
  public function blur() : Void;

  public function reset() : Void;
}