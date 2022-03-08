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

void setup() {
  
  size(1200, 400);
  n1 = width/32+width/27;
  b1 = width/37;
  b2 = width/32;
  b3 = width/32;
  b4 = width/37;
  eu1 = width/28;
  eu2 = width/25;
  eu3 = width/20;
  eu4 = width/27;
  ed1 = width/28;
  ed2 = width/25;
  ed3 = width/20;
  ed4 = width/27;
  bd = width/32;
  
  line(0, height/4, width, height/4);
  
}

void draw() {
  
  vehicle();

}

void vehicle() {

  n1 = n1 + 1;
  b1 = b1 + 1; 
  b2 = b2 + 1;
  b3 = b3 + 1;
  b4 = b4 + 1;
  eu1 = eu1 + 1;
  eu2 = eu2 + 1;
  eu3 = eu3 + 1;
  eu4 = eu4 + 1;
  ed1 = ed1 + 1;
  ed2 = ed2 + 1;
  ed3 = ed3 + 1;
  ed4 = ed4 + 1;
  bd = bd + 1;
  
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
