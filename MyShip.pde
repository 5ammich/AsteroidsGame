public class MyShip extends SpaceShip {

  private double maxHealth,currentHealth,currentFuel,maxFuel,currentHeat,maxHeat;

  public MyShip() {
    corners = 11;
    int[] xC = {-14,-10,-12,2,4,14,4,2,-12,-10,-14};
    int[] yC = {-4,-4,-12,-12,-2,0,2,12,12,4,4};
    xCorners = xC;
    yCorners = yC;
    fillColor = color(77,77,255);
    strokeColor = color(255,255,255);
    myCenterX = 400;
    myCenterY = 400;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 0;
    maxHealth = 10;
    currentHealth = 10;
    maxFuel = 100;
    currentFuel = 100;
    maxHeat = 50;
    currentHeat = 0;
    MAX_VELOCITY = 5;
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
  public double getMaxFuel(){return maxFuel;}
  public double getCurrentFuel(){return currentFuel;}
  public void setMaxFuel(double mf){maxFuel = mf;}
  public void setCurrentFuel(double cf){
    currentFuel += cf;
    if(currentFuel > maxFuel) {
      currentFuel = maxFuel;
    }
  }
  public double getMaxHeat(){return maxHeat;}
  public double getCurrentHeat(){return currentHeat;}
  public void setMaxHeat(double mh){maxHeat = mh;}
  public void setCurrentHeat(double ch){
    currentHeat += ch;
    if(currentHeat < 0) {
      currentHeat = 0;
    }
  }
  public void hyperspace() {
    if(currentFuel > 10) {
      myCenterX = (int)(Math.random()*MAP_WIDTH);
      myCenterY = (int)(Math.random()*MAP_HEIGHT);
      myDirectionX = 0;
      myDirectionY = 0;
      myPointDirection = (int)(Math.random()*360);
      currentFuel -= 10;
    }
  }
  public void dissapear() {
    corners=0;
    int[] xC = {};
    int[] yC = {};
    xCorners = xC;
    yCorners = yC;
    super.show();
  }
}
