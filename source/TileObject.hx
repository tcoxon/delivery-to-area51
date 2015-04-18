package;

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
  }

}
