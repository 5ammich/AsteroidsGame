double accChange = 0.25;
boolean up, down, left, right;
int []xCorners1 = new int[]{0,9,0,27+(28/2),0,9,0,-9,-3,-9};
int []yCorners1 = new int[]{-18,-15,-12,0,12,15,18,9,0,-9};
int []xCorners2 = new int[]{-9,27+(28/2),-9};
int []yCorners2 = new int[]{-18,0,18};
int []xCorners3 = new int[]{0,27,0,-27};
int []yCorners3 = new int[]{27,0,-27,0};
boolean gameStart = false, moveOn = false, mRelease, one = false;
boolean tri = false, big = false, sq = false;
boolean charger1 = false, charger2 = false, charger3 = false, dodge1 = false;
boolean classic = false, beta = false, pause = false;
int astNum = (int)((Math.random()*21))+20;
int timeStorer = 5, fastSetter = 5;
boolean hider = false, shower = true, unHider = false, speeder = false;
int hurt = 0; 
int counter = 0;
int limiter = 2;
int cooler = 0;
int coolerPlus = 1;
boolean gameOver = false;

//pause button object
HealthBoost boost = new HealthBoost();
Pause pauser = new Pause();
//big
Spaceship bob = new Spaceship(10, xCorners1, yCorners1,480*2,625);
Star []nightSky = new Star[600];
//tri
Spaceship sue = new Spaceship(3,xCorners2, yCorners2,560, 625);
//sq
Spaceship dan = new Spaceship(4, xCorners3, yCorners3,1375, 625);

//Asteroid ast = new Asteroid();
ArrayList <Asteroid> ast = new ArrayList<Asteroid>();


ArrayList <Bullet> bill = new ArrayList<Bullet>();
ArrayList <Bullet> sill = new ArrayList<Bullet>();
ArrayList <Bullet> dill = new ArrayList<Bullet>();




