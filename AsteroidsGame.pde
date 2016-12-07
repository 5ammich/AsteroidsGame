// spacestation health and heal, upgrade stuff, etc.
// E to go warp speed
// Rocket visuals... meh
// Game over text
// Ships decrase health if out of range
// asteroid spacestation collisions

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
public boolean gameOverShown = false;

/* Object variables */
public MyShip myShip;
public ArrayList<WingShip> wingShips = new ArrayList<WingShip>();
public ArrayList<EnemyShip> enemyShips = new ArrayList<EnemyShip>();
public ArrayList<Star> stars = new ArrayList<Star>();
public ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
public ArrayList<Bullet> bullets = new ArrayList<Bullet>();
public ArrayList<HealthBar> healthBars = new ArrayList<HealthBar>();
public ArrayList<Particle> particles = new ArrayList<Particle>();
public ArrayList<MyShip> myShips = new ArrayList<MyShip>();
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
    myShips.remove(0);
    gameState = 3;
  }
}

public void titleScreen() {
  /* Clear and reset arraylists and variables */
  myShips.clear();
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
  gameOverShown = false;

  /* Initialize objects */
  myShips.add(new MyShip());
  myShip = myShips.get(0);
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
  textSize(16);
  textAlign(CENTER);
  fill(255);
  textSize(32);
  textAlign(RIGHT);
  text("Asteroids and More", width,100);
  textSize(20);
  text("Brandon Lou", width,150);
  text("ENTER to start", width, height);

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
  friendlySpacestation.show();
  enemySpacestation.show();
  showAsteroids();
  showBullets();
  showSpaceShips();
  showHealthBars();
  showParticles();
  showShip();
  showGUI();
  mouseCursor();

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
    textSize(18);
    text("Ship stats", 50, 125);
    text("10s +2 Max HP", 50, 145);
    text("10s +2 Armor", 50, 165);
    text("15s Energy Lasers Mark II", 50, 185);
    text("10s +10 Max Fuel", 50, 205);
    text("5s +10 Fuel Efficiency", 50, 225);
    text("50s +10 Max Heat", 50, 245);
    text("30s +5 Cooling efficiency", 50, 265);

    /* Ally ship upgrades */
    if(dist(myShip.getX(),myShip.getY(),friendlySpacestation.x,friendlySpacestation.y) < friendlySpacestation.radius) {
      text("10s Build ally ship",400,140);
      text("30s +10 Ally Max HP",400,160);
    }

    /* Spacestation upgrades */
    text("Spacestation Upgrades",50,400);
    text("20s +10 Spacestation health",50,420);
    text("100s Matter Converter Mark II",50,440);

    // Instruction text
    textSize(15);
    text("CONTROLS:",880,40);
    text("W - accelerate",880,60);
    text("A - rotate left",880,80);
    text("S - decellerate",880,100);
    text("D - rotate right",880,120);
    text("SPACE - fire bullets",880,140);
    text("Q - hyperspace",880,160);
    text("E - warp speed",880,180);
    text("ESC - Pause / Upgrade station",880,200);

    pauseDrawn = true;
  }
}

