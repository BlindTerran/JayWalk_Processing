//Hongting Su, 47382481
//[√] I declare that I have not seen anyone else's code
//[√] I declare that I haven't shown my code to anyone else.

final int N_LANES = 5;
final int N_CARS_IN_LANE = 10;
final int SPEED_REDUCTION_DISTANCE = 120;
final int MIN_GAP = 50;
final int MAX_LIVES = 5;
final int WIN_SCORE = 4;
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
float deceleration, finalVelocity, initialVelocity;
float AABBwidth, AABBheight, AABBx, AABBy, pedestrianWidth, pedestrianHeight;
int winScore = 0;
int lifeLeft = MAX_LIVES;
boolean isLeft, isRight, upReleased, downReleased;
boolean collided = false;

void setup() {
  size(1200, 400);
  frameRate(FRAME_RATE);
  
  //lane property
  laneGap = 4*(height/8)/N_LANES;

  //vehicle position
  vehicleXpos = new float [N_LANES][N_CARS_IN_LANE]; 
  initialVehicleYpos = 4*(height/20)/N_LANES;
  vehicleYpos = new float [N_LANES];  
  vehicleVelocity = new float [N_LANES][N_CARS_IN_LANE];

  //collider porperty
  AABBwidth = 4*(width/27 + width/50)/N_LANES;
  AABBheight = 4*(height/6 - height/18)/N_LANES;
  pedestrianWidth = 4*(width/13.2)/N_LANES;
  pedestrianHeight = 4*(height/9)/N_LANES;
  pedestrianSpeed = 6;                                              
  
  //initialisation 
  assignVehicleXpos();
  assignVhicleYpos();
  assignVehicleVelocity(); 
  assignPedestrianPos();
}

void draw() {
  drawVehicle();
  vehicleUpdate();
  vehicleDeceleration();
//  gauge();
  vehicleReset();
  drawPedestrian();
  pedestrianUpdate();
  drawLane();
  scoreCalculator();
  collisionDetection();
  gameOverScene();
  gameWinScene();
}

//================================================================== INITIALASATION ==========================================================================>>

void assignVehicleXpos() {
  //2d array Xpositions, Row(laneN): index for lane number; Colum(vehicleN): index for vehicle in that lane
  for (int laneN = 0; laneN < N_LANES; laneN++) {
    for (int vehicleN = 0; vehicleN < N_CARS_IN_LANE; vehicleN++) {
      
      //assign random value between 0 to -20 to the X position of the first vehicle on each lane
      if (vehicleN == 0) {
        vehicleXpos[laneN][vehicleN] = random(-20) - AABBwidth;
        
        //for the second vehicle onwards, each vehicle's Xposition is assgined with random value between 50 to 300
        //each Xposition is less than front Xposition to avoid overlapping, vehicleN-1 is the front vehicle
      } else {
        vehicleXpos[laneN][vehicleN] = vehicleXpos[laneN][vehicleN-1] - MIN_GAP - AABBwidth - random(50, 300);
      }
    }
  }
}

void assignVhicleYpos() {
  for (int laneN = 0; laneN < N_LANES; laneN++) {
    vehicleYpos[laneN] = initialVehicleYpos;
    
    //every time lane number increased by one, vehicle Yposition increased by laneGap
    initialVehicleYpos += laneGap;
  }
}

