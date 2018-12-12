/*
	LCD_Display Demo
	07.06.18, ASt
	
	Dieses Programm realisiert mit dem IMS RISC-V Softcore 
	eine Ausgabe auf einem LCD-Display des Digilent Genesys boards.
	
	Im Linker-Script link.ld sind zwei Adressen definiert, 
	an denen in der Verilog-Beschreibung Register hängen, die 
	ihrerseits mit dem Control-Register des LCD-Displays verbunden sind. 
	
	Aus dem C-Code heraus können diese "besonderen" Adressen 
	angesprochen werden, indem sie als "extern" variablen definiert 
	werden, anschließend kann man an die Adresse der Variable schreiben 
	und die Daten landen im entsprechenden Register. 
	
	Das LCD-Display braucht eine Einschaltsequenz, die in einer 
	Funktion init_lcd gekapselt ist. 
		
	
*/

extern int _lcd;
extern int _hdmi;

void swait(void)
{
//	for(int i = 0; i < 60000; i++);	
}

void lwait(void)
{
/*	for(int i = 0; i < 65000; i++);
	for(int i = 0; i < 65000; i++);
	for(int i = 0; i < 65000; i++);
	for(int i = 0; i < 65000; i++);
	for(int i = 0; i < 65000; i++);
	for(int i = 0; i < 65000; i++);
	for(int i = 0; i < 65000; i++);
	for(int i = 0; i < 65000; i++);
	for(int i = 0; i < 65000; i++);
	for(int i = 0; i < 65000; i++);	*/
}


void init_lcd(void) {
	swait();
	_lcd = 0b00100011000;
	swait();
	_lcd = 0b00000011000;
	swait();
	_lcd = 0b00100001110;
	swait();	
	_lcd = 0b00000001110;
	swait();		
	_lcd = 0b00100000001;
	swait();	
	_lcd = 0b00000000001;
	swait();		
	_lcd = 0b00100000110;
	swait();	
	_lcd = 0b00000000110;
	swait();
}

void clear_lcd(void) {
	swait();
	_lcd = 0b00100000001;
	swait();
	_lcd = 0b00000000001;

}

void __putc(char c)
{
	int temp;
	temp = 0b10100000000 + c;
	swait();
	_lcd = temp;
	temp = 0b10000000000 + c;
	swait();	
	_lcd = temp;
}


void __println(char* message)
{
	char* temp; 
	temp = message;
	while((*temp) != '\0') 
		{
			__putc((*temp));
			temp = temp + sizeof(char);
		}
}

int modint(int num, int div)
{
	int temp;
	temp = 0;
	while(num > div)
		{
			num -= div;
			temp++;
		}
	return(num);
}

int divint(int num, int div)
{
	int temp;
	temp = 0;
	while(num > div)
		{
			num -= div;
			temp++;
		}
	return(temp);
}

/*void __printint(int num)
{
	int temp;
	char digit;	
	temp = num;	
		
	while(temp >= 10)
		{
			digit = modint(temp,10);
			digit += 48;	// digits start at d48 in ascii table
			__putc(digit);
			bufferptr += sizeof(char);
			temp = divint(temp,10);
		}
	temp += 48;
	__putc(temp);
}*/

void hdmi_1(void) {
	_hdmi = 0x00000002;	// SCL = 0, SDA = 1
	swait();
	_hdmi = 0x00000003; // SCL = 1, SDA = 1
	swait();
	_hdmi = 0x00000002; // SCL = 0, SDA = 1
	swait();
}

void hdmi_0(void) {
	_hdmi = 0x00000000;	// SCL = 0, SDA = 0
	swait();
	_hdmi = 0x00000001; // SCL = 1, SDA = 0
	swait();
	_hdmi = 0x00000000; // SCL = 0, SDA = 0
	swait();
}

void hdmi_0s(void) {
	_hdmi = 0x00000000;	// SCL = 0, SDA = 0
	swait();
	_hdmi = 0x00000001; // SCL = 1, SDA = 0
	swait();
	_hdmi = 0x00000003; // SCL = 0, SDA = 0
	swait();
}

void hdmi_write_i2c(char addr, char data)
{

	// AS is connected to ground.
	
	_hdmi = 0x00000003;	// SCL = 1, SDA = 1
	swait();
	_hdmi = 0x00000001; // SCL = 1, SDA = 0 -> START
	swait();
	_hdmi = 0x00000000; // SCL = 1, SDA = 1 -> STOP
	swait();
	_hdmi = 0x00000003;	// SCL = 1, SDA = 1
	swait();
	_hdmi = 0x00000001; // SCL = 1, SDA = 0 -> START
	swait();
	_hdmi = 0x00000000; // SCL = 0, SDA = 0

	// Device Address Byte (DAB)
	hdmi_1();
	hdmi_1();
	hdmi_1();
	hdmi_0();
	hdmi_1();
	hdmi_1();	//  ~AS = 1
	hdmi_0();	// AS = 0
	hdmi_0();	// write
	
	// ACK (we overwrite device response...)
	hdmi_0();
	
	// Register Address Byte (RAB)
	// ADDR = 49h
	for(int i = 7; i >= 0; i--)
		if(((addr >> i) & 0x01) == 1)
			hdmi_1();
		else
			hdmi_0();
	// ACK
	hdmi_0();
	
	// DATA
	// 11xxxxx0 means DVI in normal function
	for(int i = 7; i >= 0; i--)
		if(((data >> i) & 0x01) == 1)
			hdmi_1();
		else
			hdmi_0();
			
	// ACK and STOP
	hdmi_0s();
}


void init_hdmi(void) {
			hdmi_write_i2c(0x49,0xC0);
			hdmi_write_i2c(0x21,0x09);
			hdmi_write_i2c(0x33,0x08);
			hdmi_write_i2c(0x34,0x16);
			hdmi_write_i2c(0x36,0x60);			
}

void main()
{
	lwait();
	init_lcd();
	init_hdmi();
	while(1){
	// RS,RW,E,DB<7:0>	
	clear_lcd();
	__println("Hallo du Schoene! \0");	
	lwait();
	lwait();
	lwait();
	clear_lcd();
	__println("Der ProoVessor\0");
	lwait();
	lwait();
	lwait();
	lwait();
	clear_lcd();
	__println("hat ein Auge auf\0");
	lwait();
	lwait();
	lwait();	
	clear_lcd();
 	__println("dich geworfen!\0");
	lwait();		
	lwait();
	lwait();
	};
}