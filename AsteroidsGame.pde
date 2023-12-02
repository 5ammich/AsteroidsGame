private double accChange = 0.25;
private boolean up, down, left, right;
private int []xCorners1 = new int[]{0,9,0,27+(28/2),0,9,0,-9,-3,-9};
private int []yCorners1 = new int[]{-18,-15,-12,0,12,15,18,9,0,-9};
private int []xCorners2 = new int[]{-9,27+(28/2),-9};
private int []yCorners2 = new int[]{-18,0,18};
private int []xCorners3 = new int[]{0,27,0,-27};
private int []yCorners3 = new int[]{27,0,-27,0};
private boolean gameStart = false, moveOn = false, mRelease;
private boolean tri = false, big = false, sq = false;
private boolean classic = false, beta = false;
private int astNum = (int)((Math.random()*61))+20;
//big
Spaceship bob = new Spaceship(10, xCorners1, yCorners1,480*2,625);
Star []nightSky = new Star[600];
//tri
Spaceship sue = new Spaceship(3,xCorners2, yCorners2,560, 625);
//sq
Spaceship dan = new Spaceship(4, xCorners3, yCorners3,1375, 625);

//Asteroid ast = new Asteroid();
ArrayList <Asteroid> ast = new ArrayList<Asteroid>();






public void setup() 
{
  size(2000,1000);
  frameRate(120);
  for (int i = 0; i < nightSky.length; i++){
    nightSky[i] = new Star();
  }
  for (int j = 0; j < astNum; j++){
    ast.add(new Asteroid());
  }
}








