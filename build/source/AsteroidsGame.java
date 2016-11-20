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

// Explosion animation
// spacestation health and heal, upgrade stuff, etc.
// E to go warp speed

/* Connect processing with browser js */
public interface JavaScript {
  public void playSound(String s);
  public void keyDown(String k);
  public void keyUp(String k);
}
public void bindJavascript(JavaScript js) {
  javascript = js;
}
public JavaScript javascript;

/* Constant variables */
public final int NUM_STARS = 2000;
public final double MY_SHIP_ACCELERATION = 0.1f;
public final double ASTEROID_SPAWN_CHANCE = 10;
public final int MAX_ASTEROIDS = 20;
public final int INITIAL_ENEMIES = 2;
public final int INITIAL_WINGSHIPS = 2;
public final int MAP_WIDTH = 5000;
public final int MAP_HEIGHT = 5000;
public final int OUT_OF_BOUNDS_COLOR = color(50,0,0);
public final int displayWidth = 1100;
public final int displayHeight = 700;
public PImage spaceship;
public final int BOX_KEY_SIZE = 75;

/* Game variables */
public int gameState = 0;
public int score;
public int asteroidsDestroyed;
public int bulletsShot;
public int enemiesDestroyed;
public int scrap = 0;
public boolean titleMusicPlaying = false;
public boolean bgMusicPlaying = false;

/* Object variables */
public MyShip myShip;
public ArrayList<WingShip> wingShips = new ArrayList<WingShip>();
public ArrayList<EnemyShip> enemyShips = new ArrayList<EnemyShip>();
public ArrayList<Star> stars = new ArrayList<Star>();
public ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
public ArrayList<Bullet> bullets = new ArrayList<Bullet>();
public ArrayList<HealthBar> healthBars = new ArrayList<HealthBar>();
public Spacestation friendlySpacestation;
public Spacestation enemySpacestation;
public Camera camera;
public MiniMap minimap;

/* Other variables */
public HashMap<String,Boolean> keys = new HashMap<String,Boolean>();
public String missionText = "placeholder";

public void setup() {
  /* Set screen size, framerate */
  //fullScreen(P2D);
  
  frameRate(60);

  /* Initialize hashmap keys */
  keys.put("w", false);
  keys.put("s", false);
  keys.put("a", false);
  keys.put("d", false);
  keys.put("q", false);
  keys.put(" ", false);

  /* Initialize objects that WILL NOT change */
  spaceship = loadImage("spaceship.png");
  friendlySpacestation = new Spacestation("friendly");
  enemySpacestation = new Spacestation("enemy");
}

/* Manages gamestates */
public void draw() {
  switch(gameState) {
    case 0:
      titleScreen();
      break;
    case 1:
      gameScreen();
      break;
    case 2:
      pauseScreen();
      break;
    case 3:
      gameOverScreen();
      break;
    case 4:
      creditsScreen();
      break;
    case 5:
      upgradeScreen();
      break;
  }
  // Put this bottom code somewhere else and make it work
  if(myShip.getCurrentHealth() <= 0) {
    gameState = 3;
  }
}

public void titleScreen() {
  /* Clear and reset arraylists and variables */
  bullets.clear();
  enemyShips.clear();
  asteroids.clear();
  stars.clear();
  wingShips.clear();
  score = 0;
  asteroidsDestroyed = 0;
  bulletsShot = 0;
  enemiesDestroyed = 0;

  /* Initialize objects */
  myShip = new MyShip();
  camera = new Camera();
  minimap = new MiniMap();
  for(int i = 0; i < NUM_STARS; i++) {
    if(stars.size() <= NUM_STARS) {
      stars.add(new Star());
    }
  }
  for(int i = 0; i < MAX_ASTEROIDS; i++) {
    if(asteroids.size() < MAX_ASTEROIDS) {
      int x = (int)(Math.random()*MAP_WIDTH);
      int y = (int)(Math.random()*MAP_HEIGHT);
      asteroids.add(new Asteroid(x,y));
    }
  }
  for(int i = 0; i < INITIAL_ENEMIES; i++) {
    if(enemyShips.size() < INITIAL_ENEMIES) {
      enemyShips.add(new EnemyShip("scout"));
    }
  }

  for(int i = 0; i < INITIAL_WINGSHIPS; i++) {
    if(wingShips.size() < INITIAL_WINGSHIPS) {
      wingShips.add(new WingShip());
    }
  }

  background(0);
  /* Title screen graphics */
  spaceship.resize(200,200);
  image(spaceship,0,0);
  textSize(16);
  textAlign(CENTER);
  fill(255);
  textSize(32);
  text("Asteroids and more", width/2,height/2-40);
  text("ENTER to start", width/2, height/2);

  /* Title screen music */
  if(titleMusicPlaying == false && javascript != null) {
    javascript.playSound("title");
    titleMusicPlaying = true;
    bgMusicPlaying = false;
  }
}

