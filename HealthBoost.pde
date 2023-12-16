class HealthBoost{
  private int randBoostX, randBoostY;
  public HealthBoost(){
    randBoostX = (int)(Math.random()*1700)+100;
    randBoostY = (int)(Math.random()*800)+100;
    
  }
  public void show(){
    fill(255,0,0);
    stroke(255,0,0);
    ellipse(randBoostX,randBoostY,75,75);
    strokeWeight(10);
    stroke(255,255,255);
    line(randBoostX, randBoostY-25, randBoostX,randBoostY+25);
    line(randBoostX-25, randBoostY, randBoostX+25,randBoostY);

    strokeWeight(1);
  }
  public int getRBX(){
   return randBoostX; 
    
  }
  public int getRBY(){
   return randBoostY; 
    
  }
  public void setRB(){
   randBoostX = (int)(Math.random()*1700)+100; 
   randBoostY = (int)(Math.random()*800)+100;
  }
  public void setRB(int x, int y){
   randBoostX = x;
   randBoostY = y;
  }

  
}
