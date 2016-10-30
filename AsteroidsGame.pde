// TODO: get enter/return key working on browser

/* Connect processing with browser js */
public interface JavaScript {
  void playSound(String s);
}
public void bindJavascript(JavaScript js) {
  javascript = js;
}
public JavaScript javascript;

/* Constant variables */
public final int NUM_STARS = 2000;
public final double MY_SHIP_ACCELERATION = 0.1;
public final double ASTEROID_SPAWN_CHANCE = 10;
public final int MAX_ASTEROIDS = 50;
public final int MAP_WIDTH = 5000;
public final int MAP_HEIGHT = 5000;
public final int OUT_OF_BOUNDS_COLOR = color(50,0,0);
public final int displayWidth = 1100;
public final int displayHeight = 700;

/* Game variables */
public int gameState = 0; // Prod: 0, Dev: 1
public int score;
public int asteroidsDestroyed;
public int bulletsShot;
public int enemiesDestroyed;
public boolean titleMusicPlaying = false;
public boolean bgMusicPlaying = false;

/* Object variables */
public MyShip myShip;
public ArrayList<SpaceShip> allyShips = new ArrayList<SpaceShip>();
public ArrayList<SpaceShip> enemyShips = new ArrayList<SpaceShip>();
public ArrayList<Star> stars = new ArrayList<Star>();
public ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
public ArrayList<Bullet> bullets = new ArrayList<Bullet>();
public Camera camera;
public MiniMap minimap;

/* Your ship variables */

/* Other variables */
public HashMap<String,Boolean> keys = new HashMap<String,Boolean>();

public void setup() {
  /* Set screen size, framerate */
  //fullScreen(P2D);
  size(displayWidth,displayHeight,P2D);
  frameRate(60);

  /* Initialize hashmap keys */
  keys.put("w", false);
  keys.put("s", false);
  keys.put("a", false);
  keys.put("d", false);
  keys.put("q", false);
  keys.put(" ", false);
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
  }
  // Put this bottom code somewhere else and make it work
  if(myShip.getCurrentHealth() <= 0) {
    gameState = 3;
  }
}

public void titleScreen() {
  /* Initialize objects */
  myShip = new MyShip();
  camera = new Camera();
  bullets.clear();
  score = 0;
  asteroidsDestroyed = 0;
  bulletsShot = 0;
  enemiesDestroyed = 0;
  for(int i = 0; i < NUM_STARS; i++) {
    if(stars.size() <= NUM_STARS) {
      stars.add(new Star());
    }
  }
  minimap = new MiniMap();
  for(int i = 0; i < MAX_ASTEROIDS; i++) {
    if(asteroids.size() <= MAX_ASTEROIDS) {
      int x = (int)(Math.random()*MAP_WIDTH);
      int y = (int)(Math.random()*MAP_HEIGHT);
      asteroids.add(new Asteroid(x,y));
    }
  }

  background(0);
  textSize(16);
  textAlign(CENTER);
  fill(255);
  textSize(32);
  text("Asteroids and more", width/2,height/2-40);
  text("Press p to start", width/2, height/2);

  /* Background music */
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

  /* Background music */
  if(bgMusicPlaying == false && javascript != null) {
    javascript.playSound("bg");
    bgMusicPlaying = true;
    titleMusicPlaying = false;
  }

  /* Resets draw screen */
  background(OUT_OF_BOUNDS_COLOR);

  /* Checks which keys are held down and updates accordingly */
  checkKeyValues();
  updateCollisions();

  /* Show everything */
  showSpace();
  showAsteroids();
  showBullets();
  showShip();
  showGUI();
}
public void pauseScreen() {
}
public void gameOverScreen() {
  /* Explode!!! */
  myShip.dissapear();
  // Explosion animation

  /* Game over prompt */
  stroke(255,0,0);
  fill(255,255,255);
  textAlign(CENTER);
  textSize(24);
  text("YOU DIED",width/2, height/2);
  text("Press p to play again",width/2, height/2+20);
}

