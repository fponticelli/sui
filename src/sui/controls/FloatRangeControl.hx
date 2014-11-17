package sui.controls;

import sui.controls.Options;
using thx.core.Floats;

class FloatRangeControl extends NumberRangeControl<Float> {
  public function new(value : Float, ?options : OptionsNumber<Float>) {
    if(null == options)
      options = {};

    if(null == options.min)
      options.min = Math.min(value, 0);
    if(null == options.min) {
      var s = null != options.step ? options.step : 1;
      options.max = Math.max(value, s);
    }
    super(value, options);
  }

  override function getInput1() : Float
    return input1.value.canParse() ? input1.value.parse() : null;

  override function getInput2() : Float
    return input2.value.canParse() ? input2.value.parse() : null;
}