public void setup() 
{
  frameRate(24);
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
    //textSize(50);
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
      if (mouseX > 500 && mouseX < 650 && mouseY > 550 && mouseY < 700){
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
    textSize(80);
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
  
  if (gameStart == true && pause == false && gameOver == false){
    int time = millis();
    stroke(0,0,0);
   
   
//sue mover
    
    if (tri == true){
      for (int i = 0; i < sill.size(); i++){
        sill.get(i).show();
        sill.get(i).move();
    
      }
      sue.show();
      sue.move(); 
      fill(0,255,0);
      rect((float)sue.getMCX()-50, (float)sue.getMCY()+50, 100, 20);
      fill(255,0,0);
      rect((float)sue.getMCX()+50-hurt, (float)sue.getMCY()+50,0+hurt,20);
      if (sue.getMCX()+50-hurt <= sue.getMCX()-50){
         gameOver = true;
        
      }

      for (int l = 0; l < ast.size(); l++){ 
          float s = dist((float)sue.getMCX(), (float)sue.getMCY(),(float)ast.get(l).getMyCenterX(), (float)ast.get(l).getMyCenterY());
          if (ast.get(l).getSize() == 2){
            if (s < 30 && charger1 == false){
              ast.remove(l);
           if((sue.getMCX() + 50 - hurt) > sue.getMCX() - 50){
              hurt = hurt + 10;

            }
              break;

            }
          }
          else if (ast.get(l).getSize() > 2){
            if (s < 50 && charger1 == false){
              ast.remove(l);
           if((sue.getMCX() + 50 - hurt) > sue.getMCX() - 50){
              hurt = hurt + 10;

            }
              break;

            }
          }
        for (int p = 0; p < sill.size(); p++){
          float a = dist((float)sill.get(p).getMCX(), (float)sill.get(p).getMCY(), (float)ast.get(l).getMyCenterX(),(float)ast.get(l).getMyCenterY());
              if (a < 50 && charger1 == false){
                ast.remove(l);
                sill.remove(p);
                break;

              }
            }

        }
      



    }

//bob mover



    if (big == true){
      boolean storer = false;

      for (int i = 0; i < bill.size(); i++){
        bill.get(i).show();
        bill.get(i).move();
    
      }

      bob.show();
      bob.move();
      fill(0,255,0);
      rect((float)bob.getMCX()-50, (float)bob.getMCY()+50, 100, 20);
      fill(255,0,0);
      rect((float)bob.getMCX()+50-hurt, (float)bob.getMCY()+50,0+hurt,20);
      if (bob.getMCX()+50-hurt <= bob.getMCX()-50){
         gameOver = true;
        
      }
      for (int l = 0; l < ast.size(); l++){ 
          float s = dist((float)bob.getMCX(), (float)bob.getMCY(),(float)ast.get(l).getMyCenterX(), (float)ast.get(l).getMyCenterY());
          if (ast.get(l).getSize() == 2){
            if (s < 30 && charger1 == false){
              ast.remove(l);
           if((bob.getMCX() + 50 - hurt) > bob.getMCX() - 50){
              hurt = hurt + 20;

            }
              break;

            }
          }
          else if (ast.get(l).getSize() > 2){
            if (s < 50 && charger1 == false){
              ast.remove(l);
           if((bob.getMCX() + 50 - hurt) > bob.getMCX() - 50){
              hurt = hurt + 20;

            }
              break;

            }
          }
        for (int p = 0; p < bill.size(); p++){
          float a = dist((float)bill.get(p).getMCX(), (float)bill.get(p).getMCY(), (float)ast.get(l).getMyCenterX(),(float)ast.get(l).getMyCenterY());
              if (a < 50 && charger1 == false){
                ast.remove(l);
                bill.remove(p);
                break;

              }
            }

        }
      if (storer == false){
        storer = true; 
      }
    }

//dan mover

    if (sq == true){
      for (int i = 0; i < dill.size(); i++){
        dill.get(i).show();
        dill.get(i).move();
    
      }
      dan.show();
      dan.move();
      fill(0,255,0);
      rect((float)dan.getMCX()-50, (float)dan.getMCY()+50, 100, 20);
      fill(255,0,0);
      rect((float)dan.getMCX()+50-hurt, (float)dan.getMCY()+50,0+hurt,20);
      if (dan.getMCX()+50-hurt <= dan.getMCX()-50){
         gameOver = true;
        
      }
      for (int l = 0; l < ast.size(); l++){ 
          float s = dist((float)dan.getMCX(), (float)dan.getMCY(),(float)ast.get(l).getMyCenterX(), (float)ast.get(l).getMyCenterY());
          if (ast.get(l).getSize() == 2){
            if (s < 30 && charger1 == false){
              ast.remove(l);
           if((dan.getMCX() + 50 - hurt) > dan.getMCX() - 50){
              hurt = hurt + 20;

            }
              break;

            }
          }
          else if (ast.get(l).getSize() > 2){
            if (s < 50 && charger1 == false){
              ast.remove(l);
           if((dan.getMCX() + 50 - hurt) > dan.getMCX() - 50){
              hurt = hurt + 20;

            }
              break;

            }
          }
        for (int p = 0; p < dill.size(); p++){
          float a = dist((float)dill.get(p).getMCX(), (float)dill.get(p).getMCY(), (float)ast.get(l).getMyCenterX(),(float)ast.get(l).getMyCenterY());
              if (a < 50 && charger1 == false){
                ast.remove(l);
                dill.remove(p);
                break;

              }
            }

        }
    }
      if (time/1000 > timeStorer && ast.size() <= 80){
        int oldAst = ast.size();
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        if (ast.size() < 20){
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
        ast.add(new Asteroid());
          
          
        }

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

        timeStorer = timeStorer + 5;
      }
      
    boost.show();
    if (tri == true){
    float lifeS = dist((float)sue.getMCX(), (float)sue.getMCY(), (float)boost.getRBX(),(float)boost.getRBY());
    if (lifeS < 55 && hurt > 0){
      hurt = hurt - 20;
      boost.setRB();
      }
    }
    if (big == true){
    float lifeB = dist((float)bob.getMCX(), (float)bob.getMCY(), (float)boost.getRBX(),(float)boost.getRBY());
    if (lifeB < 55 && hurt > 0){
      hurt = hurt - 20;
      boost.setRB();
      }
    }
    if (sq == true){
    float lifeD = dist((float)dan.getMCX(), (float)dan.getMCY(), (float)boost.getRBX(),(float)boost.getRBY());
    if (lifeD < 55 && hurt > 0){
      hurt = hurt - 20;
      boost.setRB();
      }
    }
      
      
      
      
      
      
//creates barrier
    if (mousePressed == true){
      strokeWeight(5);
      stroke(0,191,255);
      fill(0,191,255,50);
      
      
//sue dodger

      
      if (tri == true){
        ellipse((int)sue.getMCX(),(int)sue.getMCY(),100,100);
        if (mouseButton == RIGHT && dodge1 == false){
          if (sue.getMPD()%360 < -100 && sue.getMPD()%360 > -260 || sue.getMPD()%360 > 90 && sue.getMPD()%360 < 270){
            sue.dodge(-200);
            charger1 = true;
          }
          if (sue.getMPD()%360 > -90 && sue.getMPD()%360 < 90 || (sue.getMPD()%360 < -90 && sue.getMPD()%360 < -270) || (sue.getMPD()%360 > 270 && sue.getMPD()%360 < 360)){
            sue.dodge(200);
            charger1 = true;
          }
          dodge1 = true;
         }
      if (mouseButton == LEFT){
        if (counter/3 != limiter){
          sill.add(new Bullet(sue));
          counter = counter + 1;
        }
        
        else if (counter/3 == limiter){
          if (cooler/3 == coolerPlus){
             cooler = 0; 
             counter = 0;
          }
          else{
            cooler = cooler + 1;
          }
      
      }
      }

      }
      for (int i = 0; i < sill.size(); i++){
        if (sill.get(i).getMCX() < 0 || sill.get(i).getMCX() > 2000 || sill.get(i).getMCY() < 0 || sill.get(i).getMCY() > 1000){
          sill.remove(i);
          i--;
      }
      }
      
//bob dodger
      if (big == true){
        ellipse((int)bob.getMCX(),(int)bob.getMCY(),100,100);
        if (mouseButton == RIGHT && dodge1 == false){
          if (bob.getMPD()%360 < -100 && bob.getMPD()%360 > -260 || bob.getMPD()%360 > 90 && bob.getMPD()%360 < 270){
            bob.dodge(-200);
            charger2 = true;
          }
          if (bob.getMPD()%360 > -90 && bob.getMPD()%360 < 90 || (bob.getMPD()%360 < -90 && bob.getMPD()%360 < -270) || (bob.getMPD()%360 > 270 && bob.getMPD()%360 < 360)){
            bob.dodge(200);
            charger2 = true;
          }

          dodge1 = true;
         }
      if (mouseButton == LEFT){
        if (counter/3 != limiter){
          bill.add(new Bullet(bob));
          counter = counter + 1;
        }
        
        else if (counter/3 == limiter){
          if (cooler/3 == coolerPlus){
             cooler = 0; 
             counter = 0;
          }
          else{
            cooler = cooler + 1;
          }
      
      }
      }

      
      }
      for (int i = 0; i < bill.size(); i++){
        if (bill.get(i).getMCX() < 0 || bill.get(i).getMCX() > 2000 || bill.get(i).getMCY() < 0 || bill.get(i).getMCY() > 1000){
          bill.remove(i);
          i--;
      }
      }
      

//dan dodger

      
      if (sq == true){
        ellipse((int)dan.getMCX(),(int)dan.getMCY(),100,100);
        if (mouseButton == RIGHT && dodge1 == false){
          if (dan.getMPD()%360 < -100 && dan.getMPD()%360 > -260 || dan.getMPD()%360 > 90 && dan.getMPD()%360 < 270){
            dan.dodge(-200);
          }
          if (dan.getMPD()%360 > -90 && dan.getMPD()%360 < 90 || (dan.getMPD()%360 < -90 && dan.getMPD()%360 < -270) || (dan.getMPD()%360 > 270 && dan.getMPD()%360 < 360)){
            dan.dodge(200);
          }
          dodge1 = true;
         }
      if (mouseButton == LEFT){
        if (counter/3 != limiter){
          dill.add(new Bullet(dan));
          counter = counter + 1;
        }
        
        else if (counter/3 == limiter){
          if (cooler/3 == coolerPlus){
             cooler = 0; 
             counter = 0;
          }
          else{
            cooler = cooler + 1;
          }
      
      }
      }
      }
      for (int i = 0; i < dill.size(); i++){
        if (dill.get(i).getMCX() < 0 || dill.get(i).getMCX() > 2000 || dill.get(i).getMCY() < 0 || dill.get(i).getMCY() > 1000){
          dill.remove(i);
          i--;
      }
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
    if (bob.getSpX() > fastSetter){
      bob.setSpX(fastSetter);
    }
    if (bob.getSpX() < -fastSetter){
      bob.setSpX(-fastSetter);
    }
    if (bob.getSpY() > fastSetter){
      bob.setSpY(fastSetter);
    }
    if (bob.getSpY() < -fastSetter){
      bob.setSpY(-fastSetter);
    }
    //SUE
    if (sue.getSpX() > fastSetter){
      sue.setSpX(fastSetter);
    }
    if (sue.getSpX() < -fastSetter){
      sue.setSpX(-fastSetter);
    }
    if (sue.getSpY() > fastSetter){
      sue.setSpY(fastSetter);
    }
    if (sue.getSpY() < -fastSetter){
      sue.setSpY(-fastSetter);
    }
    //DAN
    if (dan.getSpX() > fastSetter){
      dan.setSpX(fastSetter);
    }
    if (dan.getSpX() < -fastSetter){
      dan.setSpX(-fastSetter);
    }
    if (dan.getSpY() > fastSetter){
      dan.setSpY(fastSetter);
    }
    if (dan.getSpY() < -fastSetter){
      dan.setSpY(-fastSetter);
    }
    
    if (mousePressed == false && dodge1 == true){
      charger1 = false;
      charger2 = false;
      charger3 = false;
      dodge1 = false;
    }

//PAUSE BUTTON
  if (pause == true && gameOver == false){
    if (hider == false && unHider == false){
      pauser.show();
      fill(255,255,255);
      strokeWeight(10);
      fill(255,0,0);
      text("FAST SPEED", 165, 275);
      fill(0,255,0);
      text("REGULAR SPEED", 165, 375);
      fill(255,255,0);
      text("SLOW SPEED", 165, 475);
      noFill();
      rect(150,325,375,75);
      rect(150,225,300,75);
      rect(150,425,300,75);

      strokeWeight(1);
      shower = true;
    }
    if (mouseX <= pauser.getBoxX() + 350 && mouseX >= pauser.getBoxX() && mouseY <= pauser.getBoxY() + 75 && mouseY >= pauser.getBoxY() && shower == true && mouseButton == LEFT){
        hider = true;

    }
    if (mouseX <= 450 && mouseX >= 150 && mouseY <= 300 && mouseY >= 225 && mouseButton == LEFT){
        fastSetter = 10;
        speeder = true;
        one = false;
    }
    if (mouseX <= 450 && mouseX >= 150 && mouseY <= 450 && mouseY >= 325 && mouseButton == LEFT){
        fastSetter = 5;
        speeder = false;
        one = false;
    }
    if (mouseX <= 450 && mouseX >= 150 && mouseY <= 500 && mouseY >= 425 && mouseButton == LEFT){
        fastSetter = 2;
        speeder = false;
        one = true;
    }
    if (speeder == false && hider != true && one == false){
      fill(0,255,0);
      rect(570,340,50,50);
      
    }
    else if (speeder == true && hider != true && one == false){
      fill(0,255,0);
      rect(500,235,50,50);
    }
    else if (speeder == false && hider != true && one == true){
      fill(0,255,0);
      rect(500,435,50,50);
    }
    if (hider == true){
        HealthBoost example = new HealthBoost();
        fill(0,255,255);
        text("HOW TO PLAY", 750, 200);
        text("W and S to accelerate/decelerate and A and D to rotate the Ship.", 100, 250);
        text("SPACE to hyperspace and Right Click allows you to dodge asteroids.", 100, 300);
        text("Left Click allows you to shoot bullets.", 100, 350);
        text("Pressing R will reset the game.", 100, 550);
        text("Caution: you may spawn onto an asteroid.", 100, 600);
        stroke(255);
        fill(250,0,0);
        rect(37.5,105,50,50,90);
        fill(255);
        strokeWeight(10);
        line(50,120,75,145);
        line(75,120,50,145);
        example.setRB(150,420);
        example.show();
        text("<-- This is a Health Boost. When you take damage, you can pick it up to heal", 200, 430);
        strokeWeight(1);

      if (mouseX <= 37.5 + 50 && mouseX >= 37.5 && mouseY <= 155 && mouseY >= 105 && mouseButton == LEFT){
          hider = false;
          unHider = true;
  
      }
    }
    
    
    
    
    
  }
  if (gameOver == true){
    textSize(100);
    fill(255,0,0);
    stroke(255,0,0);
    text("GAME OVER", 750, 200);
    text("PRESS R TO RESTART", 500, 300);
    textSize(10);
    
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
    if (key == 't' || key == 'T'){

        pause = !pause;
        hider = false;
        shower = false;
    }
  }
  
//reset button (when the time comes)
  
  if (key == 'r' || key == 'R'){
   mRelease = false;
   accChange = 0.25;
   gameStart = false;
   moveOn = false;
   one = false;
   tri = false;
   big = false; 
   sq = false;
   charger1 = false;
   charger2 = false;
   charger3 = false;
   dodge1 = false;
   classic = false; 
   beta = false;
   pause = false;
   astNum = (int)((Math.random()*21))+20;
   timeStorer = 5;
   fastSetter = 5;
   hider = false;
   shower = true;
   unHider = false;
   speeder = false;
   hurt = 0; 
   counter = 0;
   limiter = 2;
   cooler = 0;
   coolerPlus = 1;
   gameOver = false;
   bob.setMC();
   sue.setMCS();
   dan.setMCD();
   bob.setMPD();
   sue.setMPD();
   dan.setMPD();
   for (int i = 0; i < ast.size(); i++){
     ast.get(i).setAMC();
   }
   boost.setRB();
  }
}
public void mouseReleased(){
  if (mouseButton == LEFT){
    unHider = false;
    
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