public void creditsScreen() {
}

/* Switch case when key is pressed that assigns TRUE to a hashmap key */
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
    case 'p':
      if(gameState == 3) {
        gameState = 0;
      } else if (gameState == 0) {
        gameState = 1;
      }
      break;
  }
}

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
  stroke(0);
  rect(0,0,MAP_WIDTH,MAP_HEIGHT);
  for(int i = 0; i < stars.size(); i++) {
    stars.get(i).show();
  }
}

/* Runs through hashmap and moves ship accordingly */
public void checkKeyValues() {
  if (keys.get("w") == true && hasFuel()) {
    myShip.accelerate(MY_SHIP_ACCELERATION);
    myShip.setCurrentFuel(myShip.getCurrentFuel()-0.02);
  }
  if (keys.get("s") == true && hasFuel()) {
    myShip.accelerate(-(MY_SHIP_ACCELERATION));
    myShip.setCurrentFuel(myShip.getCurrentFuel()-0.02);
  }
  if (keys.get("a") == true) {
    myShip.rotate(-3);
  }
  if (keys.get("d") == true) {
    myShip.rotate(3);
  }
  if (keys.get(" ") == true) {
      bullets.add(new Bullet(myShip));
      myShip.setCurrentHeat(myShip.getCurrentHeat()+0.5);
      bulletsShot++;
      myShip.recoil();
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
    } else if (dist(asteroids.get(a).getX(), asteroids.get(a).getY(),myShip.getX(), myShip.getY()) < 20) {
      /* If asteroid hits your ship, GAME OVER */
      asteroids.remove(a);
      myShip.setCurrentHealth(0);
      myShip.setCurrentFuel(0);
      myShip.setCurrentHeat(0);
      gameState = 3;
    }
  }
  /* Loops through each bullet */
  for(int b = bullets.size()-2; b >= 0; b--) {
    /* Remove bullet if it's out of the screen or if it hits an asteroid */
    if(bullets.get(b).getX() > MAP_WIDTH || bullets.get(b).getX() < 0 || bullets.get(b).getY() > MAP_HEIGHT || bullets.get(b).getY() < 0) {
      bullets.remove(b);
    } else {
      for (int a = asteroids.size()-2; a >= 0; a--) {
        if (dist(asteroids.get(a).getX(), asteroids.get(a).getY(),bullets.get(b).getX(), bullets.get(b).getY()) < 20) {
          bullets.remove(b);
          asteroids.remove(a);
          asteroidsDestroyed++;
          score++;
        }
      }
    }
  }
  /* Reduce health if out of bounds */
  if(myShip.getX() < 0 || myShip.getX() > MAP_WIDTH || myShip.getY() < 0 || myShip.getY() > MAP_HEIGHT) {
    myShip.setCurrentHealth(myShip.getCurrentHealth()-0.05);
    if(myShip.getCurrentHealth()<=0){myShip.setCurrentFuel(0);myShip.setCurrentHeat(0);}
  }
  /* Cool down ship */
  myShip.setCurrentHeat(myShip.getCurrentHeat()-0.1);
  /* Over heat ends life */
  if(myShip.getCurrentHeat() >= myShip.getMaxHeat()) {
    bullets.clear();
    myShip.setCurrentHealth(0);
    myShip.setCurrentFuel(0);
  }
}

/* Shows HOV graphical user interface - very cool */
public void showGUI() {

  minimap.render();
  textSize(15);

  /* Draw gray sidebar */
  stroke(255);
  fill(100,100);
  rect(myShip.getX()+425,myShip.getY()-400,275,1050);

  /* Health text */
  fill(255);
  textAlign(LEFT);
  text("Health",myShip.getX()+450,myShip.getY()-90);

  /* Health bar */
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
  /* Current objective */
  /* Pause */
  fill(255);
  textAlign(LEFT);
  text("ESC to pause",myShip.getX()+450,myShip.getY()+325);
}

public boolean hasFuel() {
  return(myShip.getCurrentFuel()>0);
}
