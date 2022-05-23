//Hongting Su, 47382481
//[√] I declare that I have not seen anyone else's code
//[√] I declare that I haven't shown my code to anyone else.

final int N_LANES = 2;
final int N_CARS_IN_LANE = 10;
final int SPEED_REDUCTION_DISTANCE = 120;
final int MIN_GAP = 50;
final int MAX_LIVES = 3;
final int WIN_SCORE = 3;
final int FRAME_RATE = 60;

float[][] vehicleXpos;
float[] vehicleYpos;
float[][] vehicleVelocity;
float laneGap;
float initialVehicleYpos;
float indentation = 100;
float pedestrianSpeed;
float pedestrianRectX, pedestrianRectY;
float pedestrianTextX, pedestrianTextY;
float acceleration, finalVelocity, initialVelocity;
float AABBwidth, AABBheight, AABBx, AABBy, pedestrianWidth, pedestrianHeight;
int winScore = 0;
int lifeLeft = MAX_LIVES;
boolean isLeft, isRight, upReleased, downReleased;
boolean collided = false;

void setup() {
  size(1200, 400);
  frameRate(FRAME_RATE);
  laneGap = height/12;
  initialVehicleYpos = height/20;
  
  //vehicle position
  vehicleXpos = new float [N_LANES][N_CARS_IN_LANE]; 
  vehicleYpos = new float [N_LANES];  
  vehicleVelocity = new float [N_LANES][N_CARS_IN_LANE];
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
  
  assignXpositions();
  assignYpos();
  assignVelocity();  
  

}

void draw() {
  drawVehicle();
  vehicleUpdate();
  speedReduction();
  vehicleReset();
  drawPedestrian();
  pedestrianUpdate();
  drawLane();
  scoreCalculator();
//  collisionDetection();
  gameOverScene();
  gameWinScene();
}

//2d array Xpositions, Row(i): lane; Colum(k): each vehicle's X position in that lane
void assignXpositions() {
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      if (k == 0) {
        //assign random value between 0 to -50 to the X position of the first vehicle in each lane
        vehicleXpos[i][k] = random(-20) - AABBwidth;
      } else {
        //for the second vehicle onwards, each X position is assgined random value between 10 to 40
        //each X position is less than previous Xpos to avoid overlapping, k-1 is the front vehicle
        vehicleXpos[i][k] = vehicleXpos[i][k-1] - MIN_GAP - AABBwidth - random(70, 300);
      }
    }
  }
}

void assignYpos() {
  for (int i = 0; i < N_LANES; i++) {
    vehicleYpos[i] = initialVehicleYpos;
    initialVehicleYpos += initialVehicleYpos + laneGap;
  }
}

//2d array vehicleVelocity, Row(i): lane; Colum(k): each vehicle's velocity in that lane
void assignVelocity() {
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      //for the first vehicle 
      if (k == 0){
        vehicleVelocity[i][k] = random(3, 5);
      } else {
        vehicleVelocity[i][k] = random(3, 8);
      }
    }
  }
}

void vehicleReset() {
  //i is the counter for lane
  for (int i = 0; i < N_LANES; i++) {
    //if the last vehicle in that lane passes the right screen boundary, <Xpositions[i].length-1>: last vehicle in lane[i]
    if (vehicleXpos[i][vehicleXpos[i].length - 1] > width) {
      
      //regenerate the Xpositions their velocities in that spcific lane
      for (int k = 0; k < N_CARS_IN_LANE; k++) {
        if(k == 0) {
          vehicleXpos[i][k] = random(-20) - AABBwidth;
          vehicleVelocity[i][k] = random(3, 5);
        } else {
          vehicleXpos[i][k] = vehicleXpos[i][k-1] - MIN_GAP - AABBwidth - random(70, 300);
          vehicleVelocity[i][k] = random(3, 8);
        }
      }
    }
  }
}

void drawVehicle() {
  background(150);
  //<Xposition[i][k]>: draw vehicle in lane[i], increment the k to draw next vehicle in that lane
  //increment the i stars to draw vehicles in the next lane
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      //nose cone
      fill(#DE4881);
      ellipse(vehicleXpos[i][k]+width/27, vehicleYpos[i]+height/40, width/25, height/20); 
      //blast
      fill(150);
      quad(vehicleXpos[i][k] - 5*width/1184, vehicleYpos[i]+height/84, vehicleXpos[i][k], vehicleYpos[i], vehicleXpos[i][k], vehicleYpos[i]+height/20, vehicleXpos[i][k] - 5*width/1184, vehicleYpos[i]+7*height/204);           
      //upper surface
      quad(vehicleXpos[i][k]+width/224, vehicleYpos[i]-height/36, vehicleXpos[i][k]+7*width/800, vehicleYpos[i]-height/36, vehicleXpos[i][k]+3*width/160, vehicleYpos[i], vehicleXpos[i][k]+5*width/864, vehicleYpos[i]);       
      //lower surface
      quad(vehicleXpos[i][k]+width/224, vehicleYpos[i]+height/12, vehicleXpos[i][k]+7*width/800, vehicleYpos[i]+height/12, vehicleXpos[i][k]+3*width/160, vehicleYpos[i]+height/20, vehicleXpos[i][k]+5*width/864, vehicleYpos[i]+height/20);  
      //body
      fill(#518B01);
      rect(vehicleXpos[i][k], vehicleYpos[i], width/27, height/20);                                                                                        
    }
  }
}

//assign each vehicle's corresponding velocity to that vehicle
//vehicle moves at a dynamic velocity on one dimension every unit of time
void vehicleUpdate() {
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      vehicleXpos[i][k] = vehicleXpos[i][k] + vehicleVelocity[i][k];
    }
  }
}

void speedReduction() {
  //index i for lane, k for each vehicle in that lane
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      //cease loop when it comes to the last element in that lane
      if (k == vehicleXpos[i].length - 1) {
        break;
      } else {
      
        //when the distance between two vehicles at the same lane less than SPEED_REDUCTION_DISTANCE
        if(abs(vehicleXpos[i][k+1] - vehicleXpos[i][k] + AABBwidth) < SPEED_REDUCTION_DISTANCE) {
        
          //calculate acceleration
          finalVelocity = vehicleVelocity[i][k];
          initialVelocity = vehicleVelocity[i][k+1];
        
          //acceleration = (finalVelocity^2 - initialVelocity^2) / (2 * distance)
          acceleration = (sq(finalVelocity) - sq(initialVelocity)) / (2 * (SPEED_REDUCTION_DISTANCE - MIN_GAP));
        
          //decelerate the vehicle  
          vehicleVelocity[i][k+1] = vehicleVelocity[i][k+1] + acceleration; 
        }
      }
    }
  }
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

//void collisionDetection() {
//  AABBx = vehicleXpos - (width/32-width/37);
//  AABBy = bodyY1 - (height/12 - height/18);
  
//  //in pedestrian's perspective
//  //left to right collisioin
//  if (pedestrianRectX + pedestrianWidth > AABBx
//  //right to left collision
//  && pedestrianRectX < AABBx + AABBwidth 
//  //bottom to top collison
//  && pedestrianRectY + pedestrianHeight > AABBy 
//  //top to bottom collison
//  && pedestrianRectY < AABBy + AABBheight) {
//    collided = true;
//  }
//}

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

void debug() {
  print("Positions: \n");
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      print(vehicleXpos[i][k] + " ");
    }
    print("\n");
  }
  print("Initial Velocity: \n");
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      print(vehicleVelocity[i][k] + " ");
    }
    print("\n");
  }
}
