public class WingShip extends SpaceShip {
  private double currentHealth,maxHealth,ACCELERATION,deltaX,deltaY,angle;
  private boolean inRange;
  private ArrayList<EnemyShip> temp = new ArrayList<EnemyShip>();

  public WingShip() {
    corners = 11;
    int[] xC = {-14,-10,-12,2,4,14,4,2,-12,-10,-14};
    int[] yC = {-4,-4,-12,-12,-2,0,2,12,12,4,4};
    xCorners = xC;
    yCorners = yC;
    fillColor = color(0,191,255);
    strokeColor = color(255,255,255);
    myCenterX = random(150,650);
    myCenterY = random(150,650);
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 0;
    this.currentHealth = 5;
    this.maxHealth = 5;
    ACCELERATION = random(0.05,0.3);
    MAX_VELOCITY = random(2.0,4.0);
    inRange = false;
  }
  public double getMaxHealth(){return maxHealth;}
  public double getCurrentHealth(){return currentHealth;}
  public void setMaxHealth(double health){maxHealth = health;}
  public void setCurrentHealth(double health){
    currentHealth += health;
    if(currentHealth > maxHealth) {
      currentHealth = maxHealth;
    }
  }

  public void move() {

    /* Copies enemyships arraylist to temp arraylist */
    temp.clear();
    for(int e = 0; e < enemyShips.size(); e++) {
      temp.add(enemyShips.get(e));
    }

    if (temp.size() > 0) {
      while(temp.size() > 1) { /* While loop that removes farthest ship */
        if (dist((float)this.myCenterX,(float)this.myCenterY,temp.get(0).getX(),temp.get(0).getY()) > dist((float)this.myCenterX,(float)this.myCenterY,temp.get(1).getX(),temp.get(1).getY())) {
          temp.remove(0);
        } else {
          temp.remove(1);
        }
      } /* In the end, we have an arraylist with size one with the ship closest */

      deltaX = temp.get(0).getX() - myCenterX;
      deltaY = temp.get(0).getY() - myCenterY;

      angle = atan((float)(deltaY/deltaX)) * (180/Math.PI);

      if(temp.get(0).getX() < myCenterX) {
        angle += 180;
      }

      myPointDirection = angle;
      inRange = dist((float)myCenterX,(float)myCenterY,temp.get(0).getX(),temp.get(0).getY()) <= 1000;

    } else { /* Go towards your ship */

      deltaX = myShip.getX() - myCenterX;
      deltaY = myShip.getY() - myCenterY;

      angle = atan((float)(deltaY/deltaX)) * (180/Math.PI);

      if(myShip.getX() < myCenterX) {
        angle += 180;
      }

      myPointDirection = angle;
      inRange = false;
    }

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

  public boolean isInRange() {
    return inRange;
  }
}
