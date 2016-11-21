// Explosion animation
// spacestation health and heal, upgrade stuff, etc.
// E to go warp speed
// Index out of range problems

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
public final int INITIAL_ENEMIES = 2;
public final int INITIAL_WINGSHIPS = 2;
public final int MAP_WIDTH = 5000;
public final int MAP_HEIGHT = 5000;
public final int OUT_OF_BOUNDS_COLOR = color(50,0,0);
public final int NUM_PARTICLES = 10;
public final int displayWidth = 1100;
public final int displayHeight = 700;
public PImage spaceship;
//public final int BOX_KEY_SIZE = 75;

/* Game variables */
public int gameState = 0;
public int score;
public int asteroidsDestroyed;
public int bulletsShot;
public int enemiesDestroyed;
public int scrap = 0;
public boolean titleMusicPlaying = false;
public boolean bgMusicPlaying = false;
public boolean pauseDrawn = false;

/* Object variables */
public MyShip myShip;
public ArrayList<WingShip> wingShips = new ArrayList<WingShip>();
public ArrayList<EnemyShip> enemyShips = new ArrayList<EnemyShip>();
public ArrayList<Star> stars = new ArrayList<Star>();
public ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
public ArrayList<Bullet> bullets = new ArrayList<Bullet>();
public ArrayList<HealthBar> healthBars = new ArrayList<HealthBar>();
public ArrayList<Particle> particles = new ArrayList<Particle>();
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
  particles.clear();
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
  pauseDrawn = false;
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
  showParticles();
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

  if (!pauseDrawn) {

    /* Pause screen graphics setup */
    fill(0,0,0,100);
    stroke(0);
    rect(0,0,displayWidth,displayHeight);
    fill(255);

    /* Pause title */
    textSize(24);
    text("Paused (ESC to unpause).",50,50);
    textSize(20);
    text("Scrap: " + scrap, 50, 75);

    /* Ship upgrades */
    // text("Ship stats", 50, 125);
    // text("Max HP: ");
    // text("Armor: ");
    // text("Energy Lasers Mark I");
    // text("Max Fuel: ");
    // text("Fuel Efficiency");
    // text("Max Heat: ");
    // text("Cooling efficiency: ");
    //
    // /* Ally ship upgrades */
    // if(dist(myShip.getX(),myShip.getY(),friendlySpacestation.x,friendlySpacestation.y < friendlySpacestation.radius)) {
    //   text("Build ally ship: ");
    //   text("Ally Max HP: ");
    // }
    //
    // /* Spacestation upgrades */
    // text("Spacestation health");
    // text("Matter Converter Mark 1");
    //
    // // Instruction text
    // textSize(15);
    // text("CONTROLS:",880,40);
    // text("W - accelerate",880,40);
    // text("A - rotate left",880,60);
    // text("S - decellerate",880,80);
    // text("D - rotate right",880,100);
    // text("SPACE - fire bullets",880,120);
    // text("Q - hyperspace",880,140);
    // text("E - warp speed",880,160);
    // text("ESC - Pause / Upgrade station",880,180);

    pauseDrawn = true;
  }
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
    case 'q':
      if(hasFuel()) {
        myShip.hyperspace();
        camera.hyperspace(myShip);
      } break;
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

  /* ASTEROIDS */
  for(int a = asteroids.size()-2; a >= 0; a--) {

    /* Out of bounds */
    if(asteroids.get(a).getX() > MAP_WIDTH || asteroids.get(a).getX() < 0 || asteroids.get(a).getY() > MAP_HEIGHT || asteroids.get(a).getY() < 0 || asteroids.get(a).getRotationSpeed() == 0) {
      asteroids.remove(a);
      // asteroids explosion
      break;

    /* Hits ship */
    } else if (dist(asteroids.get(a).getX(), asteroids.get(a).getY(),myShip.getX(), myShip.getY()) <= 20) {
      asteroids.remove(a);
      myShip.setCurrentHealth(-myShip.getCurrentHealth());
      myShip.setCurrentFuel(-myShip.getCurrentFuel());
      myShip.setCurrentHeat(-myShip.getCurrentHeat());
      gameState = 3;
      break;

    /* Hits bullet */
    } else {
      for(int b = bullets.size()-2; b >= 0; b--) {
        if(dist(asteroids.get(a).getX(),asteroids.get(a).getY(),bullets.get(b).getX(),bullets.get(b).getY()) <= 20) {
          bullets.remove(b);
          // for(int i = 0; i < NUM_PARTICLES; i++) {
          //   particles.add(new Particle(asteroids.get(a).getX(),asteroids.get(a).getY(),color(255,127,80)));
          // }
          asteroids.remove(a);
        }
      }
    }
  }

  /* BULLETS */
  for(int b = bullets.size()-2; b >= 0; b--) {

    /* Out of bounds or lost energy */
    if(bullets.get(b).getX() > MAP_WIDTH || bullets.get(b).getX() < 0 || bullets.get(b).getY() > MAP_HEIGHT || bullets.get(b).getY() < 0 || dist(bullets.get(b).getInitX(),bullets.get(b).getInitY(),bullets.get(b).getX(),bullets.get(b).getY()) >= 700) {
      bullets.remove(b);

    /* Hits your ship */
    } else if(dist(bullets.get(b).getX(), bullets.get(b).getY(), myShip.getX(), myShip.getY()) <= 20 && bullets.get(b).getType() == "enemy") {
      bullets.remove(b);
      myShip.setCurrentHealth(-0.5);

    /* Hits enemy ship */
    } else {
      for(int e = enemyShips.size()-2; e >= 0; e--) {
        if(dist(bullets.get(b).getX(), bullets.get(b).getY(), enemyShips.get(e).getX(), enemyShips.get(e).getY()) <= 20 && (bullets.get(b).getType() == "mine" || bullets.get(b).getType() == "friendly")) {
          bullets.remove(b);
          enemyShips.get(e).setCurrentHealth(-0.5);
        }
      }
    }
  }

  /* ENEMY SHIPS */
  for(int e = enemyShips.size() - 1; e >= 0; e--) {

    /* Remove if dead */
    if (enemyShips.get(e).getCurrentHealth() <= 0) {
      enemyShips.remove(e);
      score += 5;
      if(javascript != null) javascript.playSound("explode");
    }
  }

  /* WING SHIPS */
  for(int w = wingShips.size()-1; w >= 0; w--) {

    /* Remove if dead */
    if(wingShips.get(w).getCurrentHealth() <= 0) {
      wingShips.remove(w);

    /* Hits bullet */
    } else {
      for(int b = bullets.size()-1; b >= 0; b--) {
        if(dist(wingShips.get(w).getX(),wingShips.get(w).getY(),bullets.get(b).getX(),bullets.get(b).getY()) <= 20 && bullets.get(b).getType() == "enemy") {
          bullets.remove(b);
          wingShips.get(w).setCurrentHealth(-0.5);
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
  if(keys.get(" ") == false) {
    myShip.setCurrentHeat(-0.1);
  }

  /* Over heat ends life */
  if(myShip.getCurrentHeat() >= myShip.getMaxHeat()) {
    myShip.setCurrentHealth(-myShip.getCurrentHealth());
    myShip.setCurrentFuel(-myShip.getCurrentFuel());
    gameState = 3;
  }

  /* Spacestation heals spaceship*/
  if(dist(myShip.getX(), myShip.getY(), friendlySpacestation.x, friendlySpacestation.y) <= friendlySpacestation.radius && myShip.getCurrentHealth() >= 0) {
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

   /* Speed text */
   fill(255);
   textAlign(LEFT);
   text("Speed",myShip.getX()+450,myShip.getY()+30);

   /* Speed bar */
   strokeWeight(1);
   stroke(255);
   fill(0,0,255);
   rect(myShip.getX()+450,
        myShip.getY()+40,
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
    if(enemyShips.get(e).getCurrentHealth() != enemyShips.get(e).getMaxHealth())
    healthBars.add(new HealthBar(enemyShips.get(e).getX(),enemyShips.get(e).getY(),enemyShips.get(e).getMaxHealth(),enemyShips.get(e).getCurrentHealth()));
  }
  for (int w = 0; w < wingShips.size(); w++) {
    if(wingShips.get(w).getCurrentHealth() != wingShips.get(w).getMaxHealth())
    healthBars.add(new HealthBar(wingShips.get(w).getX(),wingShips.get(w).getY(),wingShips.get(w).getMaxHealth(),wingShips.get(w).getCurrentHealth()));
  }

  /* Show health bars */
  for(int h = 0; h < healthBars.size(); h++) {
    healthBars.get(h).show();
  }
}

public void showParticles() {
  for(int s = particles.size()-1; s >= 0; s--) {
    particles.get(s).move();
    particles.get(s).show();
  }
}

/* Helpers */
public boolean hasFuel() {
  return(myShip.getCurrentFuel()>0);
}