public void gameOverScreen() {

  if(!gameOverShown) {
    for(int i = 0; i < NUM_PARTICLES; i++) {
      particles.add(new Particle(myShip.getX(),myShip.getY(),color(0,0,255)));
    }
    gameOverShown = true;
  }

  translate(-camera.pos.x, -camera.pos.y);
  background(OUT_OF_BOUNDS_COLOR);
  updateCollisions();
  showSpace();
  friendlySpacestation.show();
  enemySpacestation.show();
  showAsteroids();
  showBullets();
  showSpaceShips();
  showHealthBars();
  showParticles();
  showGUI();
  mouseCursor();

  /* Game over graphics */
  noStroke();
  fill(0,0,0,100);
  rect(myShip.getX()-425,myShip.getY()-350,displayWidth,displayHeight);
  strokeWeight(1);
  stroke(255,0,0);
  fill(255,255,255);
  textAlign(LEFT);
  textSize(24);
  text("YOU DIED",myShip.getX()-400,myShip.getY()-300);
  text("ENTER to play again",myShip.getX()-400,myShip.getY()-270);
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
    if(hasFuel() && myShip.getCurrentFuel() > 0) {
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
      if(hasFuel() && myShip.getCurrentHealth() > 0) {
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
      myShip.setCurrentHeat(0.05);
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
      if(enemyShips.get(e).type == "boss") {bullets.add(new Bullet(enemyShips.get(e), "enemy_boss"));}
      else {bullets.add(new Bullet(enemyShips.get(e), "enemy"));}
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
  /* asteroids out of bounds gets removed, asteroids hits ship gets removed and particle effect
  asteroids hits bullet removes asteroid and bullet. particle effect
  bullets out of bound or lose energy gets removed
  bullets hits ship or ship hits bullet
  enemyships remove if dead, wingship remove if dead
  reduce health if out of bounds
  Cool down ship
  Over heat ends life Spacestation heals spaceship
  */

  bulletloop:
  for(int b = bullets.size()-1; b >= 0; b--) {
    /* Hits asteroid */
    asteroidloop:
    for(int a = asteroids.size()-1; a >= 0; a--) {
      if(dist(asteroids.get(a).getX(),asteroids.get(a).getY(),bullets.get(b).getX(),bullets.get(b).getY()) <= 20) {
        bullets.remove(b);
        for(int i = 0; i < NUM_PARTICLES; i++) {
          particles.add(new Particle(asteroids.get(a).getX(),asteroids.get(a).getY(),color(255,127,80)));
        }
        asteroids.remove(a);
        break bulletloop;
      }
      /* Asteroids out of bounds */
      if(asteroids.get(a).getX() > MAP_WIDTH || asteroids.get(a).getX() < 0 || asteroids.get(a).getY() > MAP_HEIGHT || asteroids.get(a).getY() < 0 || asteroids.get(a).getRotationSpeed() == 0) {
        asteroids.remove(a);
        break asteroidloop;
      }
      /* Asteroid hits ship */
      if (dist(asteroids.get(a).getX(), asteroids.get(a).getY(),myShip.getX(), myShip.getY()) <= 20) {
        for(int i = 0; i < NUM_PARTICLES; i++) {
          particles.add(new Particle(asteroids.get(a).getX(),asteroids.get(a).getY(),color(255,127,80)));
        }
        asteroids.remove(a);
        myShip.setCurrentHealth(-myShip.getCurrentHealth());
        myShip.setCurrentFuel(-myShip.getCurrentFuel());
        myShip.setCurrentHeat(-myShip.getCurrentHeat());
        myShips.remove(0);
        gameState = 3;
        break asteroidloop;
      }
    }
    /* Out of bounds or runs out of power */
    if(dist(bullets.get(b).getInitX(),bullets.get(b).getInitY(),bullets.get(b).getX(),bullets.get(b).getY()) >= 700) {
      bullets.remove(b);
      break bulletloop;
    }
    /* Hits your ship */
    if(dist(bullets.get(b).getX(), bullets.get(b).getY(), myShip.getX(), myShip.getY()) <= 20 && bullets.get(b).getType() == "enemy") {
      bullets.remove(b);
      myShip.setCurrentHealth(-0.5);
      break bulletloop;
    }
    /* Hits enemyship */
    for(int e = enemyShips.size()-1; e >= 0; e--) {
      if(dist(bullets.get(b).getX(), bullets.get(b).getY(), enemyShips.get(e).getX(), enemyShips.get(e).getY()) <= 20 && (bullets.get(b).getType() == "mine" || bullets.get(b).getType() == "friendly")) {
        bullets.remove(b);
        enemyShips.get(e).setCurrentHealth(-0.5);
        break bulletloop;
      }
      /* Remove if dead */
      if (enemyShips.get(e).getCurrentHealth() <= 0) {
        for(int i = 0; i < NUM_PARTICLES; i++) {
          particles.add(new Particle(enemyShips.get(e).getX(),enemyShips.get(e).getY(),color(255,0,0)));
        }
        enemyShips.remove(e);
        score += 5;
        if(javascript != null) javascript.playSound("explode");
      }
    }
    /* Hits wingship */
    for(int w = wingShips.size()-1; w >= 0; w--) {
      if(dist(wingShips.get(w).getX(),wingShips.get(w).getY(),bullets.get(b).getX(),bullets.get(b).getY()) <= 20 && bullets.get(b).getType() == "enemy") {
        bullets.remove(b);
        wingShips.get(w).setCurrentHealth(-0.5);
        break bulletloop;
      }
      if(wingShips.get(w).getCurrentHealth() <= 0) {
        for(int i = 0; i < NUM_PARTICLES; i++) {
          particles.add(new Particle(wingShips.get(w).getX(),wingShips.get(w).getY(),color(0,0,255)));
        }
        wingShips.remove(w);
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
    myShip.setCurrentHeat(-0.3);
  }
  /* Over heat ends life */
  if(myShip.getCurrentHeat() >= myShip.getMaxHeat()) {
    myShip.setCurrentHealth(-myShip.getCurrentHealth());
    myShip.setCurrentFuel(-myShip.getCurrentFuel());
    myShips.remove(0);
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

  if(myShip.getCurrentHealth() > 0) {
  rect(myShip.getX()+450,
       myShip.getY()-80,
       (float)(myShip.getCurrentHealth()*(200/myShip.getMaxHealth())),
       10);
  } else {
    rect(myShip.getX()+450,
         myShip.getY()-80,
         0,
         10);
  }

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

   /* Speed text */
   fill(255);
   textAlign(LEFT);
   text("Speed",myShip.getX()+450,myShip.getY()-10);

   /* Speed bar */
   strokeWeight(1);
   stroke(255);
   fill(255,255,0);
   rect(myShip.getX()+450,
        myShip.getY()-0,
        (float)(myShip.getCurrentSpeed()*(200/myShip.getMaxSpeed())),
        10);

  /* Heat text */
  fill(255);
  textAlign(LEFT);
  text("Heat",myShip.getX()+450,myShip.getY()+30);

  /* Heat bar */
  strokeWeight(1);
  stroke(255);
  fill(0,0,255);
  rect(myShip.getX()+450,
       myShip.getY()+40,
       (float)(myShip.getCurrentHeat()*(200/myShip.getMaxHeat())),
       10);

  /* Sidebar stats */
  fill(255);
  textAlign(LEFT);
  text("Score: " + score,myShip.getX()+450,myShip.getY()+80);
  text("Scrap: " + scrap,myShip.getX()+450,myShip.getY()+100);

  /* Warning messages */
  textAlign(CENTER);
  if(myShip.getCurrentHeat() >= myShip.getMaxHeat()*0.75) fill(0,191,255); else fill(0,0,139);
  rect(myShip.getX()+450,myShip.getY()+120,200,50);
  if(myShip.getCurrentHeat() >= myShip.getMaxHeat()*0.75) fill(255); else fill(100);
  text("OVERHEATING!",myShip.getX()+550,myShip.getY()+150);

  if(myShip.getCurrentFuel() <= myShip.getMaxFuel()*0.25) fill(0,255,0); else fill(0,100,0);
  rect(myShip.getX()+450,myShip.getY()+180,200,50);
  if(myShip.getCurrentFuel() <= myShip.getMaxFuel()*0.25) fill(255); else fill(100);
  text("FUEL LOW",myShip.getX()+550,myShip.getY()+210);

  if(myShip.getCurrentHealth() <= myShip.getMaxHealth()*0.25) fill(255,0,0); else fill(139,0,0);
  rect(myShip.getX()+450,myShip.getY()+240,200,50);
  if(myShip.getCurrentHealth() <= myShip.getMaxHealth()*0.25) fill(255); else fill(100);
  text("HEALTH LOW",myShip.getX()+550,myShip.getY()+270);

  /* Stats */
  textAlign(LEFT);
  fill(255);
  text("Max health: " + myShip.getMaxHealth(),myShip.getX()-400,myShip.getY()-325);
  text("Armor: ",myShip.getX()-400,myShip.getY()-300);
  text("Laser power: ",myShip.getX()-400,myShip.getY()-275);

  text("Max fuel: " + myShip.getMaxFuel(),myShip.getX()-200,myShip.getY()-325);
  text("Fuel efficency: ",myShip.getX()-200,myShip.getY()-300);

  text("Max heat: " + myShip.getMaxHeat(),myShip.getX(),myShip.getY()-325);

  text("Ally ships: " + wingShips.size(),myShip.getX()-400,myShip.getY()+325);
  text("Ally health: " + wingShips.size(),myShip.getX()-300,myShip.getY()+325);
  text("Spacestation Health: " + friendlySpacestation.getMaxHealth(),myShip.getX()-200,myShip.getY()+325);
  text("Matter converter efficency: " + friendlySpacestation.getMaxHealth(),myShip.getX()-25,myShip.getY()+325);

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
  } else {
    if((int)random(0,100) == 0) enemyShips.add(new EnemyShip("scout"));
    if((int)random(0,250) == 0) enemyShips.add(new EnemyShip("adv"));
    if((int)random(0,450) == 0) enemyShips.add(new EnemyShip("captain"));
    if((int)random(0,450) == 0) enemyShips.add(new EnemyShip("boss"));
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
    if(dist((float)particles.get(s).initX,(float)particles.get(s).initY,particles.get(s).getX(),particles.get(s).getY()) >= 100) {
      particles.remove(s);
    }
  }
  if(keys.get("w") == true) {
    //cool stuff
    fill(255,0,0);
    double dRadians = myShip.getPointDirection() * (Math.PI/180);
    rect((float)(myShip.getX() - 20*Math.cos(dRadians)),(float)(myShip.getY() - 20*Math.sin(dRadians)),10,10);
  }
}

public void mouseClicked() {
  if(mouseX > 875 && mouseX < 1075 && mouseY > 25 && mouseY < 225) {
    double x  = mouseX - 875; // Gets values down to a range of 0 - 200
    double y = mouseY - 25;
    x *= 25; // Scale factor from 200 minimap size to 5000 map size
    y *= 25;
    myShip.teleport(x,y);
    camera.hyperspace(myShip);
  }
}

public void mouseCursor() {
  stroke(255);
  fill(255,105,180,100);
  int originX = myShip.getX() - 425;
  int originY = myShip.getY() - 350;
  ellipse(originX+mouseX, originY+mouseY,20,20);
}

/* Helpers */
public boolean hasFuel() {
  return(myShip.getCurrentFuel()>0);
}
public boolean isAlive() {
  return (myShip.getCurrentHealth()>0);
}
