class Bullet extends Floater
{
  public Bullet(Spaceship theShip){
    myCenterX = theShip.getMCX();
    myCenterY = theShip.getMCY();
    myXspeed = theShip.getSpX();
    myYspeed = theShip.getSpY();
    myPointDirection = theShip.getMPD();
    accelerate(10);
    
  }
  public double getMCX(){
    return myCenterX;
  }
  public double getMCY(){
    return myCenterY;
  }
 public void move ()  
  {       
    myCenterX += myXspeed;    
    myCenterY += myYspeed;     

  }   
  public void show(){
    stroke(0,0,255);
    strokeWeight(1);
    fill(0, 255, 255);
    ellipse((float)myCenterX,(float)myCenterY,10,10);
    
    
  }
  
  
  
  
}
