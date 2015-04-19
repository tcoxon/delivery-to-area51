package;

import flixel.*;
import flixel.group.*;

class Multigroup extends FlxGroup {

  private var groupNames: Array<String>;
  private var groups: Map<String, FlxGroup>;

  public function new() {
    super();
    groupNames = [];
    groups = new Map<String,FlxGroup>();
  }

  public function insert(groupName: String, member: FlxBasic) {
    getGroup(groupName).add(member);
    // By default, everything also goes into the display group.
    // But you can remove things: getGroup("display").remove(foobar)
    getGroup("display").add(member);
  }

  public function getGroup(name: String): FlxGroup {
    if (!groups.exists(name)) {
      var group = new FlxGroup();
      add(group);
      groups.set(name, group);
      groupNames.push(name);
    }
    return groups.get(name);
  }

  public function getGroups(): Array<String> {
    return groupNames;
  }

  public function forEachGroupMember(func: FlxBasic -> Void) {
    forEachOfType(FlxGroup, function (group) {
      group.forEach(func);
    });
  }

  public function forEachGroupMemberOfType<K>(cls: Class<K>, func: K -> Void) {
    forEachGroupMember(function (member) {
      if (Std.is(member, cls))
        func(cast member);
    });
  }

}
