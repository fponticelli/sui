package sui.controls;

typedef Options = {
  ?disabled  : Bool,
  ?autofocus : Bool,
  ?allownull : Bool
}

typedef OptionsList<T> = {> Options,
  ?list : Array<{ label : String, value : T }>,
  ?values : Array<T>
}

typedef OptionsColor = {> OptionsList<String>,
  ?autocomplete : Bool
}

typedef OptionsDate = {> OptionsList<Date>,
  ?min : Date,
  ?max : Date,
  ?autocomplete : Bool
}

typedef OptionsKindDate = {> OptionsDate,
  ?kind : DateKind
}

@:enum
abstract DateKind(String) {
  var date = "date";
  var dateTime = "dateTime";
}

typedef OptionsNumber<T : Float> = {> OptionsList<T>,
  ?min : T,
  ?max : T,
  ?step : T,
  ?autocomplete : Bool,
  ?placeholder : String
}

typedef OptionsKindFloat = {> OptionsNumber<Float>,
  ?kind : FloatKind
}

@:enum
abstract FloatKind(String) {
  var float = "float";
  var time = "time";
}

typedef OptionsText = {> OptionsList<String>,
  ?maxlength : Int,
  ?autocomplete : Bool,
  ?pattern : String,
  ?placeholder : String
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