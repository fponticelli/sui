package sui.controls;

typedef OptionsText = {> OptionsInput,
  ?maxlength : Int,
  ?autocomplete : Bool,
  ?pattern : String,
  ?placeholder : String
  //?list : Array<String>
}