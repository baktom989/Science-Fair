import processing.serial.*;
import cc.arduino.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.util.Scanner;

//Global Variables
Robot rob;
Serial myPort;
Arduino arduino;

String val;
String accel;
String time;
String savedtime;

int xpos;
int ypos;
void setup() {
size(200,200);
background(255);
textSize(20);
fill(0);
stroke(0);
  
//global variables initialization
val="";
accel="0";
time="0";
savedtime="0";
xpos=0;
ypos=0;
String portName = Serial.list()[0];
myPort = new Serial(this, portName, 115200);
 
 try
  {
    rob = new Robot();
  }
  catch (AWTException e)
  {
    println("AWT Exception");
    exit();
  }     
  
  
//mouse begins at the middle of the screen  
rob.mouseMove(displayWidth/2,displayHeight/2);

}

boolean sketchFullScreen(){
return false;
}

void draw() {
background(255);
  
  
  while(myPort.available()>0)
  {
    val = myPort.readString();
  }
    
String[] accandtime = val.split(" ");
savedtime = time;
if(accandtime.length==2){
accel= accandtime[0];
time = accandtime[1];
}


text(accel,20,20);
text(time,20,40);
text(savedtime,20,60);

double t1 = Double.parseDouble(time);
double t2 = Double.parseDouble(savedtime);
double deltat = (t1-t2) * 0.001;
float acc = Float.parseFloat(accel);

double output = getDistance(acc,deltat)*1000;
println(output);

xpos+=(int)output;
rob.mouseMove(xpos,mouseY);
delay(100);


}

double getDistance(float acclerationvalue, double time){
  double distance = 0.5*acclerationvalue*(time*time);
  return distance;
}



