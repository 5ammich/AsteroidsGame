public abstract class SpaceShip extends Floater {

  protected int MAX_VELOCITY;
  protected final static double SHIP_RECOIL = -0.001;

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
    if(myDirectionX > MAX_VELOCITY) {
      myDirectionX = MAX_VELOCITY;
    }
    if(myDirectionX < -(MAX_VELOCITY)) {
      myDirectionX = -(MAX_VELOCITY);
    }
    if(myDirectionY > MAX_VELOCITY) {
      myDirectionY = MAX_VELOCITY;
    }
    if(myDirectionY < -(MAX_VELOCITY)) {
      myDirectionY = -(MAX_VELOCITY);
    }
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;
  }

  public void recoil() {
    accelerate(SHIP_RECOIL);
  }
}
