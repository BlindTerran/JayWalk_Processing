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

float noseX1, noseY1, noseWidth;
float blastX1, blastX2, blastX3, blastX4;
float upperSurfaceX1, upperSurfaceX2, upperSurfaceX3, upperSurfaceX4;
float lowerSurfaceX1, lowerSurfaceX2, lowerSurfaceX3, lowerSurfaceX4;
float bodyX1, bodyWidth;
float vehicleSpeed;
float pedestrianSpeed;
float pedestrianRectX, pedestrianRectY;
float pedestrianTextX, pedestrianTextY;
float distance;
boolean isLeft, isRight, upReleased, downReleased;
boolean collided = false;


void setup() {
  size(1200, 400);
  noseX1 = (width/32+width/27) - width/10;
  noseY1 = height/12+height/40;
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

void draw() {
  vehicle();
  pedestrian();
  lane();
  collisionDetection();
}

//function to display the vehicle
void vehicle() {
  //speed of vehicle
  vehicleSpeed = 1;                                            

  noseX1 += vehicleSpeed;
  blastX1 += vehicleSpeed; 
  blastX2 += vehicleSpeed;
  blastX3 += vehicleSpeed;
  blastX4 += vehicleSpeed;
  upperSurfaceX1 += vehicleSpeed;
  upperSurfaceX2 += vehicleSpeed;
  upperSurfaceX3 += vehicleSpeed;
  upperSurfaceX4 += vehicleSpeed;
  lowerSurfaceX1 += vehicleSpeed;
  lowerSurfaceX2 += vehicleSpeed;
  lowerSurfaceX3 += vehicleSpeed;
  lowerSurfaceX4 += vehicleSpeed;
  bodyX1 += vehicleSpeed;

  background(150);
  fill(#DE4881);
  ellipse(noseX1, noseY1, width/25, height/20);                                                                                        //nose cone
  fill(150);
  quad(blastX1, height/10.5, blastX2, height/12, blastX3, height/12+height/20, blastX4, height/8.5);                                   //blast
  quad(upperSurfaceX1, height/18, upperSurfaceX2, height/18, upperSurfaceX3, height/12, upperSurfaceX4, height/12);                    //upper surface
  quad(lowerSurfaceX1, height/6, lowerSurfaceX2, height/6, lowerSurfaceX3, height/12+height/20, lowerSurfaceX4, height/12+height/20);  //lower surface
  fill(#518B01);
  rect(bodyX1, height/12, width/27, height/20);                                                                                        //body

  //reset the vehicle when it goes byond the right boundary
  if (blastX4 > width) {
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
  if (isLeft) {
    pedestrianRectX-= pedestrianSpeed;
    pedestrianTextX-= pedestrianSpeed;
  }
  if (isRight) {
    pedestrianRectX+= pedestrianSpeed;
    pedestrianTextX+= pedestrianSpeed;
  }
}

//function to control the pedestrian
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
}

//function to control the pedestrian
void keyReleased() {
  if (key == 'A' || key == 'a') {
    isLeft = false;
  }
  if (key == 'D' || key == 'd') {
    isRight = false;
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

//function to detect collision
void collisionDetection() {
  float vehicleTop, vehicleWidth, vehicleHeight, pedestrianWidth, pedestrianHeight;
  noseWidth = width/25;
  bodyWidth = width/27;

  vehicleWidth = blastX2 - blastX1 + bodyWidth + noseWidth/2;
  vehicleHeight = height/6 - height/18;
  vehicleTop = height/18;
  pedestrianWidth = width/13.2;
  pedestrianHeight = height/7;

  if (pedestrianRectX + pedestrianWidth > blastX1 && pedestrianRectX < blastX1 + vehicleWidth && pedestrianRectY + pedestrianHeight > vehicleTop && pedestrianRectY < vehicleTop + vehicleHeight) {
    collided = true;
  }

  if (collided) {
    fill(#D4FA00);
    rect(0, 0, width, height);
    fill(#FA8A21);
    textSize(80);
    text("GAME OVER!", width*0.3, 11*width/60);

    noLoop();
  }
}
