package sui.controls;

import sui.controls.Options;

class FloatControl extends NumberControl<Float> {
  public function new(value : Float, ?options : OptionsNumber<Float>) {
    super(value, "float", options);
  }

  override function setInput(v : Float)
    input.value = '$v';

  override function getInput() : Float
    return Std.parseFloat(input.value);
}