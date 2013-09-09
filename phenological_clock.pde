import processing.pdf.*;


String[] months = {
  "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
};
BufferedReader reader;
BufferedReader reader2;
String line;
PShape cross;
int MAX_LINES = 100;
int monthsStartx = 1400;
int monthsStarty = 80;
int currentIndex = 0;

void setup() {
  size(2100, 2000, PDF, "clock.pdf");
  background(255);
  smooth();
  // Open the file from the createWriter() example
  reader = createReader("data.csv");
  cross = loadShape("cross.svg");
  shapeMode(CENTER);
  strokeCap(SQUARE);
  ellipseMode(CENTER);
  PFont f = loadFont("Futura-Medium-48.vlw");
  textFont(f);
}


void draw() {

  pushMatrix();
  translate(width/2-400, height/2-200);
  rotate(-PI/2);
  //  scale(1.5);
//  drawLine(new PVector(0, 0), 0, 600);

  for (int k=0; k<MAX_LINES; k++) {
    try {
      line = reader.readLine();
    } 
    catch (IOException e) {
      e.printStackTrace();
      line = null;
      exit();
    }

    if (line == null) {
      noLoop();
    } 
    else {
   pushMatrix()   ;
   scale(2);
      shape(cross, 0, 0);
      popMatrix();

      String[] pieces = split(line, ",");
      String name = pieces[0];

      int start = int(pieces[1])-1;
      int end = int(pieces[2]);
      color c = unhex("FF"+pieces[3]);    

      noStroke();
//      fill(0,random(150, 250),0, random(2, 5));
//      fill(0,random(150, 250),0);
      drawArc(new PVector(0, 0), currentIndex*22, 0, TWO_PI);
      noFill();
      stroke(c);
      strokeWeight(10);

      float startTheta = map(start, 0, 12, 0, TWO_PI);
      float endTheta = map(end, 0, 12, 0, TWO_PI);
      drawArc(new PVector(0, 0), currentIndex*22, startTheta, endTheta);

      currentIndex++;
    }
  }
  drawCircleMonths();
//  drawRain();
  popMatrix();

  drawMonths();




  PImage title = loadImage("title.png");
  title.resize(650, 0);
  image(title, 0, 0);

exit();
}
void drawLine(PVector start, float angle, float len) {
  strokeWeight(0);
  stroke(255, 0, 0);
  line(start.x, start.y, start.x+(cos(angle)*len), start.y+(sin(angle)*len));
}


void drawArc(PVector center, float size, float startAngle, float stopAngle) {
  arc(center.x, center.y, size, size, startAngle, stopAngle);
}


void drawCircleMonths() {
  float t = -TWO_PI/12;
  //  rotate(-PI/2);
  for (int i=0; i<months.length; i++) {    
    t+= (TWO_PI/12);
    fill(0);
    textSize(12);
    text(months[i], (cos(t)*500), (sin(t)*500));
//    drawLine(new PVector(0, 0), t, 500);
  }
}

void drawMonths() {
  currentIndex = 0;
  reader = createReader("data.csv");

  for (int k=0; k<MAX_LINES; k++) {  
    try {
      line = reader.readLine();
    } 
    catch (IOException e) {
      e.printStackTrace();
      line = null;
      exit();
    }

    if (line == null) {
      noLoop();
    } 
    else {    
      String[] pieces = split(line, ",");
      String name = pieces[0];

      int start = int(pieces[1])-1;
      color c = unhex("FF"+pieces[3]);
      noStroke();      
      fill(c);
      ellipse(monthsStartx+(35*start), monthsStarty+40+(currentIndex*30), 20, 20);
      fill(0);
      textSize(12);
      text(name, monthsStartx+15+(35*start), monthsStarty+43+(currentIndex*30));
      currentIndex++;
    }
  }

  for (int i=0; i<months.length; i++) {
    pushMatrix();
    translate(monthsStartx+(i*35), monthsStarty);
    fill(0);
    rotate(-PI/2);
    text(months[i], 0, 0);
    popMatrix();
  }
}


