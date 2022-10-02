		ORG	0H
		LJMP MAIN			//bypass interrupt vector table	
		
		ORG 			// Timer-Counter o interrupt vector
		LJMP TINT			// Jump to Timer counter interrupt routine
			
		ORG 30H	
MAIN:	MOV	R0,#20
		MOV	R1,#0			//Set time value = 0, seconds
		MOV	R2,#0			//minutes
		MOV	R3,#0			//hours
		ACALL SETDIS		//initialise the display
		MOV TMOD,#0x01		//initialise counter-timer 0 
		MOV	TH0,#0x3C
		MOV	TL0,#0xB0
		;SETB ?			//Enable timer 0 interrupt (your task)
		SETB TR0			//Start timer
DISPL:	ACALL DIST			//Display time
		ACALL	DELAY3
		AJMP DISPL
		
SETDIS: MOV	A,#30H			//Display initialisation routine
		ACALL	COMNWRT    	
		ACALL	DELAY1      	
		MOV	A,#0CH     	
		ACALL	COMNWRT		
		ACALL	DELAY1		
		MOV	A,#01     	
		ACALL	COMNWRT    	
		ACALL	DELAY2		
		MOV	A,#06H     	
		ACALL	COMNWRT    	
		ACALL	DELAY1		
		RET
		
DIST:	MOV	A,#01     		//Update display routine
		ACALL	COMNWRT    	//Reset display
		ACALL	DELAY2		
		MOV	A,R3   			//MSD
		SWAP A
		ANL A,#0FH
		ORL A,#30H
		ACALL	DATAWRT    	
		ACALL	DELAY1  
		MOV	A,R3   			
		ANL A,#0FH
		ORL A,#30H
		ACALL	DATAWRT    	
		ACALL	DELAY1
		MOV	A,#3AH     	
		ACALL	DATAWRT    	
		ACALL	DELAY1
		MOV	A,R2   			
		SWAP A
		ANL A,#0FH
		ORL A,#30H
		ACALL	DATAWRT    	
		ACALL	DELAY1  
		MOV	A,R2   			
		ANL A,#0FH
		ORL A,#30H
		ACALL	DATAWRT
		MOV	A,#3AH     	
		ACALL	DATAWRT    	
		ACALL	DELAY1
		MOV	A,R1   			
		SWAP A
		ANL A,#0FH
		ORL A,#30H
		ACALL	DATAWRT    	
		ACALL	DELAY1  
		MOV	A,R1   			
		ANL A,#0FH
		ORL A,#30H  	
		ACALL	DATAWRT
		RET
		
INCT:	MOV A,R1			//Update time count routine
		ADD A,#1			//Increment seconds
		DA A
		MOV R1,A
		CJNE A,#60H,INCE	//60 seconds ?
		MOV R1,#0
		MOV A,R2			//Increment minutes
		ADD A,#1			
		DA A
		MOV R2,A
		CJNE A,#60H,INCE	//60 minutes ?
		MOV R2,#0
		MOV A,R3			//Increment hours
		ADD A,#1			
		DA A
		MOV R3,A
		CJNE A,#24H,INCE	//24 hours ?
		MOV R3,#0
INCE:	RET
		
                   	
COMNWRT:
		MOV	P1,A       	
		CLR	P2.0       	
		CLR	P2.1       	
		SETB	P2.2       	
		ACALL	DELAY1		
		CLR	P2.2       	
		RET
		
DATAWRT:                   	
		MOV	P1,A       	
		SETB	P2.0       	
		CLR	P2.1       	
		SETB	P2.2       	
		ACALL	DELAY1		
		CLR	P2.2       	
		RET

DELAY1:	MOV	R5,#30 			//Short delay
LP1: 	DJNZ	R5,LP1		
      	RET
		
DELAY2:	MOV	R5,#50 			//long delay 
HERE2:	MOV	R4,#50	
HERE: 	DJNZ	R4,HERE 		
     	DJNZ	R5,HERE2
      	RET	
		
DELAY3:	MOV	R5,#250 		//extra long delay 
HERE4:	MOV	R4,#250	
HERE3: 	DJNZ	R4,HERE3 		
     	DJNZ	R5,HERE4
      	RET	

TINT:	CLR TF0				//Timer - counter interrupt service rountine ISR
		
	(your code here)	
		
TINTE:	RETI

		END