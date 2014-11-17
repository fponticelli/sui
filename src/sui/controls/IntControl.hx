package sui.controls;

import sui.controls.Options;

class IntControl extends NumberControl<Int> {
  public function new(value : Int, ?options : OptionsNumber<Int>) {
    super(value, "int", options);
  }

  override function setInput(v : Int)
    input.value = '$v';

  override function getInput() : Int
    return Std.parseInt(input.value);
}