#include <Wire.h> 

byte Version[3];
int8_t x_data;
int8_t y_data;
int8_t z_data;
byte range=0x00;
float divi=16;
float x,y,z;
float xoutput, youtput, zoutput;
String Xoutput;
String Youtput;
String Zoutput;
float xoffset, yoffset, zoffset;

int width;
int height;
int cnt;
double xcount;
int counter;
float xtime;
void setup() 
{ 
  xoutput=0;
  youtput=0;
  zoutput=0;
  Serial.begin(115200); 
  Wire.begin(); 
  Wire.beginTransmission(0x0A); // address of the accelerometer 
  // range settings
  Wire.write(0x22); 
  Wire.write(range); 
  // low pass filter  
  Wire.write(0x20); 
  Wire.write(0x05); 
  Wire.endTransmission();
  
  Xoutput="";
  Youtput="";
  Zoutput="";
  counter=0;
  xcount=0;
  xtime=0;
  cnt=0;
  
  callibrate();
 

} 
   
void AccelerometerInit() 
{ 
  Wire.beginTransmission(0x0A); // address of the accelerometer 
  // reset the accelerometer 
  Wire.write(0x04); // Y data
  Wire.endTransmission(); 
  Wire.requestFrom(0x0A,1);    
  while(Wire.available())    
  { 
    Version[0] = Wire.read(); 
  }  
  x_data=(int8_t)Version[0]>>2;
   
  Wire.beginTransmission(0x0A); // address of the accelerometer 
  // reset the accelerometer 
  Wire.write(0x06); // Y data
  Wire.endTransmission(); 
  Wire.requestFrom(0x0A,1);   
  while(Wire.available())    
  { 
    Version[1] = Wire.read(); 
  }  
  y_data=(int8_t)Version[1]>>2;
    
  Wire.beginTransmission(0x0A); // address of the accelerometer 
  // reset the accelerometer 
  Wire.write(0x08); // Y data
  Wire.endTransmission(); 
  Wire.requestFrom(0x0A,1);   
   while(Wire.available())    
  { 
    Version[2] = Wire.read();
  }  
   z_data=(int8_t)Version[2]>>2; 
    
   x=(float)x_data/divi; 
   y=(float)y_data/divi;
   z=(float)z_data/divi;

x=x-xoffset;
y=y-yoffset;
z=z-zoffset;

      
    double xoutput = getDistance(x,(millis()-xtime)*0.05);
   double youtput = getDistance(y,(millis()-xtime)*0.05);
   xtime=millis();  


if(z>-0.1 && z<0.1 && cnt>0)
 {
   if((xoutput>1 || xoutput<-1) && (youtput>1 || youtput<-1)){
   Serial.println("Xout " + (String)xoutput + " Yout " + (String)youtput);
   }
   else if(xoutput>1 || xoutput<-1)
   {
    Serial.println("Xout " + (String)xoutput);
   }
   
   else if(youtput>1 || youtput<-1)
   {
    Serial.println("Yout " + (String)youtput);
   }  
   else{Serial.println("stationary");}
 
 }
 else{Serial.println("stationary");}

 cnt=1; 
} 
   
void callibrate(){
  int count=0;
  while(count<1000){
 Wire.beginTransmission(0x0A); // address of the accelerometer 
  // reset the accelerometer 
  Wire.write(0x04); // Y data
  Wire.endTransmission(); 
  Wire.requestFrom(0x0A,1);    
  while(Wire.available())    
  { 
    Version[0] = Wire.read(); 
  }  
  x_data=(int8_t)Version[0]>>2;
   
  Wire.beginTransmission(0x0A); // address of the accelerometer 
  // reset the accelerometer 
  Wire.write(0x06); // Y data
  Wire.endTransmission(); 
  Wire.requestFrom(0x0A,1);   
  while(Wire.available())    
  { 
    Version[1] = Wire.read(); 
  }  
  y_data=(int8_t)Version[1]>>2;
    
  Wire.beginTransmission(0x0A); // address of the accelerometer 
  // reset the accelerometer 
  Wire.write(0x08); // Y data
  Wire.endTransmission(); 
  Wire.requestFrom(0x0A,1);   
   while(Wire.available())    
  { 
    Version[2] = Wire.read();
  }  
   z_data=(int8_t)Version[2]>>2; 
    
   x=(float)x_data/divi; 
   y=(float)y_data/divi;
   z=(float)z_data/divi;

xoffset=xoffset+x;
yoffset=yoffset+y;
zoffset=zoffset+z;
count++;  
}
xoffset=xoffset/count;
yoffset=yoffset/count;
zoffset=zoffset/count;

String hey = (String)xoffset + " " +(String) yoffset + " " +(String)zoffset;
Serial.println(hey);
cnt=0;
   
}   

double getDistance(float acclerationvalue, double time){
  double distance = 0.5*acclerationvalue*(time*time);
  return distance;
}
   
void loop() 
{ 
while(Serial.available()>0){
String calval = Serial.readString();
 if(calval.equals("callibrate"))
  {
   callibrate(); 
 }
 }
 
  switch(range)  //range of the accleerometer
  {
  case 0x00:divi=16;  break;
  case 0x01:divi=8;  break;
  case 0x02:divi=4;  break;
  case 0x03:divi=2;  break;
  default: Serial.println("range error");
  
  }

  AccelerometerInit();
  delay(100);
  
} 

