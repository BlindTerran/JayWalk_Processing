//Hongting Su, 47382481
//[√] I declare that I have not seen anyone else's code
//[√] I declare that I haven't shown my code to anyone else.

final int N_LANES = 3;
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
float gaugeColour = 90;
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
  laneGap = 4*(height/8) / N_LANES;
  initialVehicleYpos = 4*(height/20) / N_LANES;
  
  //vehicle position
  vehicleXpos = new float [N_LANES][N_CARS_IN_LANE]; 
  vehicleYpos = new float [N_LANES];  
  vehicleVelocity = new float [N_LANES][N_CARS_IN_LANE];
  //pedestrian position

  
  //collider porperty
  AABBwidth = width/27 + width/50;
  AABBheight = 4*(height/6 - height/18)/N_LANES;
  pedestrianWidth = width/13.2;
  pedestrianHeight = height/7;
  
  assignVehicleXpos();
  assignVhicleYpos();
  assignVehicleVelocity(); 
  assignPedestrianPos();
  debug();
}

void draw() {
  drawVehicle();
  vehicleUpdate();
  speedReduction();
  gauge();
  vehicleReset();
  drawPedestrian();
  pedestrianUpdate();
  drawLane();
  scoreCalculator();
  collisionDetection();
  gameOverScene();
  gameWinScene();
}

//2d array Xpositions, Row(i): lane; Colum(k): each vehicle's X position in that lane
void assignVehicleXpos() {
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      if (k == 0) {
        //assign random value between 0 to -50 to the X position of the first vehicle in each lane
        vehicleXpos[i][k] = random(-20) - AABBwidth;
      } else {
        //for the second vehicle onwards, each X position is assgined random value between 10 to 40
        //each X position is less than previous Xpos to avoid overlapping, k-1 is the front vehicle
        vehicleXpos[i][k] = vehicleXpos[i][k-1] - MIN_GAP - AABBwidth - random(50, 300);
      }
    }
  }
}

void assignVhicleYpos() {
  for (int i = 0; i < N_LANES; i++) {
    vehicleYpos[i] = initialVehicleYpos;
    initialVehicleYpos += laneGap;
  }
}

//2d array vehicleVelocity, Row(i): lane; Colum(k): each vehicle's velocity in that lane
void assignVehicleVelocity() {
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      //velocity for the first vehicle 
      if (k == 0){
        vehicleVelocity[i][k] = random(3, 5);
      } else {
        //veclocity for the second vehicle onwards
        vehicleVelocity[i][k] = random(3, 8);
      }
    }
  }
}

void assignPedestrianPos() {
  pedestrianRectX = width/1.85;
  pedestrianRectY = height - laneGap + (height/11)/N_LANES;
  pedestrianTextX = width/1.85;
  pedestrianTextY = height - laneGap + (height/3)/N_LANES;
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
      strokeWeight(1);
      //nose cone
      fill(#DE4881);
      ellipse(vehicleXpos[i][k]+width/27, vehicleYpos[i]+4*(height/40)/N_LANES, width/25, 4*(height/20)/N_LANES); 
      //blast
      fill(150);
      quad(vehicleXpos[i][k] - 5*width/1184, vehicleYpos[i]+4*(height/84)/N_LANES, vehicleXpos[i][k], vehicleYpos[i], vehicleXpos[i][k], vehicleYpos[i]+4*(height/20)/N_LANES, vehicleXpos[i][k] - 5*width/1184, vehicleYpos[i]+(4*(7*height/204)/N_LANES));           
      //upper surface
      quad(vehicleXpos[i][k]+width/224, vehicleYpos[i]-4*(height/36)/N_LANES, vehicleXpos[i][k]+7*width/800, vehicleYpos[i]-4*(height/36)/N_LANES, vehicleXpos[i][k]+3*width/160, vehicleYpos[i], vehicleXpos[i][k]+5*width/864, vehicleYpos[i]);       
      //lower surface
      quad(vehicleXpos[i][k]+width/224, vehicleYpos[i]+4*(height/12)/N_LANES, vehicleXpos[i][k]+7*width/800, vehicleYpos[i]+4*(height/12)/N_LANES, vehicleXpos[i][k]+3*width/160, vehicleYpos[i]+4*(height/20)/N_LANES, vehicleXpos[i][k]+5*width/864, vehicleYpos[i]+4*(height/20)/N_LANES);  
      //body
      fill(#518B01);
      rect(vehicleXpos[i][k], vehicleYpos[i], width/27, 4*(height/20)/N_LANES);                                                                                        
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
          
          
          acceleration = 0.01;
             
          //decelerate the vehicle  
          vehicleVelocity[i][k+1] = vehicleVelocity[i][k+1] - acceleration; 
          
          if(abs(vehicleXpos[i][k+1] - vehicleXpos[i][k] + AABBwidth) <= MIN_GAP) {
            vehicleVelocity[i][k+1] = vehicleVelocity[i][k];
          }          
        }
      }
    }
  }
}

