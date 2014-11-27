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

typedef OptionsSelect<T> = {> OptionsList<T>,
  ?labelfornull : String
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
  ?kind : DateKind,
  ?labelfornull : String,
  ?listonly : Bool
}

enum DateKind {
  DateOnly;
  DateTime;
}

typedef OptionsNumber<T : Float> = {> OptionsList<T>,
  ?min : T,
  ?max : T,
  ?step : T,
  ?autocomplete : Bool,
  ?placeholder : String
}

typedef OptionsKindFloat = {> OptionsNumber<Float>,
  ?kind : FloatKind,
  ?labelfornull : String,
  ?listonly : Bool
}

enum FloatKind {
  FloatNumber;
  FloatTime;
}

typedef OptionsKindInt = {> OptionsNumber<Int>,
  ?labelfornull : String,
  ?listonly : Bool
}

typedef OptionsText = {> OptionsList<String>,
  ?maxlength : Int,
  ?autocomplete : Bool,
  ?pattern : String,
  ?placeholder : String
}

typedef OptionsKindText = {> OptionsText,
  ?kind : TextKind,
  ?labelfornull : String,
  ?listonly : Bool
}

enum TextKind {
  TextEmail;
  TextPassword;
  TextSearch;
  TextTel;
  PlainText;
  TextUrl;
}

typedef OptionsTime = {> Options,
  ?min : Float,
  ?max : Float,
  ?autocomplete : Bool,
  ?list : Array<{ label : String, value : Float }>,
  ?values : Array<Float>
}