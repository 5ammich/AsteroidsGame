public class Camera {
  PVector pos;
  double xVelocity, yVelocity;
  Camera() {
    pos = new PVector(0, 0);
  }

  void draw(SpaceShip ship) {
    pos.x += ship.getDirectionX();
    pos.y += ship.getDirectionY();
  }

  void hyperspeed(SpaceShip ship) {
    pos.x = ship.getX() - 425;
    pos.y = ship.getY() - 350;
  }
}
