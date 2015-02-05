int cellSize = 10;// Size of cells
float probabilityOfAliveAtStart = 15;//percentage
float probabilityOfSickAtStart = 1;
float interval;// variable for slider
int lastRecordedTime = 0;
color alive = color(255, 0, 0);// Colors for active/inactive cells
color sick = color(0, 255, 0);
color dead = color(0, 0, 0);
int[][] cell;// Array of cells 
int[][] cellBuffer;// Buffer to record the state of the cells 
boolean pause = false;
int RecX, pauseRecY, resetRecY, clearRecY;// Params for button sizes
int recSizeX = 90;
int recSizeY = 35;
boolean overPause = false;
boolean overReset = false;
boolean overClear = false;
Scrollbar hs1;

void setup() {
  size (800, 500);
  // Instantiate arrays
  cell = new int[600/cellSize][400/cellSize];
  cellBuffer = new int[600/cellSize][400/cellSize];

  // Background grid
  stroke(48);

  noSmooth();

  // Initialization of cells
  for (int x=0; x<600/cellSize; x++) {
    for (int y=0; y<400/cellSize; y++) {
      float state = random (100);
      if (state > probabilityOfAliveAtStart) { 
        state = 0;
      } else {
        state = 1;
      }
      cell[x][y] = int(state); // Save state of each cell
    }
  }
  RecX = 650;
  pauseRecY = 70;
  resetRecY = 120;
  clearRecY = 170;
  
  background(255);// White background
  
  hs1 = new Scrollbar(50, 425, 500, 16, 10);
}

void draw() {
  update(mouseX, mouseY);
  //Grid
  for (int x=0; x<600/cellSize; x++) {
    for (int y=0; y<400/cellSize; y++) {
      if (cell[x][y]==1) {
        fill(alive);
      } else {
        fill(dead);
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  float interval = hs1.getPos();
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // Create  new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, 600, 0, 600/cellSize));
    xCellOver = constrain(xCellOver, 0, 600/cellSize-1);
    int yCellOver = int(map(mouseY, 0, 400, 0, 400/cellSize));
    yCellOver = constrain(yCellOver, 0, 400/cellSize-1);

    // Check against cells in buffer
    if (cellBuffer[xCellOver][yCellOver]==1) {
      cell[xCellOver][yCellOver]=0;
      fill(dead);
    }
    else { // Cell is dead
      cell[xCellOver][yCellOver]=1; // Make alive
      fill(alive); // Fill alive color
    }
  } 
  else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<600/cellSize; x++) {
      for (int y=0; y<400/cellSize; y++) {
        cellBuffer[x][y] = cell[x][y];
      }
    }
  }
  textSize(32);
  if(pause){
    fill(255, 0,0);
  }
  rect(RecX, pauseRecY, recSizeX, recSizeY);
  fill(0, 0, 255);
  text("Pause", 650, 100);
  fill(0);
  rect(RecX, resetRecY, recSizeX, recSizeY);
  fill(0, 0, 255);
  text("Reset", 650, 150);
  fill(0);
  rect(RecX, clearRecY, recSizeX, recSizeY);
  fill(0, 0, 255);
  text("Clear", 650, 200);
  String s = "Move the slider to adjust the interval speed.";
  textSize(20);
  text(s, 100, 475);
  
  hs1.update();
  hs1.display();
}

void iteration() { // When the clock ticks
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<600/cellSize; x++) {
    for (int y=0; y<400/cellSize; y++) {
      cellBuffer[x][y] = cell[x][y];
    }
  }

  // Visit each cell and its neighbours
  for (int x=0; x<600/cellSize; x++) {
    for (int y=0; y<400/cellSize; y++) {
      int neighbours = 0; // We'll count the neighbours
      for (int xx=x-1; xx<=x+1;xx++) {
        for (int yy=y-1; yy<=y+1;yy++) {  
          if (((xx>=0)&&(xx<600/cellSize))&&((yy>=0)&&(yy<400/cellSize))) { // Make sure you are not out of bounds
            if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
              if (cellBuffer[xx][yy]==1){
                neighbours ++; // Check alive neighbours and count them
              }
            }
          }
        }
      }
      // Rule 1 if cell has less then 2 neighbours cell dies from underpopulation
      // Rule 2 if cell has more then 3 neighbours cell dies from overpopulation
      // Rule 3 if cell has 2 or 3 neighbours cell lives
      if (cellBuffer[x][y]==1) {
        if (neighbours < 2 || neighbours > 3) {
          cell[x][y] = 0;
        }
      } 
      else { // Rule 4 if a dead cell has 3 neighbours becomes a live cell      
        if (neighbours == 3 ) {
          cell[x][y] = 1;
        }
      }
    }
  }
}

boolean overRec(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width &&
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void update(int x, int y) {
  if ( overRec(RecX, pauseRecY, recSizeX, recSizeY) ) {
    overPause = true;
    overReset = false;
    overClear = false;
  } else if ( overRec(RecX, resetRecY, recSizeX, recSizeY) ) {
    overReset = true;
    overClear = false;
    overPause = false;
  } else if ( overRec(RecX, clearRecY, recSizeX, recSizeY)) {
    overClear = true;
    overPause = false;
    overReset = false;
  } 
  else {
    overPause = overReset = overClear = false;
  }
}

void mousePressed() {
  if (overPause) {
    pause = !pause;
  }
  if (overReset) {
    for (int x=0; x<600/cellSize; x++) {
      for (int y=0; y<400/cellSize; y++) {
        float state = random (100);
        if (state > probabilityOfAliveAtStart) {
          state = 0;
        }
        else {
          state = 1;
        }
        cell[x][y] = int(state); // Save state of each cell
      }
    }
  }
  if (overClear) {
    for (int x=0; x<600/cellSize; x++) {
      for (int y=0; y<400/cellSize; y++) {
        cell[x][y] = 0; // Save all to zero
      }
    }
  }
}

class Scrollbar {
  int bwidth, bheight;    // width and height of bar
  float xbar, ybar;       //position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean clicked;

  Scrollbar (float xp, float yp, int bw, int bh, int l) {
    bwidth = bw;
    bheight = bh;
    xbar = xp;
    ybar = yp-bheight/2;
    spos = xbar + bwidth/2 - bheight/2;
    newspos = spos;
    sposMin = xbar;
    sposMax = xbar + bwidth - bheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      clicked = true;
    }
    if (!mousePressed) {
      clicked = false;
    }
    if (clicked) {
      newspos = constrain(mouseX-bheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xbar && mouseX < xbar+bwidth &&
       mouseY > ybar && mouseY < ybar+bheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xbar, ybar, bwidth, bheight);
    if (over || clicked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ybar, bheight, bheight);
  }

  float getPos() {
    return 500 - spos;
  }
}
