public class Spacestation {
  public float x,y,radius;
  private float diameter;
  private double currentHealth, maxHealth;
  private String type;
  private int fillColor, strokeColor;

  public Spacestation(String t) {
    this.currentHealth = 10;
    this.maxHealth = 10;
    this.type = t;
    this.diameter = 500;
    this.radius = this.diameter/2;

    if(type == "friendly") {
      this.x = 400;
      this.y = 400;
      this.strokeColor = color(0,0,255);
    } else if (type == "enemy") {
      this.x = 4600;
      this.y = 4600;
      this.strokeColor = color(255,0,0);
    }
  }

  public void show() {
    fill(0,0,0,0);
    stroke(this.strokeColor);
    strokeWeight(20);
    ellipse(this.x, this.y, this.diameter, this.diameter);
  }

  public double getCurrentHealth() {
    return this.currentHealth;
  }

  public void setCurrentHealth(double ch) {
    this.currentHealth += ch;
  }

  public double getMaxHealth() {
    return this.maxHealth;
  }

  public void setMaxHealth(double mh) {
    maxHealth += mh;
  }
}
