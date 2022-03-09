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

float n1;
float b1;
float b2;
float b3;
float b4;
float eu1;
float eu2;
float eu3;
float eu4;
float ed1;
float ed2;
float ed3;
float ed4;
float bd;
float s;

void setup() {
  
  size(1200, 400);
  n1 = width/32+width/27 - 120;
  b1 = width/37 - 120;
  b2 = width/32 - 120;
  b3 = width/32 - 120;
  b4 = width/37 - 120;
  eu1 = width/28 - 120;
  eu2 = width/25 - 120;
  eu3 = width/20 - 120;
  eu4 = width/27 - 120;
  ed1 = width/28 - 120;
  ed2 = width/25 - 120;
  ed3 = width/20 - 120;
  ed4 = width/27 - 120;
  bd = width/32 - 120;
  
}

void draw() {
  
  vehicle();
  lane();

}

void vehicle() {
  
  s = 1;                                                                                  //speed of vehicle
  
  n1 = n1 + s;
  b1 = b1 + s; 
  b2 = b2 + s;
  b3 = b3 + s;
  b4 = b4 + s;
  eu1 = eu1 + s;
  eu2 = eu2 + s;
  eu3 = eu3 + s;
  eu4 = eu4 + s;
  ed1 = ed1 + s;
  ed2 = ed2 + s;
  ed3 = ed3 + s;
  ed4 = ed4 + s;
  bd = bd + s;
  
  background(150);
  fill(#DE4881);
  ellipse(n1, height/12+height/40, width/25, height/20);                                   //nose cone
  fill(150);
  quad(b1, height/10.5, b2, height/12, b3, height/12+height/20, b4, height/8.5);           //blast
  quad(eu1, height/18, eu2, height/18, eu3, height/12, eu4, height/12);                    //external control surface(up)
  quad(ed1, height/6, ed2, height/6, ed3, height/12+height/20, ed4, height/12+height/20);  //external control surface(down)
  fill(#518B01);
  rectMode(CORNER);
  rect(bd, height/12, width/27, height/20);                                                //body
 
}


void lane(){
  
    line(0, height/4, width, height/4);
    
}
