/* Constant variables */
public final int NUM_STARS = 500;
public final int MAX_VELOCITY = 3;
public final double SHIP_ACCELERATION = 0.025;

/* Object variables */
public SpaceShip myShip;
public ArrayList<Star> stars = new ArrayList<Star>();
public ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
public ArrayList<Bullet> bullets = new ArrayList<Bullet>();

/* Other variables */
public HashMap<String,Boolean> keys = new HashMap<String,Boolean>();

public void setup() {
  /* Set screen size, framerate*/
  size(1000, 700);
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
