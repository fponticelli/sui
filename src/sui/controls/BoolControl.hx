package sui.controls;

class BoolControl extends SingleInputControl<Bool> {
  public function new(value : Bool, ?options : Options) {
    super(value, "change", "bool", "checkbox", options);
  }

  override function setInput(v : Bool)
    input.checked = v;

  override function getInput() : Bool
    return input.checked;
}