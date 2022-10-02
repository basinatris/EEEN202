// EEEN202 Staircase ADC*
// Nick Thompson, Robin Dykstra 2018

#include "lcd.h"
#include <stdio.h>
#include <math.h> // library included for pow() function

//Macros
#define Sfr(x, y)       sfr x = y
#define Sbit(x, y, z)   sbit x = y^z

// Pin and Port definitions 
Sfr(PORT_DAC,0x80);  //DAC output port sfr(NAME,ADDR) //Port 0
Sbit(PIN_CMP,0xB0,7); //Comparator input pin sbit(NAME,ADDR,BIT_NUM) // Port 3 pin 7

const float VMAX = 5.75;


// Stair case converter code
unsigned char staircaseConverter(){
	unsigned char test_val;
	for(test_val=1; test_val<256; test_val++){	
		PORT_DAC = test_val; //set the value of the port
		delay(100); // wait for the comparator to stabilise
		if(PIN_CMP){ //check if the comparator is high 
			return test_val;  //return the value if the comparator is high
		}
	}		
	return 0;
}

unsigned char succ(){
	unsigned char test_val = 0;
	unsigned char bit_val;
	PORT_DAC=0xFF; //for scope trigger analysis
	delay(100);
	for (bit_val=128; bit_val>=1; bit_val = bit_val = bit_val/2){ //iterator starts with decimal value of current bit, divides by 2 each iteratin
		test_val+=bit_val; //add value of current bit to test_val
		PORT_DAC=test_val; //set value of port
		delay(100); //wait for comparator
		if (PIN_CMP){test_val-=bit_val;} //if comparator is too high, subtract current bit value from test value
	}
	return test_val;
}

unsigned char bitwiseSucc(){
	unsigned char test_val = 0;
	int bit_val;
	for (bit_val = 7; bit_val >= 0; bit_val--){
		unsigned char mask = 1;
		mask = mask << bit_val;
		mask = mask | test_val;
		PORT_DAC = mask;
		delay(100);
		if (!PIN_CMP){
			test_val = test_val | mask;
		}
	}
	
	return test_val;
}


void main(){
	double adc_value;
	// int adc_value;
	char output_text[16];
	float RESOLUTION = 2*VMAX / (256 -1);
	initLCD();
	while(1){
		adc_value = -VMAX + /*0.039*/RESOLUTION*bitwiseSucc(); //succ();//staircaseConverter();
		//adc_value = bitwiseSucc();
		//sprintf(output_text,"V: %d", adc_value);
		sprintf(output_text,"V: %0.2f", adc_value);
		writeLineLCD(output_text);
		delay(10000);
		clearLCD();
	}
}