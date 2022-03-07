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

size(1200, 400);
line(0, height/4, width, height/4);

fill(#DE4881);
ellipse(width/32+width/27, height/12+height/40, width/25, height/20);                                      //nose cone
fill(150);
quad(width/37, height/10.5, width/32, height/12, width/32, height/12+height/20, width/37, height/8.5);     //blast
quad(width/28, height/18, width/25, height/18, width/20, height/12, width/27, height/12);                  //external control surface(up)
quad(width/28, height/6, width/25, height/6, width/20, height/12+height/20, width/27, height/12+height/20);//external control surface(down)
fill(#518B01);
rectMode(CORNER);
rect(width/32, height/12, width/27, height/20);         
