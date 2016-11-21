public class Asteroid extends Floater {

  public int rotationSpeed;

  public Asteroid() {
    corners = 4;
    int[] xC = {10,-10,-10,10};
    int[] yC = {-10,-10,10,10};
    xCorners = xC;
    yCorners = yC;
    myPointDirection = 0;
    strokeColor = color(255,127,80);
    fillColor = color(0,0,0,0);
    rotationSpeed = (int)(Math.random()*8-4);

    /* 4 cases for asteroids to spawn in */
    int startPos = (int)(Math.random()*4+1);
    switch (startPos) {
      case 1:
        myCenterX = (int)(Math.random()*MAP_WIDTH);
        myCenterY = 0;
        myDirectionX = (double)(Math.random()*6-3);
        myDirectionY = (double)(Math.random()*3+1);
        break;
      case 2:
        myCenterX = (int)(Math.random()*MAP_WIDTH);
        myCenterY = MAP_HEIGHT;
        myDirectionX = (double)(Math.random()*6-3);
        myDirectionY = (double)(-(Math.random()*3+1));
        break;
      case 3:
        myCenterX = 0;
        myCenterY = (int)(Math.random()*MAP_HEIGHT);
        myDirectionX = (double)(Math.random()*3+1);
        myDirectionY = (double)(Math.random()*6-1);
        break;
      case 4:
        myCenterX = MAP_WIDTH;
        myCenterY = (int)(Math.random()*MAP_HEIGHT);
        myDirectionX = (double)(-(Math.random()*6));
        myDirectionY = (double)(Math.random()*6-3);
        break;
    }
  }

  public Asteroid(int x, int y) {
    corners = 4;
    int[] xC = {10,-10,-10,10};
    int[] yC = {-10,-10,10,10};
    xCorners = xC;
    yCorners = yC;
    myPointDirection = 0;
    strokeColor = color(255,127,80);
    fillColor = color(0,0,0);
    rotationSpeed = (int)(Math.random()*8-4);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = (double)(Math.random()*6-3);
    myDirectionY = (double)(Math.random()*3);
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
  public int getRotationSpeed(){return rotationSpeed;}

  public void move() {
    super.move();
    rotate(rotationSpeed);
  }

}
