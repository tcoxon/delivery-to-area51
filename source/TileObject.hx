package;

import haxe.Json;

class TileObject extends NiceSprite {

  private static var properties: Map<String,String>;

  public function new(asset: Dynamic, index: Int, width: Int, height: Int, properties: Map<String,String>) {
    super();
    loadGraphic(asset, true, width, height);

    var frames = [index];
    if (properties.exists("frames")) {
      frames = Util.arrayify(properties.get("frames")).map(function(d):Int{return d;});
    }

    animation.add("default", frames, Globals.AnimationFrameRate, true);
    animation.play("default");

    if (properties.exists("immovable")) {
      immovable = Util.boolify(properties.get("immovable"));
    }

    if (properties.exists("health")) {
      health = Util.floatify(properties.get("health"));
      damageable = true;
    }

    groups.push(properties.get("object"));
    if (properties.exists("groups"))
      for (group in Util.arrayify(properties.get("groups"))) {
        groups.push(group);
      }

    team = "map";
  }

  override public function hurt(damage: Float) {
    if (damage >= health)
      kill();
  }

  override public function toString() {
    return "TileObject"+super.toString()+Json.stringify(properties);
  }

}
