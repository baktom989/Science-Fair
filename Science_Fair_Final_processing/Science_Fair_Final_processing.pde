import processing.serial.*;
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
STT stt;
String voiceinput;
String val;
String xaccel, xtime, xsavedtime;
String yaccel, ytime, ysavedtime;
String zaccel, ztime, zsavedtime;
float xoffset, yoffset;

int xpos;
int ypos;
void setup() {
size(500,500);
background(255);
textSize(20);
fill(0);
stroke(0);
  
//global variables initialization
val=" ";
xaccel="0";
xtime="0";
xsavedtime="0";
yaccel="0";
ytime="0";
ysavedtime="0";
zaccel="0";
ztime="0";
zsavedtime="0";
xpos=displayWidth/2;
ypos=displayHeight/2;
println(Serial.list());
String portName = Serial.list()[4];
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
if(val.charAt(0)=='X' && val.indexOf('Y')>-1 && val.indexOf('Z')> -1&& val.indexOf(" ")>-1){    

  String[] accandtime = val.split(" ");
xsavedtime = xtime;
ysavedtime = ytime;

if(accandtime.length>8){
xaccel= accandtime[1];
xtime = accandtime[2];
yaccel=accandtime[4];
ytime=accandtime[5];
}



text("xaccel "+ xaccel,20,20);
text("x time " +xtime,20,40);
text("x savedtime " + xsavedtime,20,60);
text("yaccel "+ yaccel,20,80);
text("y time " +ytime,20,100);
text("y savedtime " + ysavedtime,20,120);

double t1 = Double.parseDouble(xtime);
double t2 = Double.parseDouble(xsavedtime);
double xdeltat = (t1-t2) * 0.001;
float xacc = Float.parseFloat(xaccel);

double t3 = Double.parseDouble(ytime);
double t4 = Double.parseDouble(ysavedtime);
double ydeltat = (t3-t4) * 0.001;
float yacc = Float.parseFloat(yaccel);

double xoutput = getDistance(xacc,xdeltat)*1000;
text("Xoutput " + xoutput,200,20);
if(xoutput>1){
xpos+=(int)xoutput;
}

double youtput = getDistance(yacc,ydeltat)*1000;
text("Youtput " + youtput,200,80);
if(youtput>1){
ypos+=(int)youtput;
}
rob.mouseMove(xpos,ypos);
delay(100);


}
delay(100);
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
  String a,b;
  a="";b="";
for(int i=0;i<1000;i++){
while(myPort.available()>0)
  {
    val = myPort.readString();
  }
  
  if(val.charAt(0)=='X' && val.indexOf('Y')>-1 && val.indexOf('Z')> -1&& val.indexOf(" ")>-1){    

  String[] accandtime = val.split(" ");


if(accandtime.length>8){
a= accandtime[1]; 
b= accandtime[4];

}

xoffset=xoffset+Float.parseFloat(a);
yoffset=yoffset+Float.parseFloat(b);
}
}
xoffset=xoffset/1000;
yoffset=yoffset/1000;
println(xoffset);
println(yoffset);
}

public void keyPressed(){
  if(key=='k'){
 xpos=displayWidth/2;
 ypos=displayHeight/2;
  }
  else{
callibrate();
}
}

  




