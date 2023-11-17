class Spaceship extends Floater  
{   
    public Spaceship(){
      myCenterX = 500;
      myCenterY = 500;
      myColor = 255;
      corners = 10;
      xCorners = new int[]{0,9,0,27+(28/2),0,9,0,-9,-3,-9};
      yCorners = new int[]{-18,-15,-12,0,12,15,18,9,0,-9};
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
    public void hyperspace(){
      myCenterX = (int)(Math.random()*900)+50;
      myCenterY = (int)(Math.random()*900)+50;
      myPointDirection = (int)(Math.random()*360);
      myXspeed = 0;
      myYspeed = 0;
    }


}
