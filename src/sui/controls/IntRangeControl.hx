package sui.controls;

import sui.controls.Options;
using thx.Ints;

class IntRangeControl extends NumberRangeControl<Int> {
  public function new(value : Int, ?options : OptionsNumber<Int>) {
    if(null == options)
      options = {};

    if(null == options.min)
      options.min = Ints.min(value, 0);
    if(null == options.min) {
      var s = null != options.step ? options.step : 100;
      options.max = Ints.max(value, s);
    }
    super(value, options);
  }

  override function getInput1() : Int
    return input1.value.canParse() ? input1.value.parse() : null;

  override function getInput2() : Int
    return input2.value.canParse() ? input2.value.parse() : null;
}