//2d array vehicleVelocity, Row(laneN): index for lane number; Colum(vehicleN): index for vehicle in that lane
void assignVehicleVelocity() {
  for (int laneN = 0; laneN < N_LANES; laneN++) {
    for (int vehicleN = 0; vehicleN < N_CARS_IN_LANE; vehicleN++) {
      
      //velocity for the first vehicle 
      if (vehicleN == 0){
        vehicleVelocity[laneN][vehicleN] = random(3, 5);
      } else {
      
        //veclocity for the second vehicle onwards
        vehicleVelocity[laneN][vehicleN] = random(3, 8);
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
  for (int laneN = 0; laneN < N_LANES; laneN++) {
    //if the last vehicle in that lane passes the right screen boundary, <Xpositions[laneN].length-1>: last vehicle in lane[laneN]
    if (vehicleXpos[laneN][vehicleXpos[laneN].length - 1] > width) {
      
      //regenerate the Xpositions and reassign their velocities in that spcific lane
      for (int vehicleN = 0; vehicleN < N_CARS_IN_LANE; vehicleN++) {
        if(vehicleN == 0) {
          vehicleXpos[laneN][vehicleN] = random(-20) - AABBwidth;
          vehicleVelocity[laneN][vehicleN] = random(3, 5);
        } else {
          vehicleXpos[laneN][vehicleN] = vehicleXpos[laneN][vehicleN-1] - MIN_GAP - AABBwidth - random(70, 300);
          vehicleVelocity[laneN][vehicleN] = random(3, 8);
        }
      }
    }
  }
}

//============================================================= DRAW GAME OBJECTS =========================================================================>>

void drawVehicle() {
  background(150);
  
  //Row(laneN): index for lane number; Colum(vehicleN): index for vehicle in that lane
  for (int laneN = 0; laneN < N_LANES; laneN++) {
    for (int vehicleN = 0; vehicleN < N_CARS_IN_LANE; vehicleN++) {
      strokeWeight(1);
      
      //nose cone
      fill(#DE4881);
      ellipse(vehicleXpos[laneN][vehicleN]+4*(width/27)/N_LANES, vehicleYpos[laneN]+4*(height/40)/N_LANES, 4*(width/25)/N_LANES, 4*(height/20)/N_LANES); 
      
      //blast
      fill(150);
      quad(vehicleXpos[laneN][vehicleN]-4*(5*width/1184)/N_LANES, vehicleYpos[laneN]+4*(height/84)/N_LANES, vehicleXpos[laneN][vehicleN], vehicleYpos[laneN], vehicleXpos[laneN][vehicleN], vehicleYpos[laneN]+4*(height/20)/N_LANES, vehicleXpos[laneN][vehicleN] - 4*(5*width/1184)/N_LANES, vehicleYpos[laneN]+(4*(7*height/204)/N_LANES));           
      
      //upper surface
      quad(vehicleXpos[laneN][vehicleN]+4*(width/224)/N_LANES, vehicleYpos[laneN]-4*(height/36)/N_LANES, vehicleXpos[laneN][vehicleN]+4*(7*width/800)/N_LANES, vehicleYpos[laneN]-4*(height/36)/N_LANES, vehicleXpos[laneN][vehicleN]+4*(3*width/160)/N_LANES, vehicleYpos[laneN], vehicleXpos[laneN][vehicleN]+4*(5*width/864)/N_LANES, vehicleYpos[laneN]);       
      
      //lower surface
      quad(vehicleXpos[laneN][vehicleN]+4*(width/224)/N_LANES, vehicleYpos[laneN]+4*(height/12)/N_LANES, vehicleXpos[laneN][vehicleN]+4*(7*width/800)/N_LANES, vehicleYpos[laneN]+4*(height/12)/N_LANES, vehicleXpos[laneN][vehicleN]+4*(3*width/160)/N_LANES, vehicleYpos[laneN]+4*(height/20)/N_LANES, vehicleXpos[laneN][vehicleN]+4*(5*width/864)/N_LANES, vehicleYpos[laneN]+4*(height/20)/N_LANES);  
      
      //body
      fill(#518B01);
      rect(vehicleXpos[laneN][vehicleN], vehicleYpos[laneN], 4*(width/27)/N_LANES, 4*(height/20)/N_LANES);                                                                                        
    }
  }
}

void drawPedestrian() {  
  fill(#C89DF7);
  stroke(#8A09B2);
  rect(pedestrianRectX, pedestrianRectY, pedestrianWidth, pedestrianHeight);
  fill(0, 408, 612);
  textSize(4*(width/80)/N_LANES);
  text("PEDESTRIAN", pedestrianTextX, pedestrianTextY);
}

void drawLane() {
  for (int laneN = 0; laneN < N_LANES; laneN++) {  
    float dashedLaneGap = width/24;
    boolean dash = true;
    
    //first lane starts at x position 0
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
      line(lineXpos, vehicleYpos[laneN]+(4*height/11)/N_LANES, lineXpos+dashedLaneGap, vehicleYpos[laneN]+(4*height/11)/N_LANES);
    }
  }
}
//============================================================= PHYSICS ENGINE =========================================================================>>

/*
object moving
position + velocity
velocity + acceleration
*/
void vehicleUpdate() {
  for (int laneN = 0; laneN < N_LANES; laneN++) {
    for (int vehicleN = 0; vehicleN < N_CARS_IN_LANE; vehicleN++) {
      vehicleXpos[laneN][vehicleN] = vehicleXpos[laneN][vehicleN] + vehicleVelocity[laneN][vehicleN];
    }
  }
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

void vehicleDeceleration() {
  //Row(laneN): index for lane number; Colum(vehicleN): index for vehicle in that lane
  for (int laneN = 0; laneN < N_LANES; laneN++) {
    for (int vehicleN = 0; vehicleN < N_CARS_IN_LANE; vehicleN++) {
      
      //cease the loop when index comes to the last element in that lane
      if (vehicleN == vehicleXpos[laneN].length - 1) {
        break;
      } else {
        
        //when the distance between two vehicles on the same lane less than SPEED_REDUCTION_DISTANCE
        if(abs(vehicleXpos[laneN][vehicleN+1] - vehicleXpos[laneN][vehicleN] + AABBwidth) < SPEED_REDUCTION_DISTANCE) {      
          
          //deceleration rate
          deceleration = -0.01;        
          
          //decelerate the vehicle  
          vehicleVelocity[laneN][vehicleN+1] = vehicleVelocity[laneN][vehicleN+1] + deceleration; 
          
          //match the front vehicle when distance comes to MIN_GAP
          if(abs(vehicleXpos[laneN][vehicleN+1] - vehicleXpos[laneN][vehicleN] + AABBwidth) <= MIN_GAP) {
            vehicleVelocity[laneN][vehicleN+1] = vehicleVelocity[laneN][vehicleN];
          }          
        }
      }
    }
  }
}

void collisionDetection() {
  for (int laneN = 0; laneN < N_LANES; laneN++) {
    for (int vehicleN = 0; vehicleN < N_CARS_IN_LANE; vehicleN++) {  
      
      //create Axis-Aligned Bounding Box(AABB)
      AABBx = vehicleXpos[laneN][vehicleN] - 4*(width/32-width/37)/N_LANES;
      AABBy = vehicleYpos[laneN] - 4*(height/12 - height/18)/N_LANES;
  
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

//============================================================= GAME CONTROL =========================================================================>>

//pedestrian control
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

//===================================================== GAME ESSENTIAL COMPONENTS ==================================================================>>

//function to calculate the score and life left
void scoreCalculator() {
  
  //if pedestrian successfully cross the finish line (Y=0), increment the score
  if(pedestrianRectY <= 0) {
    winScore++;
    
    //reset the pedestrian when crosssed the finish liine
    assignPedestrianPos();
  }
  
  //if pedestrian collided with vehicle, deduct the life
  if(collided) {
    lifeLeft-= 1;
    collided = false;
    
    //reset the pedestrian when collided
    assignPedestrianPos();
  }
  
  //display the game status bar
  fill(#4171F0);
  textSize(20);
  text("SCORE: " + winScore + "/" + WIN_SCORE + " | " + "LIFE LEFT: " + lifeLeft, width*0.7, height*0.98);
}

void gameOverScene() {  
  
  //display the game over scene when lifeLeft reaches 0
  if (lifeLeft == 0) {
    fill(#D4FA00);
    rect(0, 0, width, height);
    fill(#FA8A21);
    textSize(80);
    text("GAME OVER!", width*0.3, 11*width/60);
    noLoop();
  }
}

void gameWinScene() {
  
  //display game win scene when score reaches WIN_SCORE
  if (winScore == WIN_SCORE) {
    stroke(#8A09B2);
    fill(#92ED99);
    rect(0, 0, width, height);
    fill(#FA8A21);
    textSize(80);
    text("YOU WIN!", width*0.33, 11*width/60);
    noLoop();
  }
}

void gauge() {
  //if vehicles distance comes to SPEED_REDUCTION_DISTANCE, display the guage
  for (int laneN = 0; laneN < N_LANES; laneN++) {
    for (int vehicleN = 0; vehicleN < N_CARS_IN_LANE; vehicleN++) {
      //cease loop when it comes to the last element in that lane
      if (vehicleN == vehicleXpos[laneN].length - 1) {
        break;
      } else { 
        //IF (distance > SRD OR distance < MIN_GAP), do NOT display the gauge
        if(!(abs(vehicleXpos[laneN][vehicleN+1] - vehicleXpos[laneN][vehicleN] + AABBwidth) > SPEED_REDUCTION_DISTANCE || (abs(vehicleXpos[laneN][vehicleN+1] - vehicleXpos[laneN][vehicleN] + AABBwidth)) <= MIN_GAP)) {
          colorMode(HSB); 
          stroke(gaugeColour, 99, 99);
          strokeWeight(3);
          line(vehicleXpos[laneN][vehicleN+1]+AABBwidth, vehicleYpos[laneN]+4*(height/40)/N_LANES, vehicleXpos[laneN][vehicleN] + 4*(width/32 - width/27)/N_LANES, vehicleYpos[laneN]+4*(height/40)/N_LANES);
        
          fill(#47FF00);
          textSize(10);
          float textWidth = textWidth("00");
          text(int(abs(vehicleXpos[laneN][vehicleN+1] - vehicleXpos[laneN][vehicleN] + AABBwidth)), vehicleXpos[laneN][vehicleN+1] + AABBwidth + ((abs(vehicleXpos[laneN][vehicleN+1] - vehicleXpos[laneN][vehicleN] + AABBwidth))/2) - textWidth/2 - 4*(width/200)/N_LANES, vehicleYpos[laneN] + AABBheight/2 + 4*(height/300)/N_LANES);           
          //guage colour 2d for each vehicle 
          
          if(abs(vehicleXpos[laneN][vehicleN+1] - vehicleXpos[laneN][vehicleN] + AABBwidth) <= MIN_GAP) {
            //2d stroke to background colour
          }
        }
      }
    }
  }
} 
