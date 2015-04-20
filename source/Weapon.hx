package;

class Weapon {

  private var name: String;

  public function new(name: String) {
    this.name = name;
  }

  public function fire(owner: PlayableSprite, map: Tilemap) {
    var projectile = new PlayableSprite(name);
    for (group in projectile.groups)
      map.multigroup.insert(group, projectile);
    projectile.setPoint(owner.getPoint());
    projectile.controlAim(owner.getAim());
    projectile.setDirection(owner.getDirection());
    projectile.team = owner.team;
    projectile.possessed = owner.possessed;
  }

  public function getConfig(): Dynamic {
    return Util.loadJson("assets/sprites/"+name+".json");
  }

  public function getPrettyName(): String {
    return getConfig().prettyName;
  }

}
