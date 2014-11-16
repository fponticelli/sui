package sui.controls;

class LabelControl extends SingleInputControl<String> {
  public function new(value : String, ?options : Options) {
    super(value, "change", "label", "text", options);
    input.setAttribute("readonly", "readonly");
  }

  override function setInput(v : String)
    input.value = v;

  override function getInput() : String
    return input.value;
}