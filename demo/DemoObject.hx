import sui.Sui;

class DemoObject {
  public static function main() {
    var o = new DemoObject(),
        sui = new Sui();
    sui.bind(o.name);
    sui.bind(o.enabled);
    sui.bind(o.startedOn);
    sui.bind(o.scores);
    sui.bind(o.traceMe);
    sui.attach();
  }

  public var scores : Array<Int>;
  public var name : String;
  public var startedOn : Date;
  @:isVar public var enabled(get, set) : Bool;

  public function new() {
    this.scores = [1, 5, 10];
    this.name = "Sui";
    this.startedOn = Date.fromString("2014-11-09");
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