// TODO
// Explosion animation
// E to go warp speed
// spacestation health and heal, upgrade stuff, etc.
// Garud, wing, offense ships

/* Connect processing with browser js */
public interface JavaScript {
  void playSound(String s);
  void keyDown(String k);
  void keyUp(String k);
}
public void bindJavascript(JavaScript js) {
  javascript = js;
}
public JavaScript javascript;

/* Constant variables */
public final int NUM_STARS = 2000;
public final double MY_SHIP_ACCELERATION = 0.1;
public final double ASTEROID_SPAWN_CHANCE = 10;
public final int MAX_ASTEROIDS = 20;
public final int INITIAL_ENEMIES = 50;
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
public boolean titleMusicPlaying = false;
public boolean bgMusicPlaying = false;

/* Object variables */
public MyShip myShip;
public ArrayList<WingShip> wingShips = new ArrayList<WingShip>();
public ArrayList<EnemyShip> enemyShips = new ArrayList<EnemyShip>();
public ArrayList<Star> stars = new ArrayList<Star>();
public ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
public ArrayList<Bullet> bullets = new ArrayList<Bullet>();
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
  size(displayWidth,displayHeight,P2D);
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
  updateCollisions();

  /* Show everything in this order*/
  showSpace();
  showAsteroids();
  friendlySpacestation.show();
  enemySpacestation.show();
  showBullets();
  showEnemyShips();
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
    myShip.setCurrentFuel(-0.02);
  }
  if (keys.get("s") == true && hasFuel()) {
    myShip.accelerate(-(MY_SHIP_ACCELERATION));
    myShip.setCurrentFuel(-0.02);
  }
  if (keys.get("a") == true) {
    myShip.rotate(-3);
  }
  if (keys.get("d") == true) {
    myShip.rotate(3);
  }
  if (keys.get(" ") == true) {
      bullets.add(new Bullet(myShip,"mine"));
      myShip.setCurrentHeat(0.2);
      bulletsShot++;
      myShip.recoil();
  }
}

public void showEnemyShips() {
  for(int e = enemyShips.size()-1; e >= 0; e--) {
    enemyShips.get(e).move();
    enemyShips.get(e).show();
    if (dist(enemyShips.get(e).getX(), enemyShips.get(e).getY(), myShip.getX(), myShip.getY()) <= 1000 && (int)(Math.random()*10) == 0) {
      /* Randomly shoots */
      bullets.add(new Bullet(enemyShips.get(e), "enemy"));
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
      myShip.setCurrentHealth(-0.5);
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
    } else {
      for(int b = bullets.size() - 1; b >= 0; b--) {
        if(dist(bullets.get(b).getX(), bullets.get(b).getY(), enemyShips.get(e).getX(), enemyShips.get(e).getY()) <= 20 && (bullets.get(b).getType() == "friendly" || bullets.get(b).getType() == "mine")) {
          bullets.remove(b);
          enemyShips.get(e).setCurrentHealth(-0.5);
        }
      }
    }
  }

  /* Reduce health if out of bounds */
  if(myShip.getX() < 0 || myShip.getX() > MAP_WIDTH || myShip.getY() < 0 || myShip.getY() > MAP_HEIGHT) {
    myShip.setCurrentHealth(-0.1);
    if(myShip.getCurrentHealth()<=0){myShip.setCurrentFuel(-myShip.getCurrentFuel());myShip.setCurrentHeat(-myShip.getCurrentHeat());}
  }

  /* Cool down ship */
  myShip.setCurrentHeat(-0.1);

  /* Over heat ends life */
  if(myShip.getCurrentHeat() >= myShip.getMaxHeat()) {
    bullets.clear();
    myShip.setCurrentHealth(-myShip.getCurrentHealth());
    myShip.setCurrentFuel(-myShip.getCurrentFuel());
  }

  /* Spacestation heals spaceship*/
  if(dist(myShip.getX(), myShip.getY(), friendlySpacestation.x, friendlySpacestation.y) <= friendlySpacestation.radius) {
    myShip.setCurrentHealth(0.1);
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
  text("Max health: " + myShip.getMaxHealth(),myShip.getX()+450,myShip.getY()+80);
  text("Armor: ",myShip.getX()+450,myShip.getY()+100);
  text("Laser power: ",myShip.getX()+450,myShip.getY()+120);
  text("Max fuel: " + myShip.getMaxFuel(),myShip.getX()+450,myShip.getY()+140);
  text("Fuel efficency: ",myShip.getX()+450,myShip.getY()+160);
  text("Max heat: " + myShip.getMaxHeat(),myShip.getX()+450,myShip.getY()+180);
  text("Offensive allies: 0",myShip.getX()+450,myShip.getY()+200);
  text("Wing allies: " + wingShips.size(),myShip.getX()+450,myShip.getY()+220);
  text("Gaurd allies: 0",myShip.getX()+450,myShip.getY()+240);
  text("Spacestation Health: " + friendlySpacestation.getMaxHealth(),myShip.getX()+450,myShip.getY()+260);

  /* Pause */
  text("ESC to pause",myShip.getX()+450,myShip.getY()+325);
}

/* Helpers */
public boolean hasFuel() {
  return(myShip.getCurrentFuel()>0);
}
