package;

import flixel.util.*;
import flixel.tile.*;
import flixel.addons.editors.tiled.*;

class Tilemap extends FlxTilemap {
  private var tiledMap: TiledMap;
  private var tileLayer: TiledLayer;
  private var tileset: TiledTileSet;

  public var playerStart: FlxPoint;

  private function new(asset: Dynamic) {
    super();
    tiledMap = new TiledMap(asset);
    initFromTiled();
  }

  private function initFromTiled() {
    widthInTiles = tiledMap.width;
    heightInTiles = tiledMap.height;

    tileset = tiledMap.getGidOwner(1);
    var asset: String = tileset.properties.get("asset");

    if (tiledMap.layers.length != 1)
      throw "TiledMaps must have exactly one tile layer";
    tileLayer = tiledMap.layers[0];
    loadMap(tileLayer.tileArray, asset, 16, 16, 0, 1);

    for (group in tiledMap.objectGroups) {
      for (object in group.objects) {
        addTiledObject(object);
      }
    }
  }

  private function addTiledObject(object: TiledObject) {
    if (object.name == "Player Start") {
      playerStart = new FlxPoint(object.x, object.y);
    }
  }

}
