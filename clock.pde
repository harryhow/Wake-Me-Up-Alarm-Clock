//import spacebrew.*;

//String server="sandbox.spacebrew.cc";
String server="localhost";
//String server="54.200.90.9";
String name="wake_me_up_clock";
String description ="please don't change this, thanks!";
////
//Spacebrew spacebrewConnection;

int num = 12;
int radiusKreis = 140;
 
int s = 0;
int m = 0;
int h = 0;
int min, hour;

boolean locked = true;

int x = 0;
int y = 0;

int offsetX= 0;
int offsetY= 0;

PFont f;

// Variable to store text currently being typed
String typing = "";

// Variable to store saved text when return is hit
String saved = "";
String status = "";

boolean isSaved = false;
boolean isConfirm = false;
int i;

int inputStatus = -1;
int NO_INPUT = 99;


void setup() {
  size(600,600);
  
  //spacebrewConnection = new Spacebrew( this );
  
   // add each thing you publish to
//  spacebrewConnection.addPublish("Alarm", "string");
//  spacebrewConnection.addSubscribe("AlarmTimeConfirm", "string");
// 

  // add each thing you subscribe to
  //spacebrewConnection.addSubscribe( "color", "range" );
  
  // connect!
  //spacebrewConnection.connect(server, name, description );
  
  i = 255;
  rectMode(CENTER);
  f = createFont("Arial",16,true);
  
 
}
 
void draw() {
  
  pushMatrix(); 
  background(255);
  
  translate(width/2, height/2);
  //translate(20, 70);
  for(int i = 0; i < num; i++) {
    pushMatrix();  
      rotate(TWO_PI / num * i);
      translate(0, radiusKreis);
      rect(0,0,10,10);
    popMatrix();
  }
    
//  s = second();
//  m = minute();
//  h = hour();

  var now = new Date();
  s = now.getSeconds();
  m = now.getMinutes();
  h = now.getHours();
   
  strokeWeight(4);
 
  pushMatrix();
     rotate(TWO_PI / 60 * s);
     stroke(color(255, 0, 0));
     //fill();
     line(0,0,0, -110);
  popMatrix();
  
  // reset strock color to black
  stroke(color(0, 0, 0));
           
  pushMatrix();
    rotate(TWO_PI / 60 * m);
    line(0,0,0, -80);
  popMatrix();
    
  pushMatrix();
    rotate(TWO_PI / 12 * h);
    strokeWeight(8);
    line(0,0,0, -50);
  popMatrix();
  
  int indent = 25;
  // Set the font and fill for text
  textFont(f);
  fill(0);

  popMatrix();
 // black box under
  strokeWeight(1);
  fill(0, 0, 0, 128);
//  rect(300, 500, 150, 50);
  fill(0);
  
  //fill(153, 128);
  //rect(10, 500, 10, 10);
  // Display everything
  //textAlign(CENTER);
  textSize(14); 
  //fill(0, 102, 153, 51);
  //text("CLICK   to set 4-digit time (2311 = 11:11 pm) \nENTER to setup for me", 10, 580);
  
  textSize(18);
  text(typing,indent+260, 510);
  //text(saved,indent,130);
  fill(0);    
  //noFill();
  if (inputStatus == NO_INPUT){
    status = "Please enter time for your friend...";
    text(status,indent,120);
  }
      
  if (isConfirm){
      status = "Sweet, I will wake up at";
      //status = status + " " + saved + "...";
      status = status + " " + hour + ":" + min + " "+"under your commend ...";
      text(status,indent,50);
      //isConfirm = false;
  }
  
 

    // reset strock color to black
    //stroke(color(0, 0, 0));
   
  
}

void keyPressed() {
  // If the return key is pressed, save the String and clear it
  
  // debug msg
  //println("typing " + int(key) + " " + keyCode);
    
  if (keyCode == ENTER || keyCode == RETURN) {
    
    if (typing == null) {
      inputStatus = NO_INPUT;
    }
    else{
      saved = typing;
      isSaved = true;
      // A String can be cleared by setting it equal to ""
      typing = "";
      spacebrewConnection.send("Alarm", saved);
    }
  }
  else if (keyCode == BACKSPACE || keyCode == DELETE) {
    typing = typing.substring(0, typing.length() - 1);}
  else if (key != CODED){
    // Otherwise, concatenate the String
    // Each character typed by the user is added to the end of the String variable.
    if (key == 58 || (key <= 57 && key >= 48)){
      // TODO: limit four digit here
      typing = typing + str(key); 
    }
  }
  
  //if (key != CODED) typing += key;
}


void onStringMessage( String name, String value ){
  //println("[CLOCK] Got string message "+name +" : "+ value);
  
  //  must use try & catch if the string is invalid
  try {
    int[] time = int(split(value, ":"));
    //println("hour:"+list[0]+" "+"min:"+ list[1]);
    hour = time[0];
    min = time[1];
    
    if (min >= 0 && min <=59){
        if (hour >= 0 && hour <=23){
          println("[CLOCK] Set alarm to HOUR:"+hour+" "+"MIN:"+ min);
          isConfirm = true;
        }
        else {
            hour = -1;
            min = -1;
        }
    }else{
      min = -1;
      hour = -1;
    }
      
  }catch( Exception e ){
    println("[CLOCK] Oops...error input string");
  }
}

void onRangeMessage( String name, int value ){
  println("[CLOCK] got int message "+name +" : "+ nf(value,0));
}

void onBooleanMessage( String name, boolean value ){
  println("got bool message "+name +" : "+ value);  
}



