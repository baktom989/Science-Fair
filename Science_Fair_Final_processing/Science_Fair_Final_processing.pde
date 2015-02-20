import processing.serial.*;
import cc.arduino.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.util.Scanner;
import com.getflourish.stt.*;
import ddf.minim.*;

//Global Variables
Robot rob;
Serial myPort;
Arduino arduino;
STT stt;
String voiceinput;
String val;
String xaccel;
String xtime;
String xsavedtime;

int xpos;
int ypos;
void setup() {
size(200,200);
background(255);
textSize(20);
fill(0);
stroke(0);
  
//global variables initialization
val=" ";
xaccel="0";
xtime="0";
xsavedtime="0";
xpos=displayWidth/2;
ypos=displayHeight/2;
String portName = Serial.list()[0];
myPort = new Serial(this, portName, 115200);

//voice recognition initialization 
/*stt = new STT(this);
stt.enableDebug();
stt.setLanguage("en");
stt.setThreshold(100);
*/
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
if((val.charAt(0)=='X' || val.charAt(0) == 'Y' || val.charAt(0) == 'Z')&& val.indexOf(" ")>-1){    

if(val.charAt(0)=='X'){
  String[] accandtime = val.split(" ");
xsavedtime = xtime;
if(accandtime.length==3){
xaccel= accandtime[1];
xtime = accandtime[2];
}


text(xaccel,20,20);
text(xtime,20,40);
text(xsavedtime,20,60);

double t1 = Double.parseDouble(xtime);
double t2 = Double.parseDouble(xsavedtime);
double deltat = (t1-t2) * 0.001;
float acc = Float.parseFloat(xaccel);

double output = getDistance(acc,deltat)*1000;
println(output);

xpos+=(int)output;
rob.mouseMove(xpos,ypos);
delay(100);
}


}
}  

double getDistance(float acclerationvalue, double time){
  double distance = 0.5*acclerationvalue*(time*time);
  return distance;
}

/*void transcribe (String word, float confidence) 
{
  voiceinput = word;
  println(voiceinput);
  if(voiceinput.equals("callibrate")){
  callibrate(); 
  }
}
*/

public void callibrate(){
xpos=displayWidth/2;
ypos=displayHeight/2;
}

public void keyPressed() {
callibrate();
}



