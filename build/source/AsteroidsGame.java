import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AsteroidsGame extends PApplet {

/* Constant variables */
public final int NUM_STARS = 500;
public final int MAX_VELOCITY = 3;
public final double SHIP_ACCELERATION = 0.025f;

/* Object variables */
public SpaceShip myShip;
public ArrayList<Star> stars = new ArrayList<Star>();
public ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
public ArrayList<Bullet> bullets = new ArrayList<Bullet>();

/* Other variables */
public HashMap<String,Boolean> keys = new HashMap<String,Boolean>();

public void setup() {
  /* Set screen size, framerate*/
  
  frameRate(60);

  /* Initialize objects */
  myShip = new SpaceShip();
  for(int i = 0; i < NUM_STARS; i++) {
    stars.add(new Star());
  }

  /* Initialize hashmap keys */
  keys.put("w", false);
  keys.put("s", false);
  keys.put("a", false);
  keys.put("d", false);
  keys.put("q", false);
  keys.put("q", false);
  keys.put(" ", false);

}

public void draw() {
  /* Runs supposedly 60 times per second */
  background(0);
  showStars();
  showAsteroids();
  showBullets();
  checkKeyValues();
  showShip();
}

public void keyPressed() {

  /* Switch case when key is pressed that assigns true
  to a hashmap key */

  switch(key) {
    case 'w':
      keys.put("w", true);
      break;
    case 's':
      keys.put("s", true);
      break;
    case 'a':
      keys.put("a", true);
      break;
    case 'd':
      keys.put("d", true);
      break;
    case 'q':
      /* HYPERSPACE!!! aka teleport somewhere and stop */
      myShip.setX((int)(Math.random()*width));
      myShip.setY((int)(Math.random()*height));
      myShip.setDirectionX(0);
      myShip.setDirectionY(0);
      myShip.setPointDirection((int)(Math.random()*360));
      break;
    case ' ':
      keys.put(" ", true);
      break;
  }
}

public void keyReleased() {

  /* Switch case when key is released that assigns false
  to a hashmap key */

  switch(key) {
    case 'w':
      keys.put("w", false);
    case 's':
      keys.put("s", false);
      break;
    case 'a':
      keys.put("a", false);
      break;
    case 'd':
      keys.put("d", false);
      break;
    case ' ':
      keys.put(" ", false);
      break;
  }
}

public void showAsteroids() {

  /* Randomly adds more asteroids */
  if ((int)(Math.random()*9) == 0) {
    asteroids.add(new Asteroid());
  }

  /* Moves an asteroid, shows it, and then removes it if conditions are met */
  for(int i = asteroids.size()-1; i >= 0; i--) {
    asteroids.get(i).move();
    asteroids.get(i).show();
    if(dist(myShip.getX(), myShip.getY(), asteroids.get(i).getX(), asteroids.get(i).getY()) < 20 || asteroids.get(i).getX() > width || asteroids.get(i).getX() < 0 || asteroids.get(i).getY() > height || asteroids.get(i).getY() < 0) {
      asteroids.remove(i);
    }
  }
}

public void showStars() {
  for(int i = 0; i < stars.size(); i++) {
    stars.get(i).show();
  }
}

/* Runs through hashmap and moves ship accordingly */
public void checkKeyValues() {
  if (keys.get("w") == true) {
    myShip.accelerate(SHIP_ACCELERATION);
  }
  if (keys.get("s") == true) {
    myShip.accelerate(-(SHIP_ACCELERATION));
  }
  if (keys.get("a") == true) {
    myShip.rotate(-3);
  }
  if (keys.get("d") == true) {
    myShip.rotate(3);
  }
  if (keys.get(" ") == true) {
    if((int)(Math.random()*5) == 0) {
      bullets.add(new Bullet(myShip));
    }
  }
}

public void showBullets() {
  for(int i = bullets.size() - 1; i >= 0; i--) {
    bullets.get(i).move();
    bullets.get(i).show();
    for(int j = asteroids.size()-1; j >= 0; j--) {
      if (dist(bullets.get(i).getX(), bullets.get(i).getY(), asteroids.get(j).getX(), asteroids.get(j).getY()) <= 20) {
        asteroids.remove(j);
        bullets.remove(i);
      }
    }
  }
}

/* Show and move spacemyShip function */
public void showShip() {
  if (myShip.getDirectionX() > MAX_VELOCITY) {
    myShip.setDirectionX(MAX_VELOCITY);
  }
  if (myShip.getDirectionX() < -(MAX_VELOCITY)) {
    myShip.setDirectionX(-(MAX_VELOCITY));
  }
  if (myShip.getDirectionY() > MAX_VELOCITY) {
    myShip.setDirectionY(MAX_VELOCITY);
  }
  if (myShip.getDirectionY() < -(MAX_VELOCITY)) {
    myShip.setDirectionY(-(MAX_VELOCITY));
  }
  myShip.show();
  myShip.move();
}
public class Asteroid extends Floater {

  public int rotationSpeed;

  public Asteroid() {
    corners = 4;
    int[] xC = {10,-10,-10,10};
    int[] yC = {-10,-10,10,10};
    xCorners = xC;
    yCorners = yC;
    myPointDirection = 0;
    strokeColor = color(255,255,255);
    fillColor = color(0,0,0);
    rotationSpeed = (int)(Math.random()*8-4);

    /* 4 cases for asteroids to spawn in */
    int startPos = (int)(Math.random()*4+1);
    switch (startPos) {
      case 1:
        myCenterX = (int)(Math.random()*width);
        myCenterY = 0;
        myDirectionX = (double)(Math.random()*6-3);
        myDirectionY = (double)(Math.random()*3);
        break;
      case 2:
        myCenterX = (int)(Math.random()*width);
        myCenterY = height;
        myDirectionX = (double)(Math.random()*6-3);
        myDirectionY = (double)(Math.random()*-3);
        break;
      case 3:
        myCenterX = 0;
        myCenterY = (int)(Math.random()*height);
        myDirectionX = (double)(Math.random()*3);
        myDirectionY = (double)(Math.random()*6-3);
        break;
      case 4:
        myCenterX = width;
        myCenterY = (int)(Math.random()*height);
        myDirectionX = (double)(Math.random()*-3);
        myDirectionY = (double)(Math.random()*6-3);
        break;
    }
  }

  public void setX(int x){myCenterX = x;}
  public int getX(){return (int)myCenterX;}
  public void setY(int y){myCenterY = y;}
  public int getY(){return (int)myCenterY;}
  public void setDirectionX(double x){myDirectionX = x;}
  public double getDirectionX(){return myDirectionX;}
  public void setDirectionY(double y){myDirectionY = y;}
  public double getDirectionY(){return myDirectionY;}
  public void setPointDirection(int degrees){myPointDirection = degrees;}
  public double getPointDirection(){return myPointDirection;}

  public void move() {
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;
    myPointDirection += rotationSpeed;
  }

}
public class Bullet extends Floater {
  public Bullet(SpaceShip ship) {
    corners = 4;
    int[] xC = {2,2,-2,-2};
    int[] yC = {1,-1,-1,1};
    xCorners = xC;
    yCorners = yC;
    fillColor = color(255,255,255);
    strokeColor = color(255,255,255);
    myCenterX = ship.getX();
    myCenterY = ship.getY();
    myPointDirection = ship.getPointDirection();
    double dRadians = myPointDirection * (Math.PI/180);
    myDirectionX = 5 * Math.cos(dRadians) + ship.getDirectionX();
    myDirectionY = 5 * Math.sin(dRadians) + ship.getDirectionY();
  }
  public void setX(int x){myCenterX = x;}
  public int getX(){return (int)myCenterX;}
  public void setY(int y){myCenterY = y;}
  public int getY(){return (int)myCenterY;}
  public void setDirectionX(double x){myDirectionX = x;}
  public double getDirectionX(){return myDirectionX;}
  public void setDirectionY(double y){myDirectionY = y;}
  public double getDirectionY(){return myDirectionY;}
  public void setPointDirection(int degrees){myPointDirection = degrees;}
  public double getPointDirection(){return myPointDirection;}
  public void move() {
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;
  }
}
public abstract class Floater {
  protected int corners;  //the number of corners, a triangular floater has 3
  protected int[] xCorners;
  protected int[] yCorners;
  protected int strokeColor;
  protected int fillColor;
  protected double myCenterX, myCenterY; //holds center coordinates
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel
  protected double myPointDirection; //holds current direction the ship is pointing in degrees
  abstract public void setX(int x);
  abstract public int getX();
  abstract public void setY(int y);
  abstract public int getY();
  abstract public void setDirectionX(double x);
  abstract public double getDirectionX();
  abstract public void setDirectionY(double y);
  abstract public double getDirectionY();
  abstract public void setPointDirection(int degrees);
  abstract public double getPointDirection();

  //Accelerates the floater in the direction it is pointing (myPointDirection)
  public void accelerate (double dAmount) {
    //convert the current direction the floater is pointing to radians
    double dRadians =myPointDirection*(Math.PI/180);
    //change coordinates of direction of travel
    myDirectionX += ((dAmount) * Math.cos(dRadians));
    myDirectionY += ((dAmount) * Math.sin(dRadians));
  }
  public void rotate (int nDegreesOfRotation) {
    //rotates the floater by a given number of degrees
    myPointDirection+=nDegreesOfRotation;
  }
  public void move()   //move the floater in the current direction of travel
  {
    //change the x and y coordinates by myDirectionX and myDirectionY
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;

    //wrap around screen
    if(myCenterX > width)
    {
      myCenterX = 0;
    }
    else if (myCenterX<0)
    {
      myCenterX = width;
    }
    if(myCenterY >height)
    {
      myCenterY = 0;
    }
    else if (myCenterY < 0)
    {
      myCenterY = height;
    }
  }
  public void show()  //Draws the floater at the current position
  {
    fill(fillColor);
    stroke(strokeColor);
    //convert degrees to radians for sin and cos
    double dRadians = myPointDirection*(Math.PI/180);
    int xRotatedTranslated, yRotatedTranslated;
    beginShape();
    for(int nI = 0; nI < corners; nI++) {
      //rotate and translate the coordinates of the floater using current direction
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);
      vertex(xRotatedTranslated,yRotatedTranslated);
    }
    endShape(CLOSE);
  }
}
public class SpaceShip extends Floater {

  public SpaceShip() {
    corners = 4;
    int[] xC = {12,-6,0,-6};
    int[] yC = {0,-6,0,6};
    xCorners = xC;
    yCorners = yC;
    fillColor = color(0,0,0);
    strokeColor = color(255,255,255);
    myCenterX = width/2;
    myCenterY = height/2;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 0;
  }

  public void setX(int x){myCenterX = x;}
  public int getX(){return (int)myCenterX;}
  public void setY(int y){myCenterY = y;}
  public int getY(){return (int)myCenterY;}
  public void setDirectionX(double x){myDirectionX = x;}
  public double getDirectionX(){return myDirectionX;}
  public void setDirectionY(double y){myDirectionY = y;}
  public double getDirectionY(){return myDirectionY;}
  public void setPointDirection(int degrees){myPointDirection = degrees;}
  public double getPointDirection(){return myPointDirection;}
}
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
  public void settings() {  size(1000, 700); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AsteroidsGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
