class Asteroid extends Floater{
  private double rotSpeed; 
  private int size;
  public Asteroid(){
    rotSpeed = Math.random()*5;
    myColor = color(169,169,169);
    myCenterX = Math.random()*2000;
    myCenterY = Math.random()*2000;
    myXspeed = (Math.random()*2)-1;
    myYspeed = (Math.random()*2)-1;
    myPointDirection = Math.random()*360;
  }
  public void move(){
    turn(rotSpeed);
    super.move();
  }
  public double getMyCenterX(){
    return myCenterX;
  }
  public double getMyCenterY(){
    return myCenterY;
  }
  public void setSpAsteroids(){
    corners = (int)(Math.random()*20);
     size = (int)(Math.random()*2)+2;
    xCorners = new int[corners];
    for (int i = 0; i < corners; i++){
      xCorners[i] = ((int)(Math.random()*30)-15)*size;
    }
    yCorners = new int[corners];
    for (int j = 0; j < corners; j++){
      yCorners[j] = ((int)(Math.random()*30)-15)*size;
    }  
  }
  public void setClassicAsteroids(){
    corners = 7;
    size = (int)(Math.random()*4)+2;    
    xCorners = new int []{6,6,8,9,-4,-12,-5};
    yCorners = new int []{-3,0,4,7,12,6,-5};
    for (int i = 0; i < corners; i++){
      xCorners[i] = xCorners[i] * size;
    }
    for (int i = 0; i < corners; i++){
      yCorners[i] = yCorners[i] * size;
    }    
  }
  public int getSize(){
    return size;
  }
}
  public int getSize(){
    return size;
  }
}
