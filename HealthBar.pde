public class HealthBar {
  private double x,y,maxWidth,myHeight,currentWidth,scaleFactor;
  private int fillColor,strokeColor;

  public HealthBar(double x, double y, double maxHealth, double currentHealth) {
    this.x = x - 25;
    this.y = y - 25;
    this.maxWidth = 50;
    this.scaleFactor = maxWidth / maxHealth;
    this.currentWidth = currentHealth * scaleFactor;
    this.fillColor = color(0,255,0); /* green */
    this.myHeight = 7;
  }

  public void show() {
    noStroke();
    fill(fillColor);
    rect((float)this.x, (float)this.y, (float)this.currentWidth, (float)this.myHeight);

    stroke(255);
    fill(0,0,0,0);
    rect((float)this.x, (float)this.y, (float)this.maxWidth, (float)this.myHeight);
  }
}
