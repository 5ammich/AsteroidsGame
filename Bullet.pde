public class Bullet extends Floater {
  private String type;
  public Bullet(SpaceShip ship, String t) {
    corners = 4;
    int[] xC = {2,2,-2,-2};
    int[] yC = {1,-1,-1,1};
    xCorners = xC;
    yCorners = yC;
    myCenterX = ship.getX();
    myCenterY = ship.getY();
    myPointDirection = ship.getPointDirection();
    double dRadians = myPointDirection * (Math.PI/180);
    myDirectionX = 20 * Math.cos(dRadians) + ship.getDirectionX();
    myDirectionY = 20 * Math.sin(dRadians) + ship.getDirectionY();
    type = t;
    if(type == "mine" || type == "friendly") {
      fillColor = color(0,191,255);
      strokeColor = color(0,191,255);
    } else if (type == "enemy") {
      fillColor = color(255,0,0);
      strokeColor = color(255,0,0);
    }
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
  public String getType(){return type;}

  public void show() {
    fill(fillColor);
    strokeWeight(3);
    stroke(strokeColor);
    ellipse((float)myCenterX, (float)myCenterY, 2, 2);
  }
}
