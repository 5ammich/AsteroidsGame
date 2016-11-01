public class EnemyShip extends SpaceShip {

  private double maxHealth,currentHealth;
  private double ACCELERATION;

  public EnemyShip() {
    corners = 11;
    int[] xC = {-14,-10,-12,2,4,14,4,2,-12,-10,-14};
    int[] yC = {-4,-4,-12,-12,-2,0,2,12,12,4,4};
    xCorners = xC;
    yCorners = yC;
    fillColor = color(150,0,0);
    strokeColor = color(255,255,255);
    myCenterX = (double)(Math.random()*500+4000);
    myCenterY = (double)(Math.random()*500+4000);
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 0;
    maxHealth = 5;
    currentHealth = 5;
    MAX_VELOCITY = random(2.0, 4.0);
    ACCELERATION = random(0.01, 0.05);
  }

  public double getCurrentHealth(){return currentHealth;}
  public void setCurrentHealth(double ch){currentHealth = ch;}

  public void move() {

    /* Point direction */
    double deltaX, deltaY, angle;
    deltaX = myShip.getX() - myCenterX;
    deltaY = myShip.getY() - myCenterY;
    //System.out.println("Delta X: "+deltaX);
    //System.out.println("Delta Y: "+deltaY);

    angle = atan((float)(deltaY/deltaX)) * (180/Math.PI);

    if(myShip.getX() < myCenterX) {
      angle += 180;
    }

    //System.out.println("Angle "+angle);
    myPointDirection = angle;

    /* Accelerate in point direction */
    accelerate(ACCELERATION);

    /* Limit velocity */
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

    /* Actually move it */
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;

  }
}
