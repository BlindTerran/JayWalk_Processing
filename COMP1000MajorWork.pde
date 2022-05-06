//Hongting Su, 47382481
//[√] I declare that I have not seen anyone else's code
//[√] I declare that I haven't shown my code to anyone else.

final int N_LANES = 2;
final int N_CARS_IN_LANE = 10;
final int MIN_GAP = 50;
final int MAX_LIVES = 3;
final int WIN_SCORE = 10;

float noseX1, noseY1, noseWidth;
float upperSurfaceY1, upperSurfaceY2;
float bodyX1, bodyY1, bodyWidth;
float vehicleSpeed;
float pedestrianSpeed;
float pedestrianRectX, pedestrianRectY;
float pedestrianTextX, pedestrianTextY;
float distance;
int score = 0;
boolean isLeft, isRight, upReleased, downReleased;
boolean collided = false;

void setup() {
  size(1200, 400);
  
  //vehicle position
  float indentation = width/10;
  bodyX1 = width/32; 
  bodyY1 = height/12;
  noseY1 = height/12+height/40;
  upperSurfaceY1 = bodyY1-height/36;
  upperSurfaceY2 = bodyY1;
  
  //pedestrian position
  pedestrianRectX = width/1.85;
  pedestrianRectY = height/1.16 - height/20;
  pedestrianTextX = width/1.85;
  pedestrianTextY = height/1.06 - height/20;
}

void draw() {
  vehicle();
  vehicleUpdate();
  pedestrian();
  pedestrianUpdate();
  lane();
  scoreCalculator();
  collisionDetection();
}

//function to display the vehicle
void vehicle() {
  background(150);
  //nose cone
  fill(#DE4881);
  ellipse(bodyX1+width/27, noseY1, width/25, height/20); 
  //blast
  fill(150);
  quad(bodyX1 - 5*width/1184, height/10.5, bodyX1, height/12, bodyX1, height/12+height/20, bodyX1 - 5*width/1184, height/8.5);           
  //upper surface
  quad(bodyX1+width/224, upperSurfaceY1, bodyX1+7*width/800, upperSurfaceY1, bodyX1+3*width/160, upperSurfaceY2, bodyX1+5*width/864, upperSurfaceY2);       
  //lower surface
  quad(bodyX1+width/224, height/6, bodyX1+7*width/800, height/6, bodyX1+3*width/160, height/12+height/20, bodyX1+5*width/864, height/12+height/20);  
  //body
  fill(#518B01);
  rect(bodyX1, bodyY1, width/27, height/20);                                                                                        

  //reset the vehicle if it goes byond the right boundary
  if (bodyX1 - 5*width/1184 > width) {
    bodyX1 = width/32;
  }
}

//function to update vehicle position
void vehicleUpdate() {
  //speed of vehicle
  vehicleSpeed = 1;                                            

  bodyX1 += vehicleSpeed;
}

//function to display the lane
void lane() {
    boolean dash = true;
    for (int i=0; i<=width; i+=width/24) {
    if(dash){
      stroke(0);
      dash = false;
    } else {
      stroke(150);
      dash = true;
    }
    line(i, height/4, i+width/24, height/4);
  }
}

//function to display the pedestrian 
void pedestrian() {
  //speed of pedestrian
  pedestrianSpeed = 3;                                              
  
  rect(pedestrianRectX, pedestrianRectY, width/13.2, height/7);
  fill(0, 408, 612);
  textSize(width/80);
  text("PEDESTRIAN", pedestrianTextX, pedestrianTextY);
}

//function to update pedestrian position
void pedestrianUpdate() {
  if (isLeft) {
    pedestrianRectX-= pedestrianSpeed;
    pedestrianTextX-= pedestrianSpeed;
  }
  if (isRight) {
    pedestrianRectX+= pedestrianSpeed;
    pedestrianTextX+= pedestrianSpeed;
  }
}

//key control function
/*
control accepts both upper and lower case key input
press key 'a' to move pedestrian left
          'd' to move pedestrian right
release key 'w' to move pedestrian up
            's' to move pedestrian down
*/
void keyPressed() {
  if (key == 'A' || key == 'a') {
    isLeft = true;
  }
  if (key == 'D' || key == 'd') {
    isRight = true;
  }
  if (key == 'W' || key =='w') {
    pedestrianRectY-= height/4;
    pedestrianTextY-= height/4;
  }
  if (key == 'S' || key == 's') {
    pedestrianRectY+= height/4;
    pedestrianTextY+= height/4;
  }
}

void keyReleased() {
  if (key == 'A' || key == 'a') {
    isLeft = false;
  }
  if (key == 'D' || key == 'd') {
    isRight = false;
  }
}

//function to detect collision
void collisionDetection() {
  float vehicleTop, vehicleWidth, vehicleHeight, pedestrianWidth, pedestrianHeight;
  noseWidth = width/25;
  bodyWidth = width/27;

  vehicleWidth = bodyX1 - bodyX1 - 5*width/1184 + bodyWidth + noseWidth/2;
  vehicleHeight = height/6 - height/18;
  vehicleTop = height/18;
  pedestrianWidth = width/13.2;
  pedestrianHeight = height/7;

  if (pedestrianRectX + pedestrianWidth > bodyX1 - 5*width/1184 && pedestrianRectX < bodyX1 - 5*width/1184 + vehicleWidth && pedestrianRectY + pedestrianHeight > vehicleTop && pedestrianRectY < vehicleTop + vehicleHeight) {
    collided = true;
  }
  
  //display game over scene when collided
  if (collided) {
    fill(#D4FA00);
    rect(0, 0, width, height);
    fill(#FA8A21);
    textSize(80);
    text("GAME OVER!", width*0.3, 11*width/60);
    
    noLoop();
  }
}
//function to calculate the score 
void scoreCalculator() {
  if (pedestrianRectY < 0) {
    score++;
    
    //reset the pedestrian 
    pedestrianReset();
  }
  
  text("SCORE: "+score, width*0.7, height*0.98);
}

//function for resetting the pedestrian
void pedestrianReset() {
  pedestrianRectX = width/1.85;
  pedestrianRectY = height/1.16 - height/20;
  pedestrianTextX = width/1.85;
  pedestrianTextY = height/1.06 - height/20;
}
