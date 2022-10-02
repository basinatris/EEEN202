

void delay(int cycles);// A simple delay to cycle and kill time
void latchLCD();
void sendCommand(unsigned char command);
void clearLCD();
void writeCharLCD(char input);
void writeLineLCD(char *input);
void initLCD();