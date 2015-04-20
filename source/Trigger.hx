package;

import haxe.Timer;
import flixel.*;

class Trigger {

  private var pos: Vec2;
  private var size: Vec2;
  private var script: Array<Dynamic>;

  public function new(pos: Vec2, size: Vec2, script: Array<Dynamic>) {
    this.pos = pos;
    this.size = size;
    this.script = script;
  }

  public function activated(map: Tilemap): Bool {
    var basePlayable = map.multigroup.getGroup("basePlayable");
    for (basic in basePlayable) {
      if (!Std.is(basic, FlxObject))
        continue;
      var thing: FlxObject = cast basic;
      if (thing.x >= pos.x && thing.y >= pos.y && thing.x < pos.x + size.x && thing.y < pos.y + size.y)
        return true;
    }
    return false;
  }

  public function runScript(state: PlayState) {
    if (script.length == 0)
      return;

    var action = script.shift();
    if (action == "nextLevel") {
      FlxG.switchState(new PlayState(state.getLevel()+1));
      return;
    }

    if (action.text != null) {
      state.addWindow(new TextWindow(action.text, Util.intify(action.color)).then(function() {
        Timer.delay(function() {
          runScript(state);
        }, 50);
      }));
      return;
    }

    if (action.spawn != null) {
      var sprite = new PlayableSprite(action.spawn, action.parameters);
      sprite.setPoint(state.getMap().labels.get(action.point));
      for (group in sprite.groups)
        state.getGroups().insert(group, sprite);
      return runScript(state);
    }

    if (action.wait != null) {
      Timer.delay(function() {
        runScript(state);
      }, action.wait);
      return;
    }

    if (action.killObjects != null) {
      for (obj in state.getGroups().getGroup(action.killObjects))
        obj.kill();
      return runScript(state);
    }

    runScript(state);
  }

}
