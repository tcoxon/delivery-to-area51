package;

import flixel.*;
import flixel.tile.*;
import flixel.addons.editors.tiled.*;

class Tilemap extends FlxTilemap {
  private var tiledMap: TiledMap;
  private var tileLayer: TiledLayer;
  private var tileset: TiledTileSet;

  public var playerStart: Vec2;

  public var multigroup: Multigroup;

  private function new(asset: Dynamic) {
    super();
    tiledMap = new TiledMap(asset);
    multigroup = new Multigroup();
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
      var properties = readProperties(tileset.getPropertiesByGid(index));
      if (properties == null)
        continue;
      if (properties.exists("object")) {
        var obj = new TileObject(asset, index-tileset.firstGID, tileWidth, tileHeight, properties);
        var x = (i % widthInTiles) * tileWidth;
        var y = Std.int(i / widthInTiles) * tileHeight;
        obj.setPosition(x, y);
        multigroup.insert(properties.get("object"), obj);
        if (properties.exists("groups")) {
          for (groupName in Util.arrayify(properties.get("groups"))) {
            multigroup.insert(groupName, obj);
          }
        }
        tileLayer.tileArray[i] = 0;
      }
    }

    loadMap(tileLayer.tileArray, asset, tileWidth, tileHeight, 0, tileset.firstGID);

    for (group in tiledMap.objectGroups) {
      for (object in group.objects) {
        addTiledObject(object);
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

    if (object.type == "Control") {
      if (object.name == "Player Start") {
        playerStart = new Vec2(object.x, object.y);
      }

    } else if (object.type == "Text") {
      multigroup.insert("text", new BeebText(object.name, object.width, pos));
    }
  }

}
