public class EnemyShip extends SpaceShip {

  private double maxHealth,currentHealth;
  private double ACCELERATION;
  private String type;

  public EnemyShip(String t) {
    corners = 11;
    int[] xC = {-14,-10,-12,2,4,14,4,2,-12,-10,-14};
    int[] yC = {-4,-4,-12,-12,-2,0,2,12,12,4,4};
    xCorners = xC;
    yCorners = yC;
    switch(t) {
      case "scout":
        type = t;
        fillColor = color(255,0,0);
        strokeColor = color(255,255,255);
        myCenterX = random(4350,4850);
        myCenterY = random(4350,4850);
        myDirectionX = 0;
        myDirectionY = 0;
        myPointDirection = 0;
        maxHealth = 5;
        currentHealth = 5;
        MAX_VELOCITY = random(2.0, 4.0);
        ACCELERATION = random(0.01, 0.05);
        break;
      case "adv":
        type = t;
        fillColor = color(150,0,0);
        strokeColor = color(255,255,255);
        myCenterX = random(4350,4850);
        myCenterY = random(4350,4850);
        myDirectionX = 0;
        myDirectionY = 0;
        myPointDirection = 0;
        maxHealth = 10;
        currentHealth = 10;
        MAX_VELOCITY = random(3.0, 5.0);
        ACCELERATION = random(0.03, 0.07);
        break;
      case "captain":
        type = t;
        fillColor = color(102,0,102);
        strokeColor = color(255,255,255);
        myCenterX = random(4350,4850);
        myCenterY = random(4350,4850);
        myDirectionX = 0;
        myDirectionY = 0;
        myPointDirection = 0;
        maxHealth = 10;
        currentHealth = 10;
        MAX_VELOCITY = random(3.0, 5.0);
        ACCELERATION = random(0.03, 0.07);
        break;
      case "boss":
        type = t;
        fillColor = color(75,0,130);
        strokeColor = color(255,255,255);
        myCenterX = random(4350,4850);
        myCenterY = random(4350,4850);
        myDirectionX = 0;
        myDirectionY = 0;
        myPointDirection = 0;
        maxHealth = 50;
        currentHealth = 50;
        MAX_VELOCITY = 2.0;
        ACCELERATION = 0.25;
        break;
    }
  }
  
  public double getMaxHealth() {return maxHealth;}
  public double getCurrentHealth(){return currentHealth;}
  public void setCurrentHealth(double ch){currentHealth += ch;}

  public void move() {

    /* Point direction */
    double deltaX, deltaY, angle;
    deltaX = myShip.getX() - myCenterX;
    deltaY = myShip.getY() - myCenterY;

    angle = atan((float)(deltaY/deltaX)) * (180/Math.PI);

    if(myShip.getX() < myCenterX) {
      angle += 180;
    }

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
