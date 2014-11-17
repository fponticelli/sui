package sui.controls;

using StringTools;
import sui.controls.Options;

class NumberControl<T : Float> extends SingleInputControl<T> {
  public function new(value : T, name : String, ?options : OptionsNumber<T>) {
    if(null == options)
      options = {};
    super(value, "input", name, "number", options);

    if(null != options.autocomplete)
      input.setAttribute('autocomplete', options.autocomplete ? 'on' : 'off');

    if(null != options.min)
      input.setAttribute('min', '${options.min}');
    if(null != options.max)
      input.setAttribute('max', '${options.max}');
    if(null != options.step)
      input.setAttribute('step', '${options.step}');
    if(null != options.placeholder)
      input.setAttribute('placeholder', '${options.placeholder}');

    if(null != options.list)
      new DataList(el, options.list.map(function(o) {
        return {
          label : o.label,
          value : '${o.value}'
        };
      })).applyTo(input);
    else if(null != options.values)
      new DataList(el, options.values.map(function(o) {
        return {
          label : '${o}',
          value : '${o}'
        };
      })).applyTo(input);
  }
}