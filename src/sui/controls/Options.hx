package sui.controls;

typedef Options = {
  ?disabled  : Bool,
  ?autofocus : Bool,
  ?allownull : Bool
}

typedef OptionsColor = {> Options,
  ?autocomplete : Bool,
  ?list : Array<{ label : String, value : String }>,
  ?values : Array<String>
}

typedef OptionsDate = {> Options,
  ?min : Date,
  ?max : Date,
  ?autocomplete : Bool,
  ?list : Array<{ label : String, value : Date }>,
  ?values : Array<Date>
}

typedef OptionsKindDate = {> OptionsDate,
  ?kind : DateKind
}

@:enum
abstract DateKind(String) {
  var date = "date";
  var dateTime = "dateTime";
}

typedef OptionsNumber<T : Float> = {> Options,
  ?min : T,
  ?max : T,
  ?step : T,
  ?autocomplete : Bool,
  ?placeholder : String,
  ?list : Array<{ label : String, value : T }>,
  ?values : Array<T>
}

typedef OptionsKindFloat = {> OptionsNumber<Float>,
  ?kind : FloatKind
}

@:enum
abstract FloatKind(String) {
  var float = "float";
  var time = "time";
}

typedef OptionsText = {> Options,
  ?maxlength : Int,
  ?autocomplete : Bool,
  ?pattern : String,
  ?placeholder : String,
  ?list : Array<{ label : String, value : String }>,
  ?values : Array<String>
}

typedef OptionsKindText = {> OptionsText,
  ?kind : TextKind
}

@:enum
abstract TextKind(String) {
  var email = "email";
  var password = "password";
  var search = "search";
  var tel = "tel";
  var text = "text";
  var url = "url";
}

typedef OptionsTime = {> Options,
  ?min : Float,
  ?max : Float,
  ?autocomplete : Bool,
  ?list : Array<{ label : String, value : Float }>,
  ?values : Array<Float>
}