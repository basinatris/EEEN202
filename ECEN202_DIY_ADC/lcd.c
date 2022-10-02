// LCD display functions

#include "lcd.h"
#define Sfr(x, y)       sfr x = y
#define Sbit(x, y, z)   sbit x = y^z

Sfr(PORT_LCD,0x90); //port 1
Sbit(PIN_RS_LCD,0xA0,0); //Port 2 pin 0 
Sbit(PIN_RW_LCD,0xA0,1); //Port 2 pin 1 
Sbit(PIN_EN_LCD,0xA0,2); //Port 2 pin 2 

// A simple delay to  cycle and kill time
void delay(int cycles){
	int i;
	for(i=0;i<cycles;i++){
		// do nothing
	}
}

void latchLCD(){
	int i;
	PIN_EN_LCD=1;
	for(i=0;i<50;i++){
		// short wait
	}
	PIN_EN_LCD=0;
}

void sendCommand(unsigned char command){
	PIN_RS_LCD=0;
	PIN_RW_LCD=0;
	PORT_LCD = command;
	latchLCD();
}

void clearLCD(){
	sendCommand(0x01); //clear the display
	delay(500);
	sendCommand(0x02); //return the cursor to the start of the display
	
}

void writeCharLCD(char input){
	PORT_LCD = input;
	PIN_RS_LCD = 1;
	PIN_RW_LCD = 0;
	latchLCD();	
}

void writeLineLCD(char *input){
  int i;
  i=0;
	while(input[i] != '\0'){
		writeCharLCD(input[i]);
		i++;
	}
}

void initLCD(){
	PIN_RS_LCD=0;
	PIN_RW_LCD=0;
	PIN_EN_LCD=0;
	sendCommand(0x30); //start
	delay(100);
	sendCommand(0x30); //functionSet 8 bit 1 line
	delay(100);
	sendCommand(0x10); // set cursor no shift, no moving
	delay(100);
	sendCommand(0x0C); //display on, cursor off, blinking off 
	delay(100);
	sendCommand(0x06); //entry mode set 
	delay(100);
}