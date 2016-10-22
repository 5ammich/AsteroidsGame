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
SpaceShip ship;
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

/* Other variables */
HashMap<String,Boolean> keys = new HashMap<String,Boolean>();

public void setup() {
  /* Set screen size, framerate*/
  
  frameRate(60);

  /* Initialize objects */
  ship = new SpaceShip();
  for(int i = 0; i < NUM_STARS; i++) {
    stars.add(new Star());
  }

  /* Initialize hashmap keys */
  keys.put("w", false);
  keys.put("s", false);
  keys.put("a", false);
  keys.put("d", false);
  keys.put("q", false);
}

public void draw() {
  background(0);
  showStars();
  showAsteroids();
  checkKeyValues();
  showShip();
}

public void keyPressed() {
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
      ship.setX((int)(Math.random()*width));
      ship.setY((int)(Math.random()*height));
      ship.setDirectionX(0);
      ship.setDirectionY(0);
      ship.setPointDirection((int)(Math.random()*360));
      break;
  }
}

public void keyReleased() {
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
  }
}

public void showAsteroids() {
  if ((int)(Math.random()*10) == 0) {
    asteroids.add(new Asteroid());
  }
  for(int i = asteroids.size()-1; i >= 0; i--) {
    asteroids.get(i).move();
    asteroids.get(i).show();
    if(dist(ship.getX(), ship.getY(), asteroids.get(i).getX(), asteroids.get(i).getY()) < 20 || asteroids.get(i).getX() > width || asteroids.get(i).getX() < 0 || asteroids.get(i).getY() > height || asteroids.get(i).getY() < 0) {
      asteroids.remove(i);
    }
  }
}

public void showStars() {
  for(int i = 0; i < stars.size(); i++) {
    stars.get(i).show();
  }
}

public void checkKeyValues() {
  if (keys.get("w") == true) {
    ship.accelerate(SHIP_ACCELERATION);
  }
  if (keys.get("s") == true) {
    ship.accelerate(-(SHIP_ACCELERATION));
  }
  if (keys.get("a") == true) {
    ship.rotate(-3);
  }
  if (keys.get("d") == true) {
    ship.rotate(3);
  }
  if (ship.getDirectionX() > MAX_VELOCITY) {
    ship.setDirectionX(MAX_VELOCITY);
  }
  if (ship.getDirectionX() < -(MAX_VELOCITY)) {
    ship.setDirectionX(-(MAX_VELOCITY));
  }
  if (ship.getDirectionY() > MAX_VELOCITY) {
    ship.setDirectionY(MAX_VELOCITY);
  }
  if (ship.getDirectionY() < -(MAX_VELOCITY)) {
    ship.setDirectionY(-(MAX_VELOCITY));
  }
}

/* Show and move spaceship function */
public void showShip() {
  ship.show();
  ship.move();
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
    rotationSpeed = (int)(Math.random()*6-3);

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
