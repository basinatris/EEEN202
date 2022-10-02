		
		ORG	0H				// Indicates what address the code starts
		MOV	R0,#20			// Moves decimal 20 into register 0
		MOV	R1,#0			// Set time value = 0, seconds
		MOV	R2,#0			// minutes
		MOV	R3,#0			// hours
		ACALL SETDIS		// initialise the display: Absolute call
		MOV TMOD,#0x01		// Sets timer into mode 1: 16 bit counter

							// resets timer 0 if R0 != 0
REPEAT:	MOV	TH0,#0x3C		// sets upper 8 bits to 0x3C
		MOV	TL0,#0xB0		// sets lower 8 bits to 0xB0
		SETB TR0			// enable timer 0

							// main program loop
WAIT:	JNB TF0,WAIT		// does Timer 0 flag = 1? 
		CLR TR0				// disable timer 0
		CLR TF0				// sets TF0 to 0
     	DJNZ R0,REPEAT		// decrease R0 - is it 0?
		MOV	TH0,#0x3C		// reset TH0
		MOV	TL0,#0xB0		// reset TL0
		SETB TR0			// enable timer 0
		MOV	R0,#20			// reset R0
		CPL P2.3			// output every second
		ACALL DIST			// Display time
		ACALL INCT			// Increment time
		AJMP WAIT			// reset back to top
		

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
		

INCT:	MOV A,R1			//Update time count routine (seconds)
		ADD A, #1
		DA A
		MOV R1, A
		CJNE A, #60H, INCE
		
		MOV R1, #0		//Update time count routine (minute)
		MOV A,R2
		ADD A, #1
		DA A
		MOV R2, A
		CJNE A, #60H, INCE
		
		MOV R2, #0		//Update time count routine
		MOV A,R3
		ADD A, #1
		DA A
		MOV R3, A
		CJNE A, #24H, INCE
		MOV R3, #0
		
INCE:	RET


DIST:	MOV	A,#01     		//Update display routine
		ACALL COMNWRT    	//Reset display
		ACALL DELAY2	

		MOV	A,R3         	// MSD first
		SWAP A				// Swapping upper and lower 8 bits
		ANL A, #0FH			// A && #0FH for the bits
		ORL A, #30H			// A || #30H ""        ""
		ACALL DATAWRT
		ACALL DELAY1		// delay for proper operation
		
		MOV A,R3			
		ANL A, #0FH			// A && #0FH
		ORL A, #30H			// A || #30H
		ACALL DATAWRT    	
		ACALL DELAY1
		
		MOV A, #3AH			// Adding colon to display
		ACALL DATAWRT    	
		ACALL DELAY1
		
		MOV	A,R2
		SWAP A
		ANL A, #0FH         //MSD first
		ORL A, #30H
		ACALL DATAWRT    	
		ACALL DELAY1
		
		MOV A,R2
		ANL A, #0FH         //MSD first
		ORL A, #30H
		ACALL DATAWRT    	
		ACALL DELAY1
		
		MOV A, #3AH
		ACALL DATAWRT    	
		ACALL DELAY1
		
		MOV	A,R1
		SWAP A
		ANL A, #0FH         //MSD first
		ORL A, #30H
		ACALL DATAWRT    	
		ACALL DELAY1
		
		MOV A,R1
		ANL A, #0FH         //MSD first
		ORL A, #30H
		ACALL DATAWRT    	
		ACALL DELAY1   	
		RET 
		


COMNWRT:                   	// reset display
		MOV	P1,A       		
		CLR	P2.0       	
		CLR	P2.1       	
		SETB P2.2       	
		ACALL DELAY1		
		CLR	P2.2       	
		RET



DATAWRT:                   	// writing to display
		MOV	P1,A       	
		SETB P2.0       	
		CLR	P2.1       	
		SETB P2.2       	
		ACALL DELAY1		
		CLR	P2.2       	
		RET



DELAY1:	MOV	R5,#30 			//Short delay
LP1: 	DJNZ R5,LP1		
      	RET
		
DELAY2:	MOV	R5,#50 			//long delay 
HERE2:	MOV	R4,#50	
HERE: 	DJNZ R4,HERE 		
     	DJNZ R5,HERE2
      	RET		
	
		END