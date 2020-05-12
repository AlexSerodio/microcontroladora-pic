// Lcd pinout settings
sbit LCD_RS at RE0_bit;
sbit LCD_EN at RE1_bit;

sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

// Pin direction
sbit LCD_RS_Direction at TRISE0_bit;
sbit LCD_EN_Direction at TRISE1_bit;

sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

unsigned int AD;        //0..1023
char TXT[7];
unsigned short Temperatura;

int hhh, mmm, sss;
int critic_hhh, critic_mmm;

char ENTER[2] = {13,0};

char ENTRADA[33]; //32 para o dado entrado + reserva do NULL

int temp;
char _char;


/* Interrupção */
int cnt = 0;
int cnt2 = 0;

void InitTimer2_Int0(){
	T2CON = 0x3C;
	TMR2IE_bit = 1;
	PR2 = 249;
	INTCON = 0xD0;  //INTCON = 1100 0000 (HABILITA TMR2 INTERRUPT E INT0 INTERRUPT)
}

void interrupt() {
	if(int0if_bit) {
		cnt2++;
		// esse if não seria mais necessário
		if(cnt2>4){
			cnt2=0;
			PORTA.F2 = ~PORTA.F2;
		}
		int0if_bit=0;   // clear int0if_bit
    }

	if (TMR2IF_bit) {
		cnt++;
		if (cnt >= 1000) {
			PORTA.F1 = ~PORTA.F1;
			cnt = 0;
		}
		TMR2IF_bit = 0;        // clear TMR2IF
	}
}


short Le_Teclado() {
	PORTD = 0B00010000; // VOCÊ SELECIONOU LA
	if (PORTA.RA5 == 1) {
		while(PORTA.RA5 == 1);
		return '7';
	}
	if (PORTB.RB1 == 1) {
		while(PORTB.RB1 == 1);
		return '8';
	}
	if (PORTB.RB2 == 1) {
		while(PORTB.RB2 == 1);
		return '9';
	}
	if (PORTB.RB3 == 1) {
		while(PORTB.RB3 == 1);
		return '%';
	}

	PORTD = 0B00100000; // VOCÊ SELECIONOU LB
	if (PORTA.RA5 == 1) {
		while(PORTA.RA5 == 1);
		return '4';
	}
	if (PORTB.RB1 == 1) {
		while(PORTB.RB1 == 1);
		return '5';
	}
	if (PORTB.RB2 == 1) {
		while(PORTB.RB2 == 1);
		return '6';
	}
	if (PORTB.RB3 == 1) {
		while(PORTB.RB3 == 1);
		return '*';
	}

	PORTD = 0B01000000; // VOCÊ SELECIONOU LC
	if (PORTA.RA5 == 1) {
		while(PORTA.RA5 == 1);
		return '1';
	}
	if (PORTB.RB1 == 1) {
		while(PORTB.RB1 == 1);
		return '2';
	}
	if (PORTB.RB2 == 1) {
		while(PORTB.RB2 == 1);
		return '3';
	}
	if (PORTB.RB3 == 1) {
		while(PORTB.RB3 == 1);
		return '-';
	}

	PORTD = 0B10000000; // VOCÊ SELECIONOU LD
	if (PORTA.RA5 == 1) {
		while(PORTA.RA5 == 1);
		return 'C';
	}
	if (PORTB.RB1 == 1) {
		while(PORTB.RB1 == 1);
		return '0';
	}
	if (PORTB.RB2 == 1) {
		while(PORTB.RB2 == 1);
		return '=';
	}
	if (PORTB.RB3 == 1) {
		while(PORTB.RB3 == 1);
		return '+';
	}

	return 255;
}

void Pula_Linha(void) {
	UART1_WRITE(13);
	UART1_WRITE(10);
}

void Move_Delay() {                 	// Function used for text moving
	Delay_ms(100);                     	// You can change the moving speed here
}

const char character_0[] = {3,3,0,0,0,0,0,0};
const char character_1[] = {1,1,1,1,1,1,1,1};

