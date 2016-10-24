public class Star {
  double x,y;
  Star() {
    x = (double)(Math.random()*MAP_WIDTH);
    y = (double)(Math.random()*MAP_HEIGHT);
  }
  public void show() {
    fill(255);
    stroke(255);
    ellipse((float)x,(float)y,1,1);
  }
}
