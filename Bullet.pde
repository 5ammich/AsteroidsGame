public class Bullet extends Floater {
  public Bullet(SpaceShip ship) {
    corners = 4;
    int[] xC = {2,2,-2,-2};
    int[] yC = {1,-1,-1,1};
    xCorners = xC;
    yCorners = yC;
    fillColor = color(0,191,255);
    strokeColor = color(0,191,255);
    myCenterX = ship.getX();
    myCenterY = ship.getY();
    myPointDirection = ship.getPointDirection();
    double dRadians = myPointDirection * (Math.PI/180);
    myDirectionX = 10 * Math.cos(dRadians) + ship.getDirectionX();
    myDirectionY = 10 * Math.sin(dRadians) + ship.getDirectionY();
  }

  public void setX(int x){myCenterX = x;}
  public int getX(){return (int)myCenterX;}
  public void setY(int y){myCenterY = y;}
  public int getY(){return (int)myCenterY;}
  public void setDirectionX(double x){myDirectionX = x;}
  public double getDirectionX(){return myDirectionX;}
  public void setDirectionY(double y){myDirectionY = y;}
  public double getDirectionY(){return myDirectionY;}
  public void setPointDirection(int degrees){myPointDirection = degrees;}
  public double getPointDirection(){return myPointDirection;}
  public void move() {
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;
  }
  public void show() {
    fill(fillColor);
    stroke(strokeColor);
    ellipse((float)myCenterX, (float)myCenterY, 2, 2);
  }
}
