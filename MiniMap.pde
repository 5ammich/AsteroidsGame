public class MiniMap {
  public MiniMap() {}
  public void render() {
    /* Map Background */
    stroke(255);
    fill(0);
    rect(myShip.getX()+450,myShip.getY()-325,200,200);

    /* Your spaceship on the map */
    stroke(255,255,0);
    fill(255,255,0);
    if(inRange(myShip)) ellipse(myShip.getX()+450+myShip.getX()/(MAP_WIDTH/200),myShip.getY()-325+myShip.getY()/(MAP_HEIGHT/200),5,5);

    /* Enemyships on the map */
    for(int e = enemyShips.size()-1; e >= 0; e--) {
      stroke(255,0,0);
      fill(255,0,0);
      if(inRange(enemyShips.get(e))) ellipse(myShip.getX()+450+enemyShips.get(e).getX()/(MAP_WIDTH/200),myShip.getY()-325+enemyShips.get(e).getY()/(MAP_HEIGHT/200),5,5);
    }

    /* Wingships on the map */
    for(int w = wingShips.size()-1; w >= 0; w--) {
      stroke(0,191,255);
      fill(0,191,255);
      if(inRange(wingShips.get(w))) ellipse(myShip.getX()+450+wingShips.get(w).getX()/(MAP_WIDTH/200),myShip.getY()-325+wingShips.get(w).getY()/(MAP_HEIGHT/200),5,5);
    }

    /* Asteroids on the map */
    stroke(255,127,80);
    fill(255,127,80);
    for(int a = asteroids.size()-1; a >= 0; a--) {
      ellipse(myShip.getX()+450+asteroids.get(a).getX()/(MAP_WIDTH/200),
              myShip.getY()-325+asteroids.get(a).getY()/(MAP_HEIGHT/200),
              1,1);
    }
    /* HOW THIS THING WORKS:
    For each ship/asteroid, move it to upper left corner of minimap, then add the value/scale factor
    */
  }
  private boolean inRange(SpaceShip ship) {
    if(ship.getX() > 0 && ship.getX() < MAP_WIDTH && ship.getY() > 0 && ship.getY() < MAP_HEIGHT) {
      return true;
    } else {
      return false;
    }
  }
}