public void gameScreen() {
  /* Moves camera view */
  translate(-camera.pos.x, -camera.pos.y);
  camera.draw(myShip);

  /* Resets draw screen */
  background(OUT_OF_BOUNDS_COLOR);

  /* Checks which keys are held down and updates accordingly */
  checkKeyValues();
  addEnemies();
  updateCollisions();

  /* Show everything in this order*/
  showSpace();
  showAsteroids();
  friendlySpacestation.show();
  enemySpacestation.show();
  showBullets();
  showSpaceShips();
  showHealthBars();
  showShip();
  showGUI();

  /* Background music */
  if(bgMusicPlaying == false && javascript != null) {
    javascript.playSound("bg");
    bgMusicPlaying = true;
    titleMusicPlaying = false;
  }
}

public void pauseScreen() {
  /* Pause screen graphics */
  fill(0,0,0,1);
  stroke(0);
  rect(0,0,displayWidth,displayHeight);
  textSize(24);
  fill(255);
  text("Paused.",50,100);
  stroke(255);
  strokeWeight(5);
  fill(0,0,0,0); // transparent
  rect(250,75,BOX_KEY_SIZE,BOX_KEY_SIZE);
  rect(165,160,BOX_KEY_SIZE,BOX_KEY_SIZE);
  rect(250,160,BOX_KEY_SIZE,BOX_KEY_SIZE);
  rect(335,160,BOX_KEY_SIZE,BOX_KEY_SIZE);
}

public void gameOverScreen() {
  /* Explode NEEDS ANIMATION!!!*/
  myShip.dissapear();

  /* Game over graphics */
  strokeWeight(1);
  stroke(255,0,0);
  fill(255,255,255);
  textAlign(CENTER);
  textSize(24);
  text("YOU DIED",width/2, height/2);
  text("ENTER to play again",width/2, height/2+20);
}

public void creditsScreen() {
  // VERY VERY VERY VERY UNLIKELY
}

public void upgradeScreen() {

}

/* Switch case when key is pressed that assigns TRUE to a hashmap key
   Only if running processing natively */
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
      if(hasFuel()) {
        myShip.hyperspace();
        camera.hyperspace(myShip);
      } break;
    case ' ':
      keys.put(" ", true);
      break;
    case TAB:
      if(gameState == 1) {
        gameState = 2;
      } else if (gameState == 2) {
        gameState = 1;
      }
      break;
  }
}

/* Javascript to processing key function*/
public void keyDown(String k) {
  switch(k) {
    case "w":
      keys.put("w",true);
      break;
    case "a":
      keys.put("a",true);
      break;
    case "s":
      keys.put("s",true);
      break;
    case "d":
      keys.put("d",true);
      break;
    case " ":
      keys.put(" ", true);
      break;
  }
}
public void keyUp(String k) {
  switch (k) {
    case "w":
      keys.put("w",false);
    break;
    case "a":
      keys.put("a",false);
    break;
    case "s":
      keys.put("s",false);
    break;
    case "d":
      keys.put("d",false);
    break;
    case "q":
    if(hasFuel()) {
      myShip.hyperspace();
      camera.hyperspace(myShip);
    } break;
    case " ":
      keys.put(" ", false);
      break;
    case "ENTER":
      if(gameState == 3) {
        gameState = 0;
      } else if (gameState == 0) {
        gameState = 1;
      }
      break;
    case "ESC":
      if(gameState == 1) {
        gameState = 2;
      } else if (gameState == 2) {
        gameState = 1;
      }
      break;
  }
}

/* NATIVE PROCESSING KEY FUNCTIONS */
/* Switch case when key is released that assigns FALSE to a hashmap key */
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
    case ' ':
      keys.put(" ", false);
      break;
    case ENTER:
      if(gameState == 3) {
        gameState = 0;
      } else if (gameState == 0) {
        gameState = 1;
      }
      break;
  }
}

/* Runs through hashmap and moves ship accordingly */
public void checkKeyValues() {
  if (keys.get("w") == true && hasFuel()) {
    myShip.accelerate(MY_SHIP_ACCELERATION);
    myShip.setCurrentFuel(-0.02f);
  }
  if (keys.get("s") == true && hasFuel()) {
    myShip.accelerate(-(MY_SHIP_ACCELERATION));
    myShip.setCurrentFuel(-0.02f);
  }
  if (keys.get("a") == true) {
    myShip.rotate(-3);
  }
  if (keys.get("d") == true) {
    myShip.rotate(3);
  }
  if (keys.get(" ") == true) {
      bullets.add(new Bullet(myShip,"mine"));
      myShip.setCurrentHeat(0.2f);
      bulletsShot++;
      myShip.recoil();
  }
}

public void showSpaceShips() {
  for(int e = enemyShips.size()-1; e >= 0; e--) {
    enemyShips.get(e).move();
    enemyShips.get(e).show();
    if (dist(enemyShips.get(e).getX(), enemyShips.get(e).getY(), myShip.getX(), myShip.getY()) <= 1000 && (int)(Math.random()*10) == 0) {
      /* Randomly shoots */
      bullets.add(new Bullet(enemyShips.get(e), "enemy"));
    }
  }
  for(int w = wingShips.size()-1; w >= 0; w--) {
    wingShips.get(w).move();
    wingShips.get(w).show();
    if(wingShips.get(w).isInRange() && (int)(Math.random()*10) == 0) {
      bullets.add(new Bullet(wingShips.get(w), "friendly"));
    }
  }
}

