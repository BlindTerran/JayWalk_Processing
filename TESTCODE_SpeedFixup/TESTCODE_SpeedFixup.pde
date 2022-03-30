float x, y;

void setup() {
  size(1200, 400);
  x = 0;
  y = 0;
}

void draw() {
  background(150);
  square(x, y, 100);
}

void keyPressed() {
  if (keyPressed) {
    if (key == 's') {
      y+=height/4;
    }
  }
}

void keyReleased() {
  if (key == 's') {
    
  }
}
