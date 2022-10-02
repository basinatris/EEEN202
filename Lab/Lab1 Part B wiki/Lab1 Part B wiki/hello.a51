		ORG	0H
		MOV	A,#38H		
		ACALL	COMNWRT    	
		ACALL	DELAY      	
		MOV	A,#0EH     	
		ACALL	COMNWRT		
		ACALL	DELAY		
		MOV	A,#01     	
		ACALL	COMNWRT    	
		ACALL	DELAY		
		MOV	A,#06H     	
		ACALL	COMNWRT    	
		ACALL	DELAY			
		MOV	A,#'H'     	
		ACALL	DATAWRT    	
		ACALL	DELAY
		MOV	A,#'E'     	
		ACALL	DATAWRT    	
		ACALL	DELAY
		MOV	A,#'L'     	
		ACALL	DATAWRT    	
		ACALL	DELAY
		MOV	A,#'L'     	
		ACALL	DATAWRT    	
		ACALL	DELAY			
		MOV	A,#'O'     	
		ACALL	DATAWRT  		
AGAIN:	SJMP	AGAIN      	
COMNWRT:                   	
		MOV	P1,A       	
		CLR	P2.0       	
		CLR	P2.1       	
		SETB	P2.2       	
		ACALL	DELAY		
		CLR	P2.2       	
		RET
DATAWRT:                   	
		MOV	P1,A       	
		SETB	P2.0       	
		CLR	P2.1       	
		SETB	P2.2       	
		ACALL	DELAY		
		CLR	P2.2       	
		RET

DELAY:	MOV	R3,#50 		
HERE2:	MOV	R4,#255		
HERE: 	DJNZ	R4,HERE 		
     	DJNZ	R3,HERE2
      	RET
	
		END