//function to draw dashed lane
void drawLane() {
  for (int i = 0; i < N_LANES; i++) {  
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
      strokeWeight(1);
      line(lineXpos, vehicleYpos[i]+(4*height/11)/N_LANES, lineXpos+dashedLaneGap, vehicleYpos[i]+(4*height/11)/N_LANES);
    }
  }
}

//function to display the pedestrian 
void drawPedestrian() {
  //speed of pedestrian
  pedestrianSpeed = 4;                                              
  
  fill(#C89DF7);
  stroke(#8A09B2);
  rect(pedestrianRectX, pedestrianRectY, width/13.2, laneGap-(height/10)/N_LANES);
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
    pedestrianRectY -= laneGap;
    pedestrianTextY -= laneGap;
  }
  if (key == 'S' || key == 's') {
    pedestrianRectY += laneGap;
    pedestrianTextY += laneGap;
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
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {  
      AABBx = vehicleXpos[i][k] - (width/32-width/37);
      AABBy = vehicleYpos[i] - 4*(height/12 - height/18)/N_LANES;
  
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
  }
}

//function to calculate the score and life 
void scoreCalculator() {
  if(pedestrianRectY < 0) {
    winScore++;
    
    //reset the pedestrian when crosssed the lane
    assignPedestrianPos();
  }
  if(collided) {
    lifeLeft-= 1;
    collided = false;
    
    //reset the pedestrian when collided
    assignPedestrianPos();
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
    stroke(#8A09B2);
    fill(#92ED99);
    rect(0, 0, width, height);
    fill(#FA8A21);
    textSize(80);
    text("YOU WIN!", width*0.33, 11*width/60);
  }
}

void gauge() {
  //if vehicles distance comes to SPEED_REDUCTION_DISTANCE, display the guage
  for (int i = 0; i < N_LANES; i++) {
    for (int k = 0; k < N_CARS_IN_LANE; k++) {
      //cease loop when it comes to the last element in that lane
      if (k == vehicleXpos[i].length - 1) {
        break;
      } else { 
        //IF (distance > SRD OR distance < MIN_GAP), do NOT display the gauge
        if(!(abs(vehicleXpos[i][k+1] - vehicleXpos[i][k] + AABBwidth) > SPEED_REDUCTION_DISTANCE || (abs(vehicleXpos[i][k+1] - vehicleXpos[i][k] + AABBwidth)) <= MIN_GAP)) {
          colorMode(HSB); 
          stroke(gaugeColour, 99, 99);
          strokeWeight(3);
          line(vehicleXpos[i][k+1]+AABBwidth, vehicleYpos[i]+4*(height/40)/N_LANES, vehicleXpos[i][k] + (width/32 - width/27), vehicleYpos[i]+4*(height/40)/N_LANES);
        
          fill(#47FF00);
          textSize(10);
          float textWidth = textWidth("00");
          text(int(abs(vehicleXpos[i][k+1] - vehicleXpos[i][k] + AABBwidth)), vehicleXpos[i][k+1] + AABBwidth + ((abs(vehicleXpos[i][k+1] - vehicleXpos[i][k] + AABBwidth))/2) - textWidth/2 - width/200, vehicleYpos[i] + AABBheight/2 + 4*(height/300)/N_LANES);           
          //guage colour 2d for each vehicle 
          
          if(abs(vehicleXpos[i][k+1] - vehicleXpos[i][k] + AABBwidth) <= MIN_GAP) {
            //2d stroke to background colour
          }
        }
      }
    }
  }
} 

void debug() {
  for (int i = 0; i < N_LANES; i++) {
    print(vehicleYpos[i] + "|");
  }
}
