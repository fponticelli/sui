package sui.controls;

import sui.controls.Options;

class TextControl extends SingleInputControl<String> {
  public function new(value : String, ?options : OptionsText) {
    if(null == options)
      options = {};
    super(value, "input", "text", "text", options);

    if(null != options.maxlength)
      input.setAttribute('maxlength', '${options.maxlength}');
    if(options.autocomplete)
      input.setAttribute('autocomplete', 'autocomplete');
    if(null != options.pattern)
      input.setAttribute('pattern', '${options.pattern}');
    if(null != options.placeholder)
      input.setAttribute('placeholder', '${options.placeholder}');
    if(null != options.list)
      DataList.fromArray(el, options.list).applyTo(input);
  }

  override function setInput(v : String)
    input.value = v;

  override function getInput() : String
    return input.value;
}