//Hongting Su, 47382481
//[√] I declare that I have not seen anyone else's code
//[√] I declare that I haven't shown my code to anyone else.

/*
The following statements have yellow lines
because these constants have not yet been used.
It's fine :)
*/

final int N_LANES = 2;
final int N_CARS_IN_LANE = 10;
final int MIN_GAP = 50;
final int MAX_LIVES = 3;
final int WIN_SCORE = 10;

float noseX1;
float blastX1;
float blastX2;
float blastX3;
float blastX4;
float upperSurfaceX1;
float upperSurfaceX2;
float upperSurfaceX3;
float upperSurfaceX4;
float lowerSurfaceX1;
float lowerSurfaceX2;
float lowerSurfaceX3;
float lowerSurfaceX4;
float bodyX1;
float vehicleSpeed;
float pedestrianRectX;
float pedestrianRectY;
float pedestrianTextX;
float pedestrianTextY;
boolean isLeft, isRight, upReleased, downReleased;

void setup() {
  size(1200, 400);
  noseX1 = (width/32+width/27) - width/10;
  blastX1 = width/37 - width/10;
  blastX2 = width/32 - width/10;
  blastX3 = width/32 - width/10;
  blastX4 = width/37 - width/10;
  upperSurfaceX1 = width/28 - width/10;
  upperSurfaceX2 = width/25 - width/10;
  upperSurfaceX3 = width/20 - width/10;
  upperSurfaceX4 = width/27 - width/10;
  lowerSurfaceX1 = width/28 - width/10;
  lowerSurfaceX2 = width/25 - width/10;
  lowerSurfaceX3 = width/20 - width/10;
  lowerSurfaceX4 = width/27 - width/10;
  bodyX1 = width/32 - width/10;
  pedestrianRectX = width/1.85;
  pedestrianRectY = height/1.16 - height/20;
  pedestrianTextX = width/1.85;
  pedestrianTextY = height/1.06 - height/20;
}

void draw(){
  vehicle();
  lane();
  pedestrian();
}

void vehicle(){
  
  vehicleSpeed = 1;                                            //speed of vehicle
  
  noseX1 = noseX1 + vehicleSpeed;
  blastX1 = blastX1 + vehicleSpeed; 
  blastX2 = blastX2 + vehicleSpeed;
  blastX3 = blastX3 + vehicleSpeed;
  blastX4 = blastX4 + vehicleSpeed;
  upperSurfaceX1 = upperSurfaceX1 + vehicleSpeed;
  upperSurfaceX2 = upperSurfaceX2 + vehicleSpeed;
  upperSurfaceX3 = upperSurfaceX3 + vehicleSpeed;
  upperSurfaceX4 = upperSurfaceX4 + vehicleSpeed;
  lowerSurfaceX1 = lowerSurfaceX1 + vehicleSpeed;
  lowerSurfaceX2 = lowerSurfaceX2 + vehicleSpeed;
  lowerSurfaceX3 = lowerSurfaceX3 + vehicleSpeed;
  lowerSurfaceX4 = lowerSurfaceX4 + vehicleSpeed;
  bodyX1 = bodyX1 + vehicleSpeed;
  
  background(150);
  fill(#DE4881);
  ellipse(noseX1, height/12+height/40, width/25, height/20);                                                                           //nose cone
  fill(150);
  quad(blastX1, height/10.5, blastX2, height/12, blastX3, height/12+height/20, blastX4, height/8.5);                                   //blast
  quad(upperSurfaceX1, height/18, upperSurfaceX2, height/18, upperSurfaceX3, height/12, upperSurfaceX4, height/12);                    //upper surface
  quad(lowerSurfaceX1, height/6, lowerSurfaceX2, height/6, lowerSurfaceX3, height/12+height/20, lowerSurfaceX4, height/12+height/20);  //lower surface
  fill(#518B01);
  rect(bodyX1, height/12, width/27, height/20);                                                                                        //body
  
  if(blastX4 > width){
    noseX1 = (width/32+width/27) - width/10;
    blastX1 = width/37 - width/10;
    blastX2 = width/32 - width/10;
    blastX3 = width/32 - width/10;
    blastX4 = width/37 - width/10;
    upperSurfaceX1 = width/28 - width/10;
    upperSurfaceX2 = width/25 - width/10;
    upperSurfaceX3 = width/20 - width/10;
    upperSurfaceX4 = width/27 - width/10;
    lowerSurfaceX1 = width/28 - width/10;
    lowerSurfaceX2 = width/25 - width/10;
    lowerSurfaceX3 = width/20 - width/10;
    lowerSurfaceX4 = width/27 - width/10;
    bodyX1 = width/32 - width/10; 
  }
}

void lane(){
  line(0, height/4, width, height/4);
}

void pedestrian(){
  rect(pedestrianRectX, pedestrianRectY, width/13.2, height/7);
  fill(0, 408, 612);
  textSize(width/80);
  text("PEDESTRIAN", pedestrianTextX, pedestrianTextY);
  if(isLeft){
    pedestrianRectX-= 3;
    pedestrianTextX-= 3;
  }
  if(isRight){
    pedestrianRectX+= 3;
    pedestrianTextX+= 3;
  }
}

void keyPressed(){
    if(key == 'A' || key == 'a'){
      isLeft = true;
    }
    if(key == 'D' || key == 'd'){
      isRight = true;
    }
}

void keyReleased(){
    if(key == 'A' || key == 'a'){
      isLeft = false;
    }
    if(key == 'D' || key == 'd'){
      isRight = false;
    }
    if(key == 'W' || key =='w'){
      pedestrianRectY-= height/4;
      pedestrianTextY-= height/4;
    }
    if(key == 'S' || key == 's'){
      pedestrianRectY+= height/4;
      pedestrianTextY+= height/4;
    }
}
