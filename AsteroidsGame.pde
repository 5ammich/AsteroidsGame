/* Constant variables */
public final int NUM_STARS = 500;
public final int MAX_VELOCITY = 3;
public final double SHIP_ACCELERATION = 0.025;

/* Object variables */
SpaceShip ship;
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

/* Other variables */
HashMap<String,Boolean> keys = new HashMap<String,Boolean>();

public void setup() {
  /* Set screen size, framerate*/
  size(1000, 700);
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
  /* Runs supposedly 60 times per second */
  background(0);
  showStars();
  showAsteroids();
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
      ship.setX((int)(Math.random()*width));
      ship.setY((int)(Math.random()*height));
      ship.setDirectionX(0);
      ship.setDirectionY(0);
      ship.setPointDirection((int)(Math.random()*360));
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
  }
}

public void showAsteroids() {

  /* Randomly adds more asteroids */
  if ((int)(Math.random()*10) == 0) {
    asteroids.add(new Asteroid());
  }

  /* Moves an asteroid, shows it, and then removes it if conditions are met */
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

/* Runs through hashmap and moves ship accordingly */
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
