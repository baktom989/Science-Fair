import processing.serial.*;

import cc.arduino.*;

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;

Robot rob;

Serial myPort;
Arduino arduino;

int x;
int y;

String val;
float xac;

void setup() {
  size(displayWidth, displayHeight);
  background(255);
textSize(20);
fill(0);
  stroke(0);
  

val="";


  
 // println(Arduino.list());
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  String portName = Serial.list()[0];
 


     //arduino = new Arduino(this, Arduino.list()[0], 57600);
 try
  {
    rob = new Robot();
  }
  catch (AWTException e)
  {
    println("AWT Exception");
    exit();
  }     

}

boolean sketchFullScreen(){
return true;
}

void draw() {
background(255);
  
  
  while(myPort.available()>0){
    val = myPort.readString();
  
 
  }
text(val,20,20);

delay(100);
  

}


