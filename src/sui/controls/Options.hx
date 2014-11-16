package sui.controls;

typedef Options = {
  ?disabled  : Bool,
  ?autofocus : Bool,
  ?allownull : Bool
}

typedef OptionsDate = {> Options,
  ?min : Date,
  ?max : Date,
  ?autocomplete : Bool,
  ?list : Array<{ label : String, value : Date }>,
  ?values : Array<Date>
}

typedef OptionsText = {> Options,
  ?maxlength : Int,
  ?autocomplete : Bool,
  ?pattern : String,
  ?placeholder : String,
  ?list : Array<{ label : String, value : String }>,
  ?values : Array<String>
}