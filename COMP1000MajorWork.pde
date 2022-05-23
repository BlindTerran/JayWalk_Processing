//Hongting Su, 47382481
//[√] I declare that I have not seen anyone else's code
//[√] I declare that I haven't shown my code to anyone else.

final int N_LANES = 2;
final int N_CARS_IN_LANE = 10;
final int MIN_GAP = 50;
final int MAX_LIVES = 3;
final int WIN_SCORE = 3;


float noseX1, noseY1, noseWidth;
float upperSurfaceY1, upperSurfaceY2;
float bodyX1, bodyY1, bodyWidth;
float vehicleSpeed;
float indentation = 100;
float pedestrianSpeed;
float pedestrianRectX, pedestrianRectY;
float pedestrianTextX, pedestrianTextY;
float AABBwidth, AABBheight, AABBx, AABBy, pedestrianWidth, pedestrianHeight;
float distance;
int winScore = 0;
int lifeLeft = MAX_LIVES;
boolean isLeft, isRight, upReleased, downReleased;
boolean collided = false;

void setup() {
  size(1200, 400);
  
  //vehicle position
  bodyX1 = width/32 - indentation; 
  bodyY1 = height/12;
  noseY1 = height/12+height/40;
  upperSurfaceY1 = bodyY1-height/36;
  upperSurfaceY2 = bodyY1;
  
  //pedestrian position
  pedestrianRectX = width/1.85;
  pedestrianRectY = height/1.16 - height/20;
  pedestrianTextX = width/1.85;
  pedestrianTextY = height/1.06 - height/20;
  
  //collider porperty
  AABBwidth = width/27 + width/50;
  AABBheight = height/6 - height/18;
  pedestrianWidth = width/13.2;
  pedestrianHeight = height/7;
}

void draw() {
  drawVehicle();
  vehicleUpdate();
  drawPedestrian();
  pedestrianUpdate();
  drawLane();
  scoreCalculator();
  collisionDetection();
  gameOverScene();
  gameWinScene();
}

void drawVehicle() {
  background(150);
  //nose cone
  fill(#DE4881);
  ellipse(bodyX1+width/27, bodyY1+height/40, width/25, height/20); 
  //blast
  fill(150);
  quad(bodyX1 - 5*width/1184, bodyY1+height/84, bodyX1, bodyY1, bodyX1, bodyY1+height/20, bodyX1 - 5*width/1184, bodyY1+7*height/204);           
  //upper surface
  quad(bodyX1+width/224, bodyY1-height/36, bodyX1+7*width/800, bodyY1-height/36, bodyX1+3*width/160, bodyY1, bodyX1+5*width/864, bodyY1);       
  //lower surface
  quad(bodyX1+width/224, bodyY1+height/12, bodyX1+7*width/800, bodyY1+height/12, bodyX1+3*width/160, bodyY1+height/20, bodyX1+5*width/864,  bodyY1+height/20);  
  //body
  fill(#518B01);
  rect(bodyX1, bodyY1, width/27, height/20);                                                                                        

  //reset the vehicle if it goes byond the right boundary
  if (bodyX1 - 5*width/1184 > width) {
    bodyX1 = width/32 - indentation;
  }
}

//function to update vehicle position
void vehicleUpdate() {
  //speed of vehicle
  vehicleSpeed = 2;                                            

  bodyX1 += vehicleSpeed;
}

//function to draw dashed lane
void drawLane() {
    float dashedLaneGap = width/24;
    boolean dash = true;
    //first line starts at x position 0
    //as long as line x position is within the screen width, draw dashed line
    //draw black line and then background colour line
    for (int lineXpos = 0; lineXpos <= width; lineXpos += dashedLaneGap) {
    if(dash){
      stroke(0);
      dash = false;
    } else {
      stroke(150);
      dash = true;
    }
    line(lineXpos, height/4, lineXpos+dashedLaneGap, height/4);
  }
}

//function to display the pedestrian 
void drawPedestrian() {
  //speed of pedestrian
  pedestrianSpeed = 3;                                              
  
  rect(pedestrianRectX, pedestrianRectY, width/13.2, height/7);
  fill(0, 408, 612);
  textSize(width/80);
  text("PEDESTRIAN", pedestrianTextX, pedestrianTextY);
}

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

void collisionDetection() {
  AABBx = bodyX1 - (width/32-width/37);
  AABBy = bodyY1 - (height/12 - height/18);
  
  //in pedestrian's perspective
  //left to right collisioin
  if (pedestrianRectX + pedestrianWidth > AABBx
  //right to left collision
  && pedestrianRectX < AABBx + AABBwidth 
  //bottom to top collison
  && pedestrianRectY + pedestrianHeight > AABBy 
  //top to bottom collison
  && pedestrianRectY < AABBy + AABBheight) {
    collided = true;
  }
}

//function to calculate the score and life 
void scoreCalculator() {
  if(pedestrianRectY < 0) {
    winScore++;
    
    //reset the pedestrian when crosssed the lane
    pedestrianReset();
  }
  if(collided) {
    lifeLeft-= 1;
    collided = false;
    
    //reset the pedestrian when collided
    pedestrianReset();
  }
  
  text("SCORE: "+winScore+" | "+"LIFE LEFT: "+lifeLeft, width*0.7, height*0.98);
}

//function to display game over scene when lifeLeft reaches 0
void gameOverScene() {  
  if (lifeLeft == 0) {
    fill(#D4FA00);
    rect(0, 0, width, height);
    fill(#FA8A21);
    textSize(80);
    text("GAME OVER!", width*0.3, 11*width/60);
    
    noLoop();
  }
}

//function to display game win scene when score reaches WIN_SCORE
void gameWinScene() {
  if (winScore == WIN_SCORE) {
    fill(#92ED99);
    rect(0, 0, width, height);
    fill(#FA8A21);
    textSize(80);
    text("YOU WIN!", width*0.33, 11*width/60);
  }
}

void pedestrianReset() {
  pedestrianRectX = width/1.85;
  pedestrianRectY = height/1.16 - height/20;
  pedestrianTextX = width/1.85;
  pedestrianTextY = height/1.06 - height/20;
}
