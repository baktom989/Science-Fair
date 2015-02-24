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
float xacc, yacc, zacc;
int xpos;
int ypos;
int count;

void setup() {
size(700,500);
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
count=1;
xpos=displayWidth/2;
ypos=displayHeight/2;

println(Serial.list());
String portName = Serial.list()[5];
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
//start the mouse at the middle of the screen  
rob.mouseMove(displayWidth/2,displayHeight/2);

//Callibration in the beginning
callibrate();

}

void draw() {
//resets the screen to white every time
background(255);

  
while(myPort.available()>0)
{
 val = myPort.readString();
 println(val);
 if(val.indexOf("stationary")>-1){
xacc=0;
yacc=0;
}
} //while loop ends here

if(val.indexOf("stationary")==-1){
 String[] out = val.split(" ");
if(out.length>1)
 {
  if(out.length>3)
   {
    xacc=Float.parseFloat(out[1]);
    yacc=Float.parseFloat(out[3]); 
   }
else if(out.length==2)
  {
    if(out[0].equals("Xout"))
    {xacc=Float.parseFloat(out[1]);}
    
    if(out[0].equals("Yout"))
    {yacc=Float.parseFloat(out[1]);}
  }

}
}

if(xacc!=0){
xpos+=xacc*10;
ypos+=yacc*10;
} 


text("xacc "+xacc,20,20);
text("yacc "+yacc,20,40);
rob.mouseMove(xpos,ypos);
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
  myPort.write("callibrate");
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

  