public void showAsteroids() {
  /* Randomly adds more asteroids */
  if ((int)(Math.random()*ASTEROID_SPAWN_CHANCE) == 0 && asteroids.size() <= MAX_ASTEROIDS) {
    asteroids.add(new Asteroid());
  }
  for(int a = asteroids.size()-1; a >= 0; a--) {
    asteroids.get(a).move();
    asteroids.get(a).show();
  }
}

public void showSpace() {
  /* Draws black space rect and shows the stars */
  fill(0);
  strokeWeight(1);
  stroke(0);
  rect(0,0,MAP_WIDTH,MAP_HEIGHT);
  for(int i = 0; i < stars.size(); i++) {
    stars.get(i).show();
  }
}

/* Moves and shows bullets */
public void showBullets() {
  for (int b = bullets.size() -1; b >= 0; b--) {
    bullets.get(b).move();
    bullets.get(b).show();
  }
}

/* Updates, moves, and shows your spaceship */
public void showShip() {
  myShip.move();
  myShip.show();
}

public void updateCollisions() {
  /* Loops through each asteroid */
  for(int a = asteroids.size()-1; a >= 0; a--) {
    /* Remove asteroid if it's out of the screen or if it hits a ship */
    if(asteroids.get(a).getX() > MAP_WIDTH || asteroids.get(a).getX() < 0 || asteroids.get(a).getY() > MAP_HEIGHT || asteroids.get(a).getY() < 0 || asteroids.get(a).getRotationSpeed() == 0) {
      asteroids.remove(a);
      //asteroid explosion
    } else if (dist(asteroids.get(a).getX(), asteroids.get(a).getY(),myShip.getX(), myShip.getY()) <= 20) {
      /* If asteroid hits your ship, GAME OVER */
      asteroids.remove(a);
      myShip.setCurrentHealth(-myShip.getCurrentHealth());
      myShip.setCurrentFuel(-myShip.getCurrentFuel());
      myShip.setCurrentHeat(-myShip.getCurrentHeat());
      gameState = 3;
    } else {
      /* Loops through all enemyships */
      for(int e = enemyShips.size() - 1; e >= 0; e--) {
        /* Remove asteroid and enemyship if they collide */
        /*
        if(dist(asteroids.get(a).getX(), asteroids.get(a).getY(),enemyShips.get(e).getX(), enemyShips.get(e).getY()) <= 20) {
          enemyShips.remove(e);
          asteroids.remove(a);
        }
        */
      }
    }
  }
  /* Loops through each bullet */
  for(int b = bullets.size()-2; b >= 0; b--) {
    /* Remove bullet if it's out of the screen or if it hits an asteroid */
    if(bullets.get(b).getX() > MAP_WIDTH || bullets.get(b).getX() < 0 || bullets.get(b).getY() > MAP_HEIGHT || bullets.get(b).getY() < 0 || dist(myShip.getX(), myShip.getY(), bullets.get(b).getX(), bullets.get(b).getY()) > 700) {
      bullets.remove(b);
    } else if(dist(bullets.get(b).getX(), bullets.get(b).getY(), myShip.getX(), myShip.getY()) <= 20 && bullets.get(b).getType() == "enemy") {
      /* Remove bullet and reduce your ship health */
      bullets.remove(b);
      myShip.setCurrentHealth(-0.5f);
    } else {
      for (int a = asteroids.size()-2; a >= 0; a--) {
        /* Remove bullet and asteroid */
        if (dist(asteroids.get(a).getX(), asteroids.get(a).getY(),bullets.get(b).getX(), bullets.get(b).getY()) < 20) {
          bullets.remove(b);
          asteroids.remove(a);
          if(bullets.get(b).getType() == "mine") {
            asteroidsDestroyed++;
            score++;
          }
        }
      }
    }
  }
  /* Loop through enemy ships */
  for(int e = enemyShips.size() - 1; e >= 0; e--) {
    if (enemyShips.get(e).getCurrentHealth() <= 0) {
      enemyShips.remove(e);
      score += 5;
      if(javascript != null) javascript.playSound("explode");
    } else {
      for(int b = bullets.size() - 1; b >= 0; b--) {
        if(dist(bullets.get(b).getX(), bullets.get(b).getY(), enemyShips.get(e).getX(), enemyShips.get(e).getY()) <= 20 && (bullets.get(b).getType() == "friendly" || bullets.get(b).getType() == "mine")) {
          bullets.remove(b);
          enemyShips.get(e).setCurrentHealth(-0.5f);
        }
      }
    }
  }

  /* Reduce health if out of bounds */
  if(myShip.getX() < 0 || myShip.getX() > MAP_WIDTH || myShip.getY() < 0 || myShip.getY() > MAP_HEIGHT) {
    myShip.setCurrentHealth(-0.1f);
    if(myShip.getCurrentHealth()<=0){myShip.setCurrentFuel(-myShip.getCurrentFuel());myShip.setCurrentHeat(-myShip.getCurrentHeat());}
  }

  /* Cool down ship */
  myShip.setCurrentHeat(-0.1f);

  /* Over heat ends life */
  if(myShip.getCurrentHeat() >= myShip.getMaxHeat()) {
    bullets.clear();
    myShip.setCurrentHealth(-myShip.getCurrentHealth());
    myShip.setCurrentFuel(-myShip.getCurrentFuel());
  }

  /* Spacestation heals spaceship*/
  if(dist(myShip.getX(), myShip.getY(), friendlySpacestation.x, friendlySpacestation.y) <= friendlySpacestation.radius) {
    myShip.setCurrentHealth(0.1f);
    myShip.setCurrentFuel(1);
  }
}

