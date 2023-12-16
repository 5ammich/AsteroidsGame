private double oldX, oldY;

class Spaceship extends Floater  
{   
    public Spaceship(int inCorn, int []inXcorn, int[] inYcorn, int inMyCx, int inMyCy){
      myCenterX = inMyCx;
      myCenterY = inMyCy;
      myColor = 255;
      corners = inCorn;
      xCorners = inXcorn;
      yCorners = inYcorn;
      myXspeed = 0;
      myYspeed = 0; 
      myPointDirection = 0;
    }
    public double getMCX(){
      return myCenterX;
    }
    public double getMCY(){
      return myCenterY;
    }
    public double getSpX(){
      return myXspeed;
    }
    public double getSpY(){
      return myYspeed;
    }
    public double getMPD(){
      return myPointDirection; 
    }
    public void setSpX(double enX){
      myXspeed = enX;
    }
    public void setSpY(double enY){
      myYspeed = enY;
    }
    public void setMC(){
      myCenterX = 480*2;
      myCenterY = 625;
    }
    public void setMCS(){
      myCenterX = 560;
      myCenterY = 625;
    }
    public void setMCD(){
      myCenterX = 1375;
      myCenterY = 625;
    }
    
    //make mover either 50 or -50 so you can dodge left or right
    
    public void dodge(int mover){
       oldX = myCenterX;
       oldY = myCenterY;
       myCenterX = myCenterX + mover;
       line((float)oldX,(float)oldY, (float)myCenterX,(float)myCenterY);
       rect((float)((myCenterX + oldX)/2), (float)((myCenterY + oldY)/2), 10, 20);
    }

    public void hyperspace(){
      myCenterX = (int)(Math.random()*900)+50;
      myCenterY = (int)(Math.random()*900)+50;
      myPointDirection = (int)(Math.random()*360);
      myXspeed = 0;
      myYspeed = 0;
    }
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor);   
    stroke(myColor);    
    
    //translate the (x,y) center of the ship to the correct position
    translate((float)myCenterX, (float)myCenterY);

    //convert degrees to radians for rotate()     
    float dRadians = (float)(myPointDirection*(Math.PI/180));
    
    //rotate so that the polygon will be drawn in the correct direction
    rotate(dRadians);
    
    //draw the polygon
    beginShape();
    for (int nI = 0; nI < corners; nI++)
    {
      vertex(xCorners[nI], yCorners[nI]);
    }
    endShape(CLOSE);
    if (key == 'w' || key == 'W'){
      
    }
    //"unrotate" and "untranslate" in reverse order
    rotate(-1*dRadians);
    translate(-1*(float)myCenterX, -1*(float)myCenterY);
  }

}
