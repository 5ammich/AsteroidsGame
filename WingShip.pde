public class WingShip extends SpaceShip {
  private double currentHealth,maxHealth;

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
    MAX_VELOCITY = 4.5;
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
/*
  public void move() {
    for(int i = enemyShips.size()-1, i >= 0; i--) {

    }
  }
  */
}