public void showGUI() {

  /* Render minimap */
  minimap.render();
  textSize(15);

  /* Draw gray sidebar */
  strokeWeight(1);
  stroke(255);
  fill(100,100);
  rect(myShip.getX()+425,myShip.getY()-400,275,1050);

  /* Health text */
  fill(255);
  textAlign(LEFT);
  text("Health",myShip.getX()+450,myShip.getY()-90);

  /* Health bar */
  strokeWeight(1);
  stroke(255);
  fill(255,0,0);
  rect(myShip.getX()+450,
       myShip.getY()-80,
       (float)(myShip.getCurrentHealth()*(200/myShip.getMaxHealth())),
       10);

 /* Fuel text */
 fill(255);
 textAlign(LEFT);
 text("Fuel",myShip.getX()+450,myShip.getY()-50);

  /* Fuel bar */
  strokeWeight(1);
  stroke(255);
  fill(0,255,0);
  rect(myShip.getX()+450,
       myShip.getY()-40,
       (float)(myShip.getCurrentFuel()*(200/myShip.getMaxFuel())),
       10);

  /* Heat text */
  fill(255);
  textAlign(LEFT);
  text("Heat",myShip.getX()+450,myShip.getY()-10);

  /* Heat bar */
  strokeWeight(1);
  stroke(255);
  fill(0,0,255);
  rect(myShip.getX()+450,
       myShip.getY()-0,
       (float)(myShip.getCurrentHeat()*(200/myShip.getMaxHeat())),
       10);

  /* Points */
  fill(255);
  textAlign(LEFT);
  text("Score: " + score,myShip.getX()+450,myShip.getY()+40);

  /* Stats */
  text("Scrap: " + scrap,myShip.getX()+450,myShip.getY()+80);
  text("Max health: " + myShip.getMaxHealth(),myShip.getX()+450,myShip.getY()+100);
  text("Armor: ",myShip.getX()+450,myShip.getY()+120);
  text("Laser power: ",myShip.getX()+450,myShip.getY()+140);
  text("Max fuel: " + myShip.getMaxFuel(),myShip.getX()+450,myShip.getY()+160);
  text("Fuel efficency: ",myShip.getX()+450,myShip.getY()+180);
  text("Max heat: " + myShip.getMaxHeat(),myShip.getX()+450,myShip.getY()+200);
  text("Ally ships: " + wingShips.size(),myShip.getX()+450,myShip.getY()+220);
  text("Ally health: " + wingShips.size(),myShip.getX()+450,myShip.getY()+240);
  text("Spacestation Health: " + friendlySpacestation.getMaxHealth(),myShip.getX()+450,myShip.getY()+260);
  text("Matter converter efficency: " + friendlySpacestation.getMaxHealth(),myShip.getX()+450,myShip.getY()+280);

  /* Pause */
  text("ESC to pause",myShip.getX()+450,myShip.getY()+325);
}

public void addEnemies() {
  if(score <= 20) {
    if((int)random(0,200) == 0) enemyShips.add(new EnemyShip("scout"));

  } else if (score <= 50) {
    if((int)random(0,175) == 0) enemyShips.add(new EnemyShip("scout"));
    if((int)random(0,300) == 0) enemyShips.add(new EnemyShip("adv"));

  } else if (score <= 200) {
    if((int)random(0,175) == 0) enemyShips.add(new EnemyShip("scout"));
    if((int)random(0,275) == 0) enemyShips.add(new EnemyShip("adv"));

  } else if (score <= 500) {
    if((int)random(0,175) == 0) enemyShips.add(new EnemyShip("scout"));
    if((int)random(0,275) == 0) enemyShips.add(new EnemyShip("adv"));
    if((int)random(0,500) == 0) enemyShips.add(new EnemyShip("captain"));

  } else if (score <= 1000) {
    if((int)random(0,175) == 0) enemyShips.add(new EnemyShip("scout"));
    if((int)random(0,275) == 0) enemyShips.add(new EnemyShip("adv"));
    if((int)random(0,400) == 0) enemyShips.add(new EnemyShip("captain"));

  } else if (score <= 5000) {
    if((int)random(0,175) == 0) enemyShips.add(new EnemyShip("scout"));
    if((int)random(0,275) == 0) enemyShips.add(new EnemyShip("adv"));
    if((int)random(0,300) == 0) enemyShips.add(new EnemyShip("captain"));
    if((int)random(0,500) == 0) enemyShips.add(new EnemyShip("boss"));

  }
}

