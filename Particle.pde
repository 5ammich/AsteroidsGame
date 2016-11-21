public class Particle extends Floater {
  public Particle(double x, double y, int c) {
    corners = 3;
    strokeColor = c;
    fillColor = color(0,0,0);
    int[] xC = {0,1,-1};
    int[] yC = {1,-1,-1};
    xCorners = xC;
    yCorners = yC;
    myCenterX = x;
    myCenterY = y;
    myDirectionX = random(-2,2);
    myDirectionY = random(-2,2);
    myPointDirection = random(0,360);
  }
  public void setX(int x){}
  public int getX(){return (int)myCenterX;}
  public void setY(int y){}{}
  public int getY(){return (int)myCenterY;}
  public void setDirectionX(double x){}
  public double getDirectionX(){return myDirectionX;}
  public void setDirectionY(double y){}
  public double getDirectionY(){return myDirectionY;}
  public void setPointDirection(int degrees){}
  public double getPointDirection(){return myPointDirection;}
}
