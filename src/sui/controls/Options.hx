package sui.controls;

typedef Options = {
  ?disabled  : Bool,
  ?autofocus : Bool,
  ?allownull : Bool
}

typedef OptionsDate = {> Options,
  ?min : Date,
  ?max : Date
}

typedef OptionsText = {> Options,
  ?maxlength : Int,
  ?autocomplete : Bool,
  ?pattern : String,
  ?placeholder : String,
  ?list : Array<String>
}