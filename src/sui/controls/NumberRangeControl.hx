package sui.controls;

import sui.controls.Options;
using thx.Floats;

class NumberRangeControl<T : Float> extends DoubleInputControl<T> {
  public function new(value : T, ?options : OptionsNumber<T>) {
    super(value, "float-range", "input", "range", "input", "number", function(v) return v != null, options);

    if(null != options.autocomplete) {
      input1.setAttribute('autocomplete', options.autocomplete ? 'on' : 'off');
      input2.setAttribute('autocomplete', options.autocomplete ? 'on' : 'off');
    }

    if(null != options.min) {
      input1.setAttribute('min', '${options.min}');
      input2.setAttribute('min', '${options.min}');
    }
    if(null != options.max) {
      input1.setAttribute('max', '${options.max}');
      input2.setAttribute('max', '${options.max}');
    }
    if(null != options.step) {
      input1.setAttribute('step', '${options.step}');
      input2.setAttribute('step', '${options.step}');
    }
    if(null != options.placeholder)
      input2.setAttribute('placeholder', '${options.placeholder}');

    if(null != options.list)
      new DataList(el, options.list.map(function(o) {
        return {
          label : o.label,
          value : '${o.value}'
        };
      })).applyTo(input1).applyTo(input2);
    else if(null != options.values)
      new DataList(el, options.values.map(function(o) {
        return {
          label : '${o}',
          value : '${o}'
        };
      })).applyTo(input1).applyTo(input2);

    setInputs(value);
  }

  override function setInput1(v : T)
    input1.value = '$v';

  override function setInput2(v : T)
    input2.value = '$v';
}