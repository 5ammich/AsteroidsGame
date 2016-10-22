public class Star {
  double x,y;
  Star() {
    x = (double)(Math.random()*width);
    y = (double)(Math.random()*width);
  }
  public void show() {
    fill(255);
    ellipse((float)x,(float)y,1,1);
  }
}