void CustomChar() {
	char i;
    LCD_Cmd(64); //entra na CGRAM
    for (i = 0; i<=7; i++) LCD_Chr_Cp(character_0[i]); //grava 8 bytes na cgram ENDER 0 a 7  cgram
    for (i = 0; i<=7; i++) LCD_Chr_Cp(character_1[i]); //grava 8 bytes na cgram ENDER 8 a 15 cgram
    LCD_Cmd(_LCD_RETURN_HOME); //sai da cgram
}

void Alert() {
	int i;
	for(i=0; i<1; i++) {               // Move text to the right 4 times
		Lcd_Cmd(_LCD_SHIFT_RIGHT);
		Move_Delay();
	}
	for(i=0; i<1; i++) {               // Move text to the left 4 times
		Lcd_Cmd(_LCD_SHIFT_LEFT);
		Move_Delay();
	}
}

void Write_EEPROM(int END, int DADO) {
	I2C1_Start();           // issue I2C start signal
	I2C1_Wr(0xA0);          // send byte via I2C  (device address + W)
	I2C1_Wr(END);           // send byte (address of EEPROM location)
	I2C1_Wr(DADO);          // send data (data to be written)
	I2C1_Stop();            // issue I2C stop signal
	delay_ms(10);
}

int Read_EEPROM(int END) {
	int Dado;
	I2C1_Start();           // issue I2C start signal
	I2C1_Wr(0xA0);          // send byte via I2C  (device address + W)
	I2C1_Wr(END);             // send byte (data address)
	I2C1_Repeated_Start();  // issue I2C signal repeated start
	I2C1_Wr(0xA1);          // send byte (device address + R)
	Dado = I2C1_Rd(0u);    // Read the data (NO acknowledge)
	I2C1_Stop();            // issue I2C stop signal
	return(Dado);
}

void Write_RTC(int END, int DADO) {
	I2C1_Start();           // issue I2C start signal
	I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
	I2C1_Wr(END);             // send byte (address of EEPROM location)
	I2C1_Wr(DADO);          // send data (data to be written)
	I2C1_Stop();            // issue I2C stop signal
}

int Read_RTC(int END) {
	int Dado;
	I2C1_Start();           // issue I2C start signal
	I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
	I2C1_Wr(END);             // send byte (data address)
	I2C1_Repeated_Start();  // issue I2C signal repeated start
	I2C1_Wr(0xD1);          // send byte (device address + R)
	Dado = I2C1_Rd(0u);    // Read the data (NO acknowledge)
	I2C1_Stop();            // issue I2C stop signal
	return(Dado);
}
// bcd para binario
void Transform_Time(char *sec, char *min, char *hr) {
	*sec = ((*sec & 0xF0) >> 4)*10 + (*sec & 0x0F);
	*min = ((*min & 0xF0) >> 4)*10 + (*min & 0x0F);
	*hr = ((*hr & 0xF0) >> 4)*10 + (*hr & 0x0F);
}

int i = 0;

void Le_Entrada_Cmd(char slot[], int showInput, int row, int column) {
    for (i = 0; i < sizeof(slot); i++) {
        slot[i] = 0;
    }
    i = 0;
    while((_char = Le_Teclado()) != '=') {
        if (_char != 255) {
          if (_char == '*') {
            if (i > 0) {
				i--;
			}

            slot[i] = 0;
            if (showInput) {
				Lcd_Out(row, column + i, " ");
            }
          } else {
            slot[i] = _char;
            i++;
            if (showInput) {
              Lcd_Out(row, column, slot);
            }
          }
        }
    }
}

void Le_Entrada(char slot[]) {
    Le_Entrada_Cmd(slot, 0, 0, 0);
}

void Le_Entrada_Cp(char slot[], int row, int column) {
    Le_Entrada_Cmd(slot, 1, row, column);
}

