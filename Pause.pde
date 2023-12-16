class Pause{
  private int boxX, boxY;
  public Pause(){
    boxX = 150;
    boxY = 120;
    
  }
  public void show(){
    stroke(255);
    strokeWeight(10);
    noFill();
    textSize(50);
    text("INSTRUCTIONS", boxX+15,boxY+55);
    rect(boxX, boxY,350,75);
    strokeWeight(1);
  }
  public int getBoxX(){
    return boxX;
    
  }
  public int getBoxY(){
    return boxY;
    
  }

  
  
}
