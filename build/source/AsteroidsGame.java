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

public final int NUM_STARS = 200;
public final int INITIAL_ASTEROIDS = 10;

SpaceShip ship;
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

public void setup() {
  
  frameRate(60);
  ship = new SpaceShip();
  for(int i = 0; i < NUM_STARS; i++) {
    stars.add(new Star());
  }
  for(int i = 0; i < INITIAL_ASTEROIDS; i++) {
    asteroids.add(new Asteroid());
  }
}

public void draw() {
  background(0);
  for(int i = 0; i < stars.size(); i++) {
    stars.get(i).show();
  }
  for(int i = 0; i < INITIAL_ASTEROIDS; i++) {
    asteroids.get(i).move();
    asteroids.get(i).show();
  }
  ship.show();
  ship.move();
}

public void keyPressed() {
  switch(key) {
    case 'w':
      ship.accelerate(0.1f);
      break;
    case 'a':
      ship.rotate(-10);
      break;
    case 's':
      ship.accelerate(-0.1f);
      break;
    case 'd':
      ship.rotate(10);
      break;
    case 'q':
      ship.setX((int)(Math.random()*width));
      ship.setY((int)(Math.random()*height));
      ship.setDirectionX(0);
      ship.setDirectionY(0);
      ship.setPointDirection((int)(Math.random()*360));
      break;
    default:
      break;
  }
}

class Asteroid extends Floater {

  public int rotationSpeed;

  public Asteroid() {
    corners = 4;
    int[] xC = {3,-3,-3,3};
    int[] yC = {-3,-3,3,3};
    xCorners = xC;
    yCorners = yC;
    myCenterX = (int)(Math.random()*width);
    myCenterY = (int)(Math.random()*height);
    myDirectionX = (double)(Math.random()*20);
    myDirectionY = (double)(Math.random()*20);
    myPointDirection = 0;
    rotationSpeed = (int)(Math.random()*50-25);
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
    //wrap around screen
    if(myCenterX > width) {
      myCenterX = 0;
    } else if (myCenterX<0) {
      myCenterX = width;
    } if(myCenterY >height) {
      myCenterY = 0;
    } else if (myCenterY < 0) {
      myCenterY = height;
    }
  }

}

class SpaceShip extends Floater {

  public SpaceShip() {
    corners = 4;
    int[] xC = {12,-6,0,-6};
    int[] yC = {0,-6,0,6};
    xCorners = xC;
    yCorners = yC;
    myColor = color(255,255,255);
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

abstract class Floater {
  protected int corners;  //the number of corners, a triangular floater has 3
  protected int[] xCorners;
  protected int[] yCorners;
  protected int myColor;
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
    fill(myColor);
    stroke(myColor);
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
