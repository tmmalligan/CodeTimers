/*
 * Week 12: Code Timers 
 * 
 * by Taylor Malligan
 */
 

import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
String [] data;

int switchValue = 0;
int potValue = 0;
int ldrValue = 0;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 2;

// display text
PFont drawFont;
int hMargin = 120;

// timing for serial data
Timer photoTimer; //initial timer
Timer keyTimer; //if key pressed timer

int serialCheckTime = 20;    // every ms, during our loop, we check it

float timePerLine = 0;
float minTimePerLine = 150;
float maxTimePerLine = 1000;
int defaultTimerPerLine = 1500;

// mapping pot values
float minPotValue = 0;
float maxPotValue = 4095;

// mapping LDR values
float minLDRValue = 0;
float maxLDRValue = 4095;

float minFreq = 300;
float maxFreq = 800;


// two-state state machine
int state;
int stateStatic = 1;
int stateRose = 2;
int stateTulip = 3;
int stateHydrangea = 4;
int statePeony = 5;

//// oscillator
//boolean bOscillatorOn = false;

//Images
PImage img;
PImage imageList [];
void setup ( ) {
  size (1000,  1000);    
  
  textAlign(CENTER);
  drawFont = createFont("SignPainter", 32);
 
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "/dev/cu.SLAB_USBtoUART",  115200); 
  
  
  //// Allocate the timer
  photoTimer = new Timer(defaultTimerPerLine);
  keyTimer = new Timer(defaultTimerPerLine);
  //snareRollTimer = new Timer(snareRollTime);
  //snareRollTimer.start();
  
  //serialCheckTimer = new Timer(serialCheckTime);
  //serialCheckTimer.start();
  
  
  state = stateStatic;
  
  // Load all the images
  imageList = new PImage[5];
  imageList[0]= loadImage("rose.jpg");   
  imageList[1]= loadImage("tulip.jpg");   
  imageList[2]= loadImage("hydrangea.jpg");  
  imageList[3]= loadImage("peony.jpg");   
  
  
  
} 


// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have THREE items — ERROR-CHECK HERE
   if( data.length >= 2 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
      ldrValue = int(data[2]);               // third index = LDR value
      
      // change the display timer
      timePerLine = map( potValue, minPotValue, maxPotValue, minTimePerLine, maxTimePerLine );
      keyTimer.setTimer( int(timePerLine));
      
    
   }
  }
} 

//-- change background to red if we have a button
void draw ( ) {  
  if (photoTimer.expired()){
    
  checkSerial();
  photoTimer.start();
    //(startTimer.expired() ){
    //state++;
    //if(state==6){
    //  state = 1;
    }
    drawBackground();
  
  if (state == stateStatic){
    redraw();
    startingState();
    state = stateRose;
   }
   else if(state == stateRose){
     rose();
     state = stateTulip;
   }
   else if(state == stateTulip){
     tulip();
     state = stateHydrangea;
   }
    else if(state == stateHydrangea){
     tulip();
     state = statePeony;
   }
   else if(state == statePeony){
     peony();
   }
   else{
     startingState();
   }
}
    
    

// if input value is 1 (from ESP32, indicating a button has been pressed), change the background
void drawBackground() {
    background(255,182,193); 
}

void startingState(){
  background(255,182,193); 
   fill(255,254,252); 
   textSize(100);
   text(" Welcome to Taylor's Garden! ",500, 500); // rose facts
}



void rose(){
 if(photoTimer.expired()){
   fill(255,254,252); 
   textSize(50);
   text("Roses",120,500); //header
   
   fill(255,254,252); 
   textSize(35);
   text("Facts",300, 500); // rose facts
   
   
   fill(255,254,252); 
   textSize(35);
   text("The world's oldest living rose is believed to be 1,000 years old.",350,450);
   text("There are over three hundred species and thousands of cultivars of roses.",380,450);
   text("There are no black roses.",400,450);
   
   img = imageList[0];
  
 }
}

void tulip(){
 if(photoTimer.expired()){
   fill(255,254,252); 
   textSize(50);
   text("Tulips",120,500); //header
   
   fill(255,254,252); 
   textSize(35);
   text("Facts",300, 500); // facts
   
   
   fill(255,254,252); 
   textSize(35);
   text("The word tulip is derived from a Persian word called delband, which means turban.",350,450);
   text("There are over 150 species of tulips with over 3,000 different varieties.",380,450);
   text("Some species of tulips live for 10-20 years. ",400,450);
   
   img = imageList[1];
  
 }
}

void hydrangea(){
 if(photoTimer.expired()){
   fill(255,254,252); 
   textSize(50);
   text("Hydrangea",120,500); //header
   
   fill(255,254,252); 
   textSize(35);
   text("Facts",300, 500); // facts
   
   
   fill(255,254,252); 
   textSize(35);
   text("Hydrangeas are one of very few plants that accumulate aluminium.",350,450);
   text("Pink hydrangeas symbolize heartfelt emotion.",380,450);
   text("Most are shrubs 1 to 3 meters tall, but some are small trees, and others lianas reaching up to 30 m by climbing up trees. ",400,450);
   
   img = imageList[2];
 
 }
}

void peony(){
 if(photoTimer.expired()){
   fill(255,254,252); 
   textSize(50);
   text("Peony",120,500); //header
   
   fill(255,254,252); 
   textSize(35);
   text("Facts",300, 500); // peony facts
   
   
   fill(255,254,252); 
   textSize(35);
   text("The current consensus is 33 known species for peonies.",350,450);
   text("A peony represents wealth and honor. ",380,450);
   text("They are the 12th wedding anniversary flower.",400,450);
   
   img = imageList[3];
 
 }
}

//-- look at current value of the timer and change it
void checkTimer() {
  //-- if timer is expired, go to next  the line number
  if(photoTimer.expired() ) {
    state++;
    
     keyTimer.start(); 
  }
}
