class Star //note that this class does NOT extend Floater
{
  private double myStarX, myStarY, rando;
  private int myColor;
  public Star(){
    myStarX = Math.random()*2000;
    myStarY = Math.random()*2000;
    rando = Math.random()*0.5;
    myColor = color(255,255,0);
  }
  public void move(){
    myStarX = myStarX + rando;
    if (myStarX > 2000){
      myStarX = 0;
    }
  }
  public void show(){
    fill(myColor);
    stroke(myColor);
    ellipse((int)myStarX,(int)myStarY,3,3);
  }
}
