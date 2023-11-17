Spaceship bob = new Spaceship();
Star []nightSky = new Star[200];
public void setup() 
{
  size(1000,1000);
  frameRate(60);
  for (int i = 0; i < nightSky.length; i++){
    nightSky[i] = new Star();
  }
}
public void draw() 
{
  fill(0,0,0,90);
  noStroke();
  rect(0,0,1000,1000);
  stroke(0,0,0);
  bob.show();
  bob.move();
  for (int i = 0; i < nightSky.length; i++){
    nightSky[i].show();
    nightSky[i].move();
  }
  if (mousePressed == true){
    strokeWeight(5);
    stroke(0,191,255);
    fill(0,191,255,50);
    ellipse((int)bob.getMCX(),(int)bob.getMCY(),100,100);
  }
  strokeWeight(1);
}

public void keyPressed(){
  if (key == ' '){
    bob.hyperspace();

  }
  if (key == 'a' || key == 'A'){
    bob.turn(-15);
  }
  if (key == 'd' || key == 'D'){
    bob.turn(15);
  }
  if (key == 'w' || key == 'W'){
    bob.accelerate(0.5);
  }
  if (key == 's' || key == 'S'){
    bob.accelerate(-0.5);
  }

  
}
