public class Particle extends Floater {
  public double initX, initY;
  public Particle(double x, double y, int c) {
    corners = 3;
    strokeColor = c;
    fillColor = color(0,0,0);
    int[] xC = {0,5,-5};
    int[] yC = {5,-5,-5};
    xCorners = xC;
    yCorners = yC;
    myCenterX = x;
    myCenterY = y;
    initX = x;
    initY = y;
    myDirectionX = Math.random()*4-2;
    myDirectionY = Math.random()*4-2;
    myPointDirection = Math.random()*360;
  }
  public void setX(int x){}
  public int getX(){return (int)myCenterX;}
  public void setY(int y){}
  public int getY(){return (int)myCenterY;}
  public void setDirectionX(double x){}
  public double getDirectionX(){return myDirectionX;}
  public void setDirectionY(double y){}
  public double getDirectionY(){return myDirectionY;}
  public void setPointDirection(int degrees){}
  public double getPointDirection(){return myPointDirection;}
}