public void draw() 
{
    textSize(50);
    //fill(255,0,255);
    //text(mouseX, 100,100);
    //text(mouseY, 200,100);
    fill(0,0,0,90);
    noStroke();
    rect(0,0,2000,1000);
    stroke(0,0,0);
    for (int i = 0; i < nightSky.length; i++){
      nightSky[i].show();
      nightSky[i].move();
    }
  if (moveOn == false){
    fill(255,255,0);
    textSize(80);
    text("ASTEROIDS",775,250);
    textSize(50);
    text("CHOOSE YOUR SHIP:", 750,350);
    noFill();
    strokeWeight(10);
    stroke(255,255,255);
    rect(500,550,150,150);
    rect(900,550,150,150);
    rect(1300,550,150,150);
    stroke(0,0,0);
    bob.show();
    sue.show();
    dan.show(); 
    strokeWeight(1);
    
//giant check to see what ship you chose

    if (mousePressed == true){
      if (mouseX > 500 && mouseX < 710 && mouseY > 550 && mouseY < 700){
        tri = true;
        sue.setMC();
        moveOn = true;
      }
      if (mouseX > 900 && mouseX < 1050 && mouseY > 550 && mouseY < 700){
        big = true;
        moveOn = true;
      }
      if (mouseX > 1300 && mouseX < 1450 && mouseY > 550 && mouseY < 700){
        sq = true;
        dan.setMC();
        moveOn = true;
      }
    }
   
  }
  
  //check beta test asteroids or classic
  if (moveOn == true && gameStart == false){
    if (mousePressed == false){
      mRelease = true;
    }
    fill(0,255,0);
    textSize(80);
    text("PICK A MODE:", 750,350);
    noFill();
    stroke(255,255,255);
    strokeWeight(10);
    rect(600,550,350,150);
    rect(1050,550,350,150);
    fill(0,191,255);
    textSize(100);
    text("CLASSIC", 600, 650);
    text("BETA", 1125, 650);
    if (mousePressed == true && mRelease ==  true){
      if (mouseX > 600 && mouseX < 950 && mouseY > 550 && mouseY < 700){
        for (int l = 0; l < ast.size(); l++){ 
          ast.get(l).setClassicAsteroids();
          classic = true;
      }
        gameStart = true;
      }
      if (mouseX > 1050 && mouseX < 1400 && mouseY > 550 && mouseY < 700){
        for (int l = 0; l < ast.size(); l++){ 
          ast.get(l).setSpAsteroids();
          beta = true;
      }
        gameStart = true;
      }
    }
    strokeWeight(1);
  }
//actual game start
  
  if (gameStart == true){
    stroke(0,0,0);
    if (tri == true){
      sue.show();
      sue.move(); 
      for (int l = 0; l < ast.size(); l++){ 
          float s = dist((float)sue.getMCX(), (float)sue.getMCY(),(float)ast.get(l).getMyCenterX(), (float)ast.get(l).getMyCenterY());
          if (ast.get(l).getSize() == 2){
            if (s < 30){
              ast.remove(l);
            }
          }
          else if (ast.get(l).getSize() > 2){
            if (s < 50){
              ast.remove(l);
            }
          }
      }
    }

    if (big == true){
      bob.show();
      bob.move();
      for (int l = 0; l < ast.size(); l++){ 
          float b = dist((float)bob.getMCX(), (float)bob.getMCY(),(float)ast.get(l).getMyCenterX(), (float)ast.get(l).getMyCenterY());
          if (ast.get(l).getSize() == 2){
            if (b < 30){
              ast.remove(l);
            }
          }
          else if (ast.get(l).getSize() > 2){
            if (b < 50){
              ast.remove(l);
            }
          }
      }
    }

    if (sq == true){
      dan.show();
      dan.move();
      for (int l = 0; l < ast.size(); l++){ 
          float d = dist((float)dan.getMCX(), (float)dan.getMCY(),(float)ast.get(l).getMyCenterX(), (float)ast.get(l).getMyCenterY());
          if (ast.get(l).getSize() == 2){
            if (d < 30){
              ast.remove(l);
            }
          }
          else if (ast.get(l).getSize() > 2){
            if (d < 50){
              ast.remove(l);
            }
          }
      }
    }
      if (Math.random()*1000000 > 995555 && ast.size() <= 200){
        int oldAst = ast.size();
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        for (int i = oldAst; i < ast.size(); i++){
          if (beta == true){
              ast.get(i).setSpAsteroids();
          }
          if (classic == true){
              ast.get(i).setClassicAsteroids();
          }
          ast.get(i).show();
          ast.get(i).move();
        }
      }
    
//creates barrier
   
    if (mousePressed == true){
      strokeWeight(5);
      stroke(0,191,255);
      fill(0,191,255,50);
      if (tri == true){
        ellipse((int)sue.getMCX(),(int)sue.getMCY(),100,100);
      }
      if (big == true){
        ellipse((int)bob.getMCX(),(int)bob.getMCY(),100,100);
      }
      if (sq == true){
        ellipse((int)dan.getMCX(),(int)dan.getMCY(),100,100);
      }
    }
    strokeWeight(1);
   
   for (int j = 0; j < ast.size(); j++){
        ast.get(j).show();
        ast.get(j).move();
    }
    
    
    
    
  }
    if (left == true){
      bob.turn(-12.5);
      sue.turn(-12.5);
      dan.turn(-12.5);
    }
    if (right == true){
      bob.turn(12.5);
      sue.turn(12.5);
      dan.turn(12.5);
    }
    if (up == true){
      bob.accelerate(accChange);
      sue.accelerate(accChange);
      dan.accelerate(accChange);
 
    }
    if (down == true){
      bob.accelerate(-accChange);
      sue.accelerate(-accChange);
      dan.accelerate(-accChange);
    }
    //speed limit
    //BOB
    if (bob.getSpX() > 12.5){
      bob.setSpX(12.5);
    }
    if (bob.getSpX() < -12.5){
      bob.setSpX(-12.5);
    }
    if (bob.getSpY() > 12.5){
      bob.setSpY(12.5);
    }
    if (bob.getSpY() < -12.5){
      bob.setSpY(-12.5);
    }
    //SUE
    if (sue.getSpX() > 12.5){
      sue.setSpX(12.5);
    }
    if (sue.getSpX() < -12.5){
      sue.setSpX(-12.5);
    }
    if (sue.getSpY() > 12.5){
      sue.setSpY(12.5);
    }
    if (sue.getSpY() < -12.5){
      sue.setSpY(-12.5);
    }
    //DAN
    if (dan.getSpX() > 12.5){
      dan.setSpX(12.5);
    }
    if (dan.getSpX() < -12.5){
      dan.setSpX(-12.5);
    }
    if (dan.getSpY() > 12.5){
      dan.setSpY(12.5);
    }
    if (dan.getSpY() < -12.5){
      dan.setSpY(-12.5);
    }
    
}




public void keyPressed(){
  if (gameStart == true){
    if (key == ' '){
      bob.hyperspace();
      sue.hyperspace();
      dan.hyperspace();
    }
    if (key == 'a' || key == 'A'){
      left = true;
    }
    if (key == 'd' || key == 'D'){
      right = true;
    }
    if (key == 'w' || key == 'W'){
      up = true;
    }
    if (key == 's' || key == 'S'){
      down = true;
    }
  }
  if (key == 'r' || key == 'R'){

  }
}

public void keyReleased(){
    if (gameStart == true){
    if (key == 'a' || key == 'A'){
      left = false;
    }
    if (key == 'd' || key == 'D'){
      right = false;
    }
    if (key == 'w' || key == 'W'){
      up = false;
    }
    if (key == 's' || key == 'S'){
      down = false;
    }
  }
  
}
