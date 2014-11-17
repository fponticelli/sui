package sui.controls;

import sui.controls.Options;

class ColorControl extends DoubleInputControl<String> {
  static var PATTERN = ~/^[#][0-9a-f]{6}$/i;
  public function new(value : String, ?options : OptionsColor) {
    if(null == options)
      options = {};

    super(value, "color", "input", "color", "input", "text", PATTERN.match, options);

    if(null != options.autocomplete)
      input2.setAttribute('autocomplete', options.autocomplete ? 'on' : 'off');

    if(null != options.list)
      new DataList(el, options.list).applyTo(input1).applyTo(input2);
    else if(null != options.values)
      DataList.fromArray(el, options.values).applyTo(input1).applyTo(input2);
  }

  override function setInput1(v : String)
    input1.value = v;

  override function setInput2(v : String)
    input2.value = v;

  override function getInput1() : String
    return input1.value;

  override function getInput2() : String
    return input2.value;
}