public void showHealthBars() {
  healthBars.clear();
  /* Update health bars */
  for (int e = 0; e < enemyShips.size(); e++) {
    healthBars.add(new HealthBar(enemyShips.get(e).getX(),enemyShips.get(e).getY(),enemyShips.get(e).getMaxHealth(),enemyShips.get(e).getCurrentHealth()));
  }
  for (int w = 0; w < wingShips.size(); w++) {
    healthBars.add(new HealthBar(wingShips.get(w).getX(),wingShips.get(w).getY(),wingShips.get(w).getMaxHealth(),wingShips.get(w).getCurrentHealth()));
  }

  /* Show health bars */
  for(int h = 0; h < healthBars.size(); h++) {
    healthBars.get(h).show();
  }
}

/* Helpers */
public boolean hasFuel() {
  return(myShip.getCurrentFuel()>0);
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
    strokeColor = color(255,127,80);
    fillColor = color(0,0,0);
    rotationSpeed = (int)(Math.random()*8-4);

    /* 4 cases for asteroids to spawn in */
    int startPos = (int)(Math.random()*4+1);
    switch (startPos) {
      case 1:
        myCenterX = (int)(Math.random()*MAP_WIDTH);
        myCenterY = 0;
        myDirectionX = (double)(Math.random()*6-3);
        myDirectionY = (double)(Math.random()*3+1);
        break;
      case 2:
        myCenterX = (int)(Math.random()*MAP_WIDTH);
        myCenterY = MAP_HEIGHT;
        myDirectionX = (double)(Math.random()*6-3);
        myDirectionY = (double)(-(Math.random()*3+1));
        break;
      case 3:
        myCenterX = 0;
        myCenterY = (int)(Math.random()*MAP_HEIGHT);
        myDirectionX = (double)(Math.random()*3+1);
        myDirectionY = (double)(Math.random()*6-1);
        break;
      case 4:
        myCenterX = MAP_WIDTH;
        myCenterY = (int)(Math.random()*MAP_HEIGHT);
        myDirectionX = (double)(-(Math.random()*6));
        myDirectionY = (double)(Math.random()*6-3);
        break;
    }
  }

  public Asteroid(int x, int y) {
    corners = 4;
    int[] xC = {10,-10,-10,10};
    int[] yC = {-10,-10,10,10};
    xCorners = xC;
    yCorners = yC;
    myPointDirection = 0;
    strokeColor = color(255,127,80);
    fillColor = color(0,0,0);
    rotationSpeed = (int)(Math.random()*8-4);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = (double)(Math.random()*6-3);
    myDirectionY = (double)(Math.random()*3);
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
  public int getRotationSpeed(){return rotationSpeed;}

  public void move() {
    super.move();
    rotate(rotationSpeed);
  }

}
public class Bullet extends Floater {
  private String type;
  public Bullet(SpaceShip ship, String t) {
    corners = 4;
    int[] xC = {2,2,-2,-2};
    int[] yC = {1,-1,-1,1};
    xCorners = xC;
    yCorners = yC;
    myCenterX = ship.getX();
    myCenterY = ship.getY();
    myPointDirection = ship.getPointDirection() + Math.random()*5-2.5f;
    double dRadians = myPointDirection * (Math.PI/180);
    myDirectionX = 20 * Math.cos(dRadians) + ship.getDirectionX();
    myDirectionY = 20 * Math.sin(dRadians) + ship.getDirectionY();
    switch (t) {
      case "mine":
        type = t;
        fillColor = color(0,191,255);
        strokeColor = color(0,191,255);
        break;
      case "friendly":
        type = t;
        fillColor = color(0,191,255);
        strokeColor = color(0,191,255);
        break;
      case "enemy":
        type = t;
        fillColor = color(255,0,0);
        strokeColor = color(255,0,0);
        break;
      case "enemy_boss":
        type = t;
        fillColor = color(0,255,0);
        strokeColor = color(0,255,0);
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
  public String getType(){return type;}

  public void show() {
    fill(fillColor);
    strokeWeight(3);
    stroke(strokeColor);
    ellipse((float)myCenterX, (float)myCenterY, 2, 2);
  }
}
public class Camera {
  public PVector pos;
  public Camera() {
    pos = new PVector(0, 0);
  }

  public void draw(MyShip ship) {
    pos.x += ship.getDirectionX();
    pos.y += ship.getDirectionY();
  }

  public void hyperspace(MyShip ship) {
    pos.x = ship.getX() - 425;
    pos.y = ship.getY() - 350;
  }
}
public class EnemyShip extends SpaceShip {

  private double maxHealth,currentHealth;
  private double ACCELERATION;
  private String type;

  public EnemyShip(String t) {
    corners = 11;
    int[] xC = {-14,-10,-12,2,4,14,4,2,-12,-10,-14};
    int[] yC = {-4,-4,-12,-12,-2,0,2,12,12,4,4};
    xCorners = xC;
    yCorners = yC;
    switch(t) {
      case "scout":
        type = t;
        fillColor = color(255,0,0);
        strokeColor = color(255,255,255);
        myCenterX = random(4350,4850);
        myCenterY = random(4350,4850);
        myDirectionX = 0;
        myDirectionY = 0;
        myPointDirection = 0;
        maxHealth = 5;
        currentHealth = 5;
        MAX_VELOCITY = random(2.0f, 4.0f);
        ACCELERATION = random(0.01f, 0.05f);
        break;
      case "adv":
        type = t;
        fillColor = color(150,0,0);
        strokeColor = color(255,255,255);
        myCenterX = random(4350,4850);
        myCenterY = random(4350,4850);
        myDirectionX = 0;
        myDirectionY = 0;
        myPointDirection = 0;
        maxHealth = 10;
        currentHealth = 10;
        MAX_VELOCITY = random(3.0f, 5.0f);
        ACCELERATION = random(0.03f, 0.07f);
        break;
      case "captain":
        type = t;
        fillColor = color(102,0,102);
        strokeColor = color(255,255,255);
        myCenterX = random(4350,4850);
        myCenterY = random(4350,4850);
        myDirectionX = 0;
        myDirectionY = 0;
        myPointDirection = 0;
        maxHealth = 10;
        currentHealth = 10;
        MAX_VELOCITY = random(3.0f, 5.0f);
        ACCELERATION = random(0.03f, 0.07f);
        break;
      case "boss":
        type = t;
        fillColor = color(75,0,130);
        strokeColor = color(255,255,255);
        myCenterX = random(4350,4850);
        myCenterY = random(4350,4850);
        myDirectionX = 0;
        myDirectionY = 0;
        myPointDirection = 0;
        maxHealth = 50;
        currentHealth = 50;
        MAX_VELOCITY = 2.0f;
        ACCELERATION = 0.25f;
        break;
    }
  }
  
  public double getMaxHealth() {return maxHealth;}
  public double getCurrentHealth(){return currentHealth;}
  public void setCurrentHealth(double ch){currentHealth += ch;}

  public void move() {

    /* Point direction */
    double deltaX, deltaY, angle;
    deltaX = myShip.getX() - myCenterX;
    deltaY = myShip.getY() - myCenterY;

    angle = atan((float)(deltaY/deltaX)) * (180/Math.PI);

    if(myShip.getX() < myCenterX) {
      angle += 180;
    }

    myPointDirection = angle;

    /* Accelerate in point direction */
    accelerate(ACCELERATION);

    /* Limit velocity */
    if(myDirectionX > MAX_VELOCITY) {
      myDirectionX = MAX_VELOCITY;
    }
    if(myDirectionX < -(MAX_VELOCITY)) {
      myDirectionX = -(MAX_VELOCITY);
    }
    if(myDirectionY > MAX_VELOCITY) {
      myDirectionY = MAX_VELOCITY;
    }
    if(myDirectionY < -(MAX_VELOCITY)) {
      myDirectionY = -(MAX_VELOCITY);
    }

    /* Actually move it */
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
    double dRadians = myPointDirection * (Math.PI/180);
    //change coordinates of direction of travel
    myDirectionX += ((dAmount) * Math.cos(dRadians));
    myDirectionY += ((dAmount) * Math.sin(dRadians));
  }

  public void rotate (int nDegreesOfRotation) {
    //rotates the floater by a given number of degrees
    myPointDirection += nDegreesOfRotation;
  }
  public void move() { //move the floater in the current direction of travel
    //change the x and y coordinates by myDirectionX and myDirectionY
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;
  }
  public void show()  //Draws the floater at the current position
  {
    strokeWeight(1);
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
public class GaurdShip extends SpaceShip {
}
public class HealthBar {
  private double x,y,maxWidth,myHeight,currentWidth,scaleFactor;
  private int fillColor,strokeColor;

  public HealthBar(double x, double y, double maxHealth, double currentHealth) {
    this.x = x - 25;
    this.y = y - 25;
    this.maxWidth = 50;
    this.scaleFactor = maxWidth / maxHealth;
    this.currentWidth = currentHealth * scaleFactor;
    this.fillColor = color(0,255,0); /* green */
    this.myHeight = 7;
  }

  public void show() {
    noStroke();
    fill(fillColor);
    rect((float)this.x, (float)this.y, (float)this.currentWidth, (float)this.myHeight);

    stroke(255);
    fill(0,0,0,0);
    rect((float)this.x, (float)this.y, (float)this.maxWidth, (float)this.myHeight);
  }
}
public class MiniMap {
  public MiniMap() {}
  public void render() {
    /* Map Background */
    stroke(255);
    fill(0);
    rect(myShip.getX()+450,myShip.getY()-325,200,200);

    /* Your spaceship on the map */
    stroke(255,255,0);
    fill(255,255,0);
    ellipse(myShip.getX()+450+myShip.getX()/(MAP_WIDTH/200),myShip.getY()-325+myShip.getY()/(MAP_HEIGHT/200),5,5);

    /* Enemyships on the map */
    for(int e = enemyShips.size()-1; e >= 0; e--) {
      stroke(255,0,0);
      fill(255,0,0);
      ellipse(myShip.getX()+450+enemyShips.get(e).getX()/(MAP_WIDTH/200),myShip.getY()-325+enemyShips.get(e).getY()/(MAP_HEIGHT/200),5,5);
    }

    for(int w = wingShips.size()-1; w >= 0; w--) {
      stroke(0,191,255);
      fill(0,191,255);
      ellipse(myShip.getX()+450+wingShips.get(w).getX()/(MAP_WIDTH/200),myShip.getY()-325+wingShips.get(w).getY()/(MAP_HEIGHT/200),5,5);
    }

    /* Asteroids on the map */
    stroke(255,127,80);
    fill(255,127,80);
    for(int a = asteroids.size()-1; a >= 0; a--) {
      ellipse(myShip.getX()+450+asteroids.get(a).getX()/(MAP_WIDTH/200),
              myShip.getY()-325+asteroids.get(a).getY()/(MAP_HEIGHT/200),
              1,1);
    }
  }
}
/*
public class Missions {
  private int currentLevel;
  private String missionDescription;

  private HashMap<Integer,String> lv1missions;
  private HashMap<Integer,String> lv2missions;
  private HashMap<Integer,String> lv3missions;
  private HashMap<Integer,String> lv4missions;
  private HashMap<Integer,String> lv5missions;

  public Missions() {
    lv1missions = new HashMap<Integer,String>();
    lv2missions = new HashMap<Integer,String>();
    lv3missions = new HashMap<Integer,String>();
    lv4missions = new HashMap<Integer,String>();
    lv5missions = new HashMap<Integer,String>();

    lv1missions.put(10, "Destroy 2 enemy ships."); // 2 scout enemies

    lv2missions.put(20, "Destroy 5 enemy ships."); // 5 scout enemies
    lv2missions.put(21, "Remove 5 asteroids.\nDestroy 3 enemy ships."); // 3 scouts
    lv2missions.put(22, "Destroy enemy construction."); // gaurded by 2 ships.

    lv3missions.put(30, "Destroy 10 enemy ships."); // 9 scouts, 1 adv
    lv3missions.put(31, "Destroy enemy outpost."); // gaurded by 5 scouts, 2 adv
    lv3missions.put(32, "Steal enemy supplies."); // gaurded by 3 adv

    lv4missions.put(41, "Destroy 15 enemy ships."); // 10 scouts, 5 adv
    lv4missions.put(42, "Destroy enemy weaponry."); // weapon, 5 adv
    lv4missions.put(43, "Resolve skirmish."); // 5 friendlies vs 10 adv

    lv5missions.put(50, "Destroy the enemy spacestation."); // 20 scouts, 10 adv, 1 captain

    currentLevel = 1;
  }

  public void getCurrentMissionText() {

  }

  public void getCurrentMissionId() {

  }

  public void nextMission() {

  }
}
*/
public class MyShip extends SpaceShip {

  private double maxHealth,currentHealth,currentFuel,maxFuel,currentHeat,maxHeat;

  public MyShip() {
    corners = 11;
    int[] xC = {-14,-10,-12,2,4,14,4,2,-12,-10,-14};
    int[] yC = {-4,-4,-12,-12,-2,0,2,12,12,4,4};
    xCorners = xC;
    yCorners = yC;
    fillColor = color(77,77,255);
    strokeColor = color(255,255,255);
    myCenterX = 425;
    myCenterY = 350;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 0;
    maxHealth = 10;
    currentHealth = 10;
    maxFuel = 100;
    currentFuel = 100;
    maxHeat = 50;
    currentHeat = 0;
    MAX_VELOCITY = 5;
  }
  public double getMaxHealth(){return maxHealth;}
  public double getCurrentHealth(){return currentHealth;}
  public void setMaxHealth(double health){maxHealth = health;}
  public void setCurrentHealth(double health){
    currentHealth += health;
    if(currentHealth > maxHealth) {
      currentHealth = maxHealth;
    }
  }
  public double getMaxFuel(){return maxFuel;}
  public double getCurrentFuel(){return currentFuel;}
  public void setMaxFuel(double mf){maxFuel = mf;}
  public void setCurrentFuel(double cf){
    currentFuel += cf;
    if(currentFuel > maxFuel) {
      currentFuel = maxFuel;
    }
  }
  public double getMaxHeat(){return maxHeat;}
  public double getCurrentHeat(){return currentHeat;}
  public void setMaxHeat(double mh){maxHeat = mh;}
  public void setCurrentHeat(double ch){
    currentHeat += ch;
    if(currentHeat < 0) {
      currentHeat = 0;
    }
  }
  public void hyperspace() {
    if(currentFuel > 10) {
      myCenterX = (int)(Math.random()*MAP_WIDTH);
      myCenterY = (int)(Math.random()*MAP_HEIGHT);
      myDirectionX = 0;
      myDirectionY = 0;
      myPointDirection = (int)(Math.random()*360);
      currentFuel -= 10;
    }
  }
  public void dissapear() {
    corners=0;
    int[] xC = {};
    int[] yC = {};
    xCorners = xC;
    yCorners = yC;
    show();
  }
}
public class OffenseShip extends SpaceShip {
  // whoever is reading this, you are free to fork this project and finish it.
}
public abstract class SpaceShip extends Floater {

  protected double MAX_VELOCITY;
  protected final static double SHIP_RECOIL = -0.001f;

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
    if(myDirectionX > MAX_VELOCITY) {
      myDirectionX = MAX_VELOCITY;
    }
    if(myDirectionX < -(MAX_VELOCITY)) {
      myDirectionX = -(MAX_VELOCITY);
    }
    if(myDirectionY > MAX_VELOCITY) {
      myDirectionY = MAX_VELOCITY;
    }
    if(myDirectionY < -(MAX_VELOCITY)) {
      myDirectionY = -(MAX_VELOCITY);
    }
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;
  }

  public void recoil() {
    accelerate(SHIP_RECOIL);
  }
}
public class Spacestation {
  public float x,y,radius;
  private float diameter;
  private double currentHealth, maxHealth;
  private String type;
  private int fillColor, strokeColor;

  public Spacestation(String t) {
    this.currentHealth = 10;
    this.maxHealth = 10;
    this.type = t;
    this.diameter = 500;
    this.radius = this.diameter/2;

    if(type == "friendly") {
      this.x = 400;
      this.y = 400;
      this.strokeColor = color(0,0,255);
    } else if (type == "enemy") {
      this.x = 4600;
      this.y = 4600;
      this.strokeColor = color(255,0,0);
    }
  }

  public void show() {
    fill(0,0,0,0);
    stroke(this.strokeColor);
    strokeWeight(20);
    ellipse(this.x, this.y, this.diameter, this.diameter);
  }

  public double getCurrentHealth() {
    return this.currentHealth;
  }

  public void setCurrentHealth(double ch) {
    this.currentHealth += ch;
  }

  public double getMaxHealth() {
    return this.maxHealth;
  }

  public void setMaxHealth(double mh) {
    maxHealth += mh;
  }
}
public class Star {
  double x,y;
  Star() {
    x = (double)(Math.random()*MAP_WIDTH);
    y = (double)(Math.random()*MAP_HEIGHT);
  }
  public void show() {
    fill(255);
    stroke(255);
    ellipse((float)x,(float)y,1,1);
  }
}
public class WingShip extends SpaceShip {
  private double currentHealth,maxHealth,ACCELERATION,deltaX,deltaY,angle;
  private boolean inRange;
  private ArrayList<EnemyShip> temp = new ArrayList<EnemyShip>();

  public WingShip() {
    corners = 11;
    int[] xC = {-14,-10,-12,2,4,14,4,2,-12,-10,-14};
    int[] yC = {-4,-4,-12,-12,-2,0,2,12,12,4,4};
    xCorners = xC;
    yCorners = yC;
    fillColor = color(0,191,255);
    strokeColor = color(255,255,255);
    myCenterX = random(150,650);
    myCenterY = random(150,650);
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 0;
    this.currentHealth = 5;
    this.maxHealth = 5;
    ACCELERATION = random(0.05f,0.3f);
    MAX_VELOCITY = random(2.0f,4.0f);
    inRange = false;
  }
  public double getMaxHealth(){return maxHealth;}
  public double getCurrentHealth(){return currentHealth;}
  public void setMaxHealth(double health){maxHealth = health;}
  public void setCurrentHealth(double health){
    currentHealth += health;
    if(currentHealth > maxHealth) {
      currentHealth = maxHealth;
    }
  }

  public void move() {

    /* Copies enemyships arraylist to temp arraylist */
    temp.clear();
    for(int e = 0; e < enemyShips.size(); e++) {
      temp.add(enemyShips.get(e));
    }

    if (temp.size() > 0) {
      while(temp.size() > 1) { /* While loop that removes farthest ship */
        if (dist((float)this.myCenterX,(float)this.myCenterY,temp.get(0).getX(),temp.get(0).getY()) > dist((float)this.myCenterX,(float)this.myCenterY,temp.get(1).getX(),temp.get(1).getY())) {
          temp.remove(0);
        } else {
          temp.remove(1);
        }
      } /* In the end, we have an arraylist with size one with the ship closest */

      deltaX = temp.get(0).getX() - myCenterX;
      deltaY = temp.get(0).getY() - myCenterY;

      angle = atan((float)(deltaY/deltaX)) * (180/Math.PI);

      if(temp.get(0).getX() < myCenterX) {
        angle += 180;
      }

      myPointDirection = angle;
      inRange = dist((float)myCenterX,(float)myCenterY,temp.get(0).getX(),temp.get(0).getY()) <= 1000;

    } else { /* Go towards your ship */

      deltaX = myShip.getX() - myCenterX;
      deltaY = myShip.getY() - myCenterY;

      angle = atan((float)(deltaY/deltaX)) * (180/Math.PI);

      if(myShip.getX() < myCenterX) {
        angle += 180;
      }

      myPointDirection = angle;
      inRange = false;
    }

    /* Accelerate in point direction */
    accelerate(ACCELERATION);

    /* Limit velocity */
    if(myDirectionX > MAX_VELOCITY) {
      myDirectionX = MAX_VELOCITY;
    }
    if(myDirectionX < -(MAX_VELOCITY)) {
      myDirectionX = -(MAX_VELOCITY);
    }
    if(myDirectionY > MAX_VELOCITY) {
      myDirectionY = MAX_VELOCITY;
    }
    if(myDirectionY < -(MAX_VELOCITY)) {
      myDirectionY = -(MAX_VELOCITY);
    }

    /* Actually move it */
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;
  }

  public boolean isInRange() {
    return inRange;
  }
}
  public void settings() {  size(displayWidth,displayHeight,P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AsteroidsGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
