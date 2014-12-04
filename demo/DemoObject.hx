import sui.Sui;

class DemoObject {
  public static function main() {
    var demoObject = new DemoObject(),
        sui = new Sui();

    sui.bind(demoObject);
    sui.attach();
  }

  public var scores : Array<Int>;
  public var name : String;
  public var startedOn : Date;
  public var info : Map<String, String>;
  @:isVar public var enabled(get, set) : Bool;

  public function new() {
    this.scores = [1, 5, 10];
    this.name = "Sui";
    this.startedOn = Date.fromString("2014-11-09");
    this.info = ["a" => "b"];
  }

  public function traceMe()
    trace(Reflect.fields(this)
      .map(function(field) return '$field: ${Reflect.field(this, field)}')
      .join(", "));

  function get_enabled()
    return enabled;

  function set_enabled(v : Bool) {
    trace('enabled set to $v');
    return enabled = v;
  }
}