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

int width;
int height;
double xcount;
int counter;
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

   
  Xoutput = "X " + (String)x+" "+millis();
Youtput = "Y " + (String)y+" "+millis();
Zoutput = "Z " + (String)z+" "+millis();
Serial.println(Xoutput + " " + Youtput + " " +  Zoutput + " ");



 
} 
   
void loop() 
{ 
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

