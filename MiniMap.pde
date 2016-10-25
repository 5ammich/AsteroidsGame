public class MiniMap {
  public MiniMap() {}
  public void render() {
    /* Map Background */
    stroke(255);
    fill(0);
    rect(myShip.getX()+450,myShip.getY()-325,200,200);

    /* Your spaceship on the map */
    stroke(0,0,255);
    fill(0,0,255);
    ellipse(myShip.getX()+450+myShip.getX()/(MAP_WIDTH/200),myShip.getY()-325+myShip.getY()/(MAP_HEIGHT/200),5,5);

    /* Asteroids on the map */
    stroke(255,127,80);
    fill(255,127,80);
    for(int a = asteroids.size()-1; a >= 0; a--) {
      ellipse(myShip.getX()+450+asteroids.get(a).getX()/(MAP_WIDTH/200),
              myShip.getY()-325+asteroids.get(a).getY()/(MAP_HEIGHT/200),
              1,1);
    }
  }
}
