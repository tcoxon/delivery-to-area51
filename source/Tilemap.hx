package;

import haxe.Json;
import flixel.*;
import flixel.group.*;
import flixel.tile.*;
import flixel.addons.editors.tiled.*;

class Tilemap extends FlxTilemap {
  private var tiledMap: TiledMap;
  private var tileLayer: TiledLayer;
  private var tileset: TiledTileSet;

  public var multigroup: Multigroup;
  public var backgroundGroup: FlxGroup;
  public var triggers: Array<Trigger> = [];
  public var labels: Map<String,Vec2> = new Map<String,Vec2>();

  private function new(asset: Dynamic) {
    super();
    tiledMap = new TiledMap(asset);
    multigroup = new Multigroup();
    backgroundGroup = new FlxGroup();
    initFromTiled();
  }

  private function initFromTiled() {
    widthInTiles = tiledMap.width;
    heightInTiles = tiledMap.height;

    tileset = tiledMap.getGidOwner(1);
    var asset: String = tileset.properties.get("asset");
    var tileWidth = tiledMap.tileWidth;
    var tileHeight = tiledMap.tileHeight;

    if (tiledMap.layers.length != 1)
      throw "TiledMaps must have exactly one tile layer";
    tileLayer = tiledMap.layers[0];

    for (i in 0...tileLayer.tileArray.length) {
      var index = tileLayer.tileArray[i];
      var x = (i % widthInTiles) * tileWidth;
      var y = Std.int(i / widthInTiles) * tileHeight;
      addTile(x, y, index, asset, null);
    }

    for (group in tiledMap.objectGroups) {
      for (object in group.objects) {
        if (object.gid > -1) {
          addTile(object.x, object.y - tileHeight, object.gid, asset, readProperties(object.custom));
        }
      }
    }

    loadMap(tileLayer.tileArray, asset, tileWidth, tileHeight, 0, tileset.firstGID);

    for (group in tiledMap.objectGroups) {
      for (object in group.objects) {
        if (object.gid <= -1) {
          addTiledObject(object);
        }
      }
    }

    for (i in 0...tileset.numTiles) {
      var allowCollisions = FlxObject.NONE;
      var properties = readProperties(tileset.getProperties(i));
      if (properties != null && Util.boolify(properties.get("colliding"))) {
        allowCollisions = FlxObject.ANY;
      }
      setTileProperties(i + tileset.firstGID, allowCollisions);
    }
  }

  private function addTile(x: Int, y: Int, index: Int, asset: String, overrides: Map<String, String>) {
      var properties = readProperties(tileset.getPropertiesByGid(index));
      properties = Util.mergeProperties(properties, overrides);
      if (properties == null)
        return;
      if (properties.exists("object")) {
        var obj = new TileObject(asset, index-tileset.firstGID, tiledMap.tileWidth, tiledMap.tileHeight, properties);
        obj.setPosition(x, y);
        for (groupName in obj.groups) {
          multigroup.insert(groupName, obj);
        }

        var replacement = 0;
        if (properties.exists("underneath"))
          replacement = Util.intify(properties.get("underneath")) + tileset.firstGID;

        var i = Std.int(x / tiledMap.tileWidth) + Std.int(y / tiledMap.tileHeight) * widthInTiles;
        tileLayer.tileArray[i] = replacement;
      }
  }

  private function readProperties(props: TiledPropertySet): Map<String,String> {
    // *Sigh* TiledPropertySet still contains XML entities...
    if (props == null)
      return null;
    var result: Map<String,String> = new Map<String,String>();
    for (key in props.keysIterator()) {
      result.set(key, StringTools.htmlUnescape(props.get(key)));
    }
    return result;
  }

  private function addTiledObject(object: TiledObject) {
    var pos = new Vec2(object.x, object.y);
    var size = new Vec2(object.width, object.height);
    var properties = readProperties(object.custom);
    var name = StringTools.htmlUnescape(object.name);
    var type = StringTools.htmlUnescape(object.type);

    if (type == "Trigger") {
      var script: Array<Dynamic> = [];
      if (properties.exists("script"))
        script = Util.arrayify(properties.get("script"));
      else
        script = Util.loadJson(properties.get("externalScript"));
      triggers.push(new Trigger(pos, size, script));

    } else if (type == "Text") {
      multigroup.insert("text", new BeebText(name, size.x, pos));

    } else if (type == "Sprite") {
      var parameters = null;
      if (properties.exists("parameters")) {
        parameters = Json.parse(properties.get("parameters"));
      }
      var sprite = new PlayableSprite(name, parameters);
      sprite.setPoint(pos.add(size.multiply(0.5)));
      for (group in sprite.groups) {
        multigroup.insert(group, sprite);
      }

    } else if (type == "Label") {
      labels.set(name, pos.add(size.multiply(0.5)));

    }
  }

}
