/* 
 * Arduino Mothbot 
 * 
 * Digital Pin Wiring:  
 *         pin  7 - Pushbutton Signal 
 *         pin 11 - Right Servo Signal 
 *         pin  3 - Left Servo Signal 
 * 
 * License: This work is licenced under the Creative Commons  
 *          Attribution-Share Alike 3.0 Unported License. To  
 *          view a copy of this licence, visit  
 *          http://creativecommons.org/licenses/by-sa/3.0/  
 *          or send a letter to Creative Commons, 171 Second  
 *          Street, Suite 300, San Francisco, California 94105,  
 *          USA.
 */  
 
//------------------------------------------------------------------------
// START OF ARDUINO MOTHBOT SETUP

//--- Library
#include <Servo.h>

//--- Pin Definitions
#define LEFTSERVOPIN  3  //The digital pin that the left servo is connected to
#define RIGHTSERVOPIN 11 //The digital pin that the right servo is connected to
#define PUSHBUTTON 7     //The digital pin that the pushbutton sensor is connected to
#define LED 13           //The LED on the arduino

//--- Servo Setup
Servo leftServo;           
Servo rightServo; 

//--- Speed Setup
int robotSpeed = 75;  //set the speed of the robot
int rightSpeed = 50;
int leftSpeed = 50;

//--- On/Off values
int pushButtonVal = 0;
int old_pushButtonVal = 0;
int pushButtonState = 0;

//--- Delay Threshold
int delayParam = 10;  //Supported Times - 0 - 255 (0 to 25.5 Seconds) value * 100 milliseconds 

// END OF ARDUINO MOTHBOT SETUP
//------------------------------------------------------------------------

//------------------------------------------------------------------------
//START OF ARDUINO MOTHBOT PROGRAM

//--- The program setup
void setup()                  
{  
	Serial.begin(9600);                //Starts the serial port  
	robotSetup();                      //sets the state of all neccesary
                                       //pins and adds servos to your sketch
}

//--- The main program code
void loop()                     
{    
	//--- Get information from the pushbutton sensor  
	pushButtonVal = digitalRead(PUSHBUTTON);

    //--- Set the state of the pushbutton	
	if((pushButtonVal == HIGH) && (old_pushButtonVal == LOW))
	{    
		Serial.println("Button Pushed");    
		pushButtonState = 1 - pushButtonState;    
		delay(10); // Simple de-bouncing   
	}    
		
	//--- Reset the state of the push button  
	old_pushButtonVal = pushButtonVal;  
	
	//--- If pushbutton state HIGH then turn on the robot and   
	//    listen to the light sensor information  
	if(pushButtonState == 1)
	{    
		digitalWrite(LED, HIGH); // turn LED ON      
		Serial.println("Forward");      
		goForward();      
		delay(delayParam * 100);      
		goStop();   
	} 
}

//END OF ARDUINO MOTHBOT PROGRAM
//------------------------------------------------------------------------

//------------------------------------------------------------------------
//START OF ARDUINO MOTHBOT FUNCTIONS

//--- The setup for the robot
void robotSetup()
{  
	//--- Set the speed of the robot  
	setSpeed(robotSpeed);    
	
	//--- Set up the servos  
	pinMode(LEFTSERVOPIN, OUTPUT);     //sets the left servo signal pin
	                                   //to output  
	pinMode(RIGHTSERVOPIN, OUTPUT);    //sets the right servo signal pin
                                       //to output  
	leftServo.attach(LEFTSERVOPIN);    //attaches left servo  
	rightServo.attach(RIGHTSERVOPIN);  //attaches right servo    
	
	//--- Set up the pushbutton  
	pinMode(PUSHBUTTON, INPUT);        //sets the pushbutton sensor pin to input  
	
	//--- Set up the LED to see robot state  
	pinMode(LED, OUTPUT);              //sets the led pin as output  
	
	//--- Tell the robot to stop the servos  
	goStop();
}

//--- Set the speed of the robot between 0-(stopped) and 100-(full speed)
void setSpeed(int newSpeed)
{  
	setSpeedLeft(newSpeed);                   //sets left speed  
	setSpeedRight(newSpeed);                  //sets right speed
}
	
//--- Set the speed of the left wheel
void setSpeedLeft(int newSpeed)
{  
	if(newSpeed >= 100) {newSpeed = 100;}     //if speed is greater than 100
                                              //make it 100  
	if(newSpeed <= 0) {newSpeed = 0;}         //if speed is less than 0 make
                                              //it 0   
	leftSpeed = newSpeed * 0.9;               //between 0 and 90
}

//--- Set the speed of the right wheel
void setSpeedRight(int newSpeed)
{  
	if(newSpeed >= 100) {newSpeed = 100;}     //if speed is greater than 100
                                              //make it 100  
	if(newSpeed <= 0) {newSpeed = 0;}         //if speed is less than 0 make
                                              //it 0   
	rightSpeed = newSpeed * 0.9;              //scales the speed to be 
}

//--- Move the robot forward
void goForward()
{   
	leftServo.write(90 + leftSpeed);    
	rightServo.write(90 - rightSpeed);
}  

//--- Move the robot backward
void goBackward()
{   
	leftServo.write(90 - leftSpeed);   
	rightServo.write(90 + rightSpeed);
}  

//--- Move the robot right
void goRight()
{   
	leftServo.write(90 + leftSpeed);   
	rightServo.write(90 + rightSpeed);
}

//--- Move the robot left
void goLeft()
{   
	leftServo.write(90 - leftSpeed);   
	rightServo.write(90 - rightSpeed);
}

//--- Stop the robot
void goStop()
{   
	leftServo.write(90);   
	rightServo.write(90);
}

//END OF ARDUINO MOTHBOT FUNCTIONS
//------------------------------------------------------------------------

