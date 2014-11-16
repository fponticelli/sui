package sui.controls;

import sui.controls.Options;

class BaseTextControl extends SingleInputControl<String> {
  public function new(value : String, name : String, type : String, ?options : OptionsText) {
    if(null == options)
      options = {};
    super(value, "input", name, type, options);

    if(null != options.maxlength)
      input.setAttribute('maxlength', '${options.maxlength}');
    if(null != options.autocomplete)
      input.setAttribute('autocomplete', options.autocomplete ? 'on' : 'off');
    if(null != options.pattern)
      input.setAttribute('pattern', '${options.pattern}');
    if(null != options.placeholder)
      input.setAttribute('placeholder', '${options.placeholder}');
    if(null != options.list)
      new DataList(el, options.list).applyTo(input);
    else if(null != options.values)
      DataList.fromArray(el, options.values).applyTo(input);
  }

  override function setInput(v : String)
    input.value = v;

  override function getInput() : String
    return input.value;
}