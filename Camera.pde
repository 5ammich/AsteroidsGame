public class Camera {
  public PVector pos;
  public Camera() {
    pos = new PVector(myShip.getX() - 425, myShip.getY() - 350);
  }

  public void draw(MyShip ship) {
    pos.x += ship.getDirectionX();
    pos.y += ship.getDirectionY();
  }

  public void hyperspace(MyShip ship) {
    pos.x = ship.getX() - 425;
    pos.y = ship.getY() - 350;
  }
}
