public class SpaceShip extends Floater {

  public SpaceShip() {
    corners = 4;
    int[] xC = {12,-6,0,-6};
    int[] yC = {0,-6,0,6};
    xCorners = xC;
    yCorners = yC;
    fillColor = color(0,0,0);
    strokeColor = color(255,255,255);
    myCenterX = width/2;
    myCenterY = height/2;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 0;
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
}
