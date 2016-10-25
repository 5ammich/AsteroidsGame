/* Constant variables */
public final int NUM_STARS = 2000;
public final int MAX_VELOCITY = 5;
public final double SHIP_ACCELERATION = 0.1; // Add ship limits to ship class
public final double SHIP_RECOIL = -0.001;
public final double ASTEROID_SPAWN_CHANCE = 10;
public final int MAX_ASTEROIDS = 50;
public final int MAP_WIDTH = 5000;
public final int MAP_HEIGHT = 5000;
public final int OUT_OF_BOUNDS_COLOR = color(50,0,0);
public final int displayWidth = 1100;
public final int displayHeight = 700;

/* Game variables */
public int gameState = 0; // Prod: 0, Dev: 1
public int score = 0;
public int asteroidsDestroyed = 0;
public int bulletsShot = 0;
public int enemiesDestroyed = 0;

/* Object variables */
public SpaceShip myShip;
public ArrayList<SpaceShip> allyShips = new ArrayList<SpaceShip>();
public ArrayList<SpaceShip> enemyShips = new ArrayList<SpaceShip>();
public ArrayList<Star> stars = new ArrayList<Star>();
public ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
public ArrayList<Bullet> bullets = new ArrayList<Bullet>();
public Camera camera;
public MiniMap minimap;

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
  }
  // Put this bottom code somewhere else and make it work
  if(myShip.getCurrentHealth() <= 0) {
    gameState = 3;
  }
}

public void titleScreen() {

  /* Initialize objects */
  myShip = new SpaceShip();
  camera = new Camera();
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
  text("Asteroids and some more", width/2,height/2);
  text("Press any key to start", width/2, height/2+20);
  if(keyPressed || mousePressed) {
    gameState = 1;
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
  // Dissapear ship
  // Explosion animation
  fill(255,0,0);
  textAlign(CENTER);
  text("YOU DIED",width/2, height/2);
  text("Press any key to try again",width/2, height/2+20);
  if(keyPressed || mousePressed) {
    myShip.setCurrentHealth(myShip.getMaxHealth()); // Shouldn't be neccessary after changing some stuff
    gameState = 0; // When pressed, it only goes to gamestate 0 for a short time then goes to gamestate 1
  }
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
      /* HYPERSPACE!!! aka teleport somewhere and stop */
      myShip.setX((int)(Math.random()*MAP_WIDTH));
      myShip.setY((int)(Math.random()*MAP_HEIGHT));
      myShip.setDirectionX(0);
      myShip.setDirectionY(0);
      myShip.setPointDirection((int)(Math.random()*360));
      camera.hyperspeed(myShip);
      break;
    case ' ':
      keys.put(" ", true);
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
      bullets.add(new Bullet(myShip));
      myShip.accelerate(SHIP_RECOIL);
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
  myShip.move();
  myShip.show();
}

public void updateCollisions() {
  /* Loops through each asteroid */
  for(int a = asteroids.size()-1; a >= 0; a--) {
    /* Remove asteroid if it's out of the screen or if it hits a ship */
    if(asteroids.get(a).getX() > MAP_WIDTH || asteroids.get(a).getX() < 0 || asteroids.get(a).getY() > MAP_HEIGHT || asteroids.get(a).getY() < 0 || asteroids.get(a).getRotationSpeed() == 0) {
      asteroids.remove(a);
    } else if (dist(asteroids.get(a).getX(), asteroids.get(a).getY(),myShip.getX(), myShip.getY()) < 20) {
      /* If asteroid hits your ship, GAME OVER */
      asteroids.remove(a);
      myShip.setCurrentHealth(0);
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
        }
      }
    }
  }
  /* Reduce health if out of bounds */
  if(myShip.getX() < 0 || myShip.getX() > MAP_WIDTH || myShip.getY() < 0 || myShip.getY() > MAP_HEIGHT) {
    myShip.setCurrentHealth(myShip.getCurrentHealth()-0.05);
  }
}

/* Shows HOV graphical user interface - very cool */
public void showGUI() {

  minimap.render();

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

  /* Fuel bar */
  /* Heat bar */
  /* Points */
  /* Help */
  /* Pause */
}