char command;
short drawInfoLabel = 1;
char HORA_TXT[20];
void main() {
	UART1_Init(19200);
	I2C1_Init(100000);		// i2c para acessar ID = D0h  = RTC

	ADCON1 = 0B00001110;
	TRISB = 0B00001111;
	TRISA = 0B00100001;
	Lcd_Init();

	Lcd_Cmd(_LCD_CURSOR_OFF);
	CustomChar();


	InitTimer2_Int0();

	while(1)
	{
		command = Le_Teclado();
		if (command == 'C') {
			Lcd_Cmd(_LCD_CLEAR);
			Lcd_Out(2, 2, "MODO CONFIGURACAO");
			Delay_ms(1000);

			Write_EEPROM(0, 0xFF);
			Write_EEPROM(1, 0xFF);
			Write_EEPROM(2, 0xFF);
		}

		temp = Read_EEPROM(0);
		critic_hhh = Read_EEPROM(1);
		critic_mmm = Read_EEPROM(2);

		if (temp == 0xFF) {
			Lcd_Cmd(_LCD_CLEAR);
			Lcd_Out(1, 2, "CONFIGURANDO A ");
			Lcd_Out(2, 2, "TEMPERATURA");
			Delay_ms(2000);
			Lcd_Cmd(_LCD_CLEAR);
			Lcd_Out(1, 2, "QUAL A TEMPERATURA");
			Lcd_Out(2, 2, "MAXIMA?");
			Lcd_Out(3, 2, "R.: __");
			Le_Entrada_Cp(ENTRADA, 3, 6);
			temp=atoi(ENTRADA);
			Write_EEPROM(0, temp);
		}

		if (critic_hhh == 0xFF && critic_mmm == 0xFF) {
			Lcd_Cmd(_LCD_CLEAR);
			Lcd_Out(1, 2, "CONFIGURANDO O");
			Lcd_Out(2, 2, "HORARIO DO");
			Lcd_Out(3, 2, "MONITORAMENTO");
			Delay_ms(2000);

			Lcd_Cmd(_LCD_CLEAR);
			Lcd_Out(1, 2, "QUAL A HORA?");
			Lcd_Out(2, 2, "R.: __");
			Le_Entrada_Cp(ENTRADA, 2, 6);
			critic_hhh = atoi(ENTRADA);

			Lcd_Out(3, 2, "QUAIS OS MINUTOS?");
			Lcd_Out(4, 2, "R.: __");
			Le_Entrada_Cp(ENTRADA, 4, 6);
			critic_mmm = atoi(ENTRADA);

			Write_EEPROM(1, critic_hhh);
			Write_EEPROM(2, critic_mmm);

			drawInfoLabel = 1;
		}

		if (drawInfoLabel) {
			Lcd_Cmd(_LCD_CLEAR);
			Lcd_Out(1, 2, "TEMP. ATUAL:");
			Lcd_Out(2, 2, "TEMP. MAX:");
			Lcd_Out(3, 2, "H. MON:");
			Lcd_Out(4, 2, "H. ATUAL:");
			drawInfoLabel = 0;
		}

		if (command == '+') {
			temp = temp + 1;
			Write_EEPROM(0, temp);
		}

		if (command == '-') {
			temp = temp - 1;
			Write_EEPROM(0, temp);
		}

		sprintf(TXT, "%02d", temp);
		Lcd_Out(2, 13, TXT);
		lcd_chr_cp(0);
		lcd_chr_cp('C');

		sprintf(TXT, "%02d:%02d",critic_hhh,critic_mmm);
		Lcd_Out(3, 10, TXT);

		sss = Read_RTC(0); //le segundos
		mmm = Read_RTC(1); //le minutos
		hhh = Read_RTC(2); //le horas
		Transform_Time(&sss,&mmm,&hhh);
		sprintf(HORA_TXT, "%02d:%02d:%02d",hhh,mmm,sss);
		lcd_Out(4, 12, HORA_TXT);

		AD = ADC_Read(0);
		Temperatura = ((float) AD * 5.0/1024.0) * 100.0;
		sprintf(TXT, "%02d", Temperatura);
		Lcd_Out(1, 15, TXT);
		Lcd_Chr_Cp(0);
		Lcd_Chr_CP('C');

		if (Temperatura > temp && (hhh >= critic_hhh && mmm >= critic_mmm))
			Alert();
	}
}
