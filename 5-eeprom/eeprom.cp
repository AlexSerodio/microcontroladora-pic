#line 1 "C:/Users/alexb/Desktop/eletiva_iv/projetos/5-eeprom/eeprom.c"

sbit LCD_RS at RE0_bit;
sbit LCD_EN at RE1_bit;



sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;




sbit LCD_RS_Direction at TRISE0_bit;
sbit LCD_EN_Direction at TRISE1_bit;



sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;



unsigned int AD;
char TXT[7];
unsigned short Temperatura;

char HORA_TXT[20];

int hhh, mmm, sss;



char ENTER[2] = {13,0};



char ENTRADA[33];
char ENTRADA2[33];


int temp;




void Pula_Linha(void)
{
 UART1_WRITE(13);
 UART1_WRITE(10);
}



void Move_Delay() {
 Delay_ms(100);
}



const char character_0[] = {3,3,0,0,0,0,0,0};
const char character_1[] = {1,1,1,1,1,1,1,1};



void CustomChar() {
 char i;
 LCD_Cmd(64);
 for (i = 0; i<=7; i++) LCD_Chr_Cp(character_0[i]);
 for (i = 0; i<=7; i++) LCD_Chr_Cp(character_1[i]);
 LCD_Cmd(_LCD_RETURN_HOME);
}



void Alert()
{
 int i;



 for(i=0; i<1; i++) {
 Lcd_Cmd(_LCD_SHIFT_RIGHT);
 Move_Delay();
 }
 for(i=0; i<1; i++) {
 Lcd_Cmd(_LCD_SHIFT_LEFT);
 Move_Delay();
 }



}



void Write_RTC(int END, int DADO)
{
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(END);
 I2C1_Wr(DADO);
 I2C1_Stop();
}

void Write_EEPROM(int END, int DADO)
{
 I2C1_Start();
 I2C1_Wr(0xA0);
 I2C1_Wr(END);
 I2C1_Wr(DADO);
 I2C1_Stop();
 delay_ms(10);
}

int Read_RTC(int END)
{
 int Dado;

 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(END);
 I2C1_Repeated_Start();
 I2C1_Wr(0xD1);
 Dado = I2C1_Rd(0u);
 I2C1_Stop();
 return(Dado);
}

int Read_EEPROM(int END)
{
 int Dado;

 I2C1_Start();
 I2C1_Wr(0xA0);
 I2C1_Wr(END);
 I2C1_Repeated_Start();
 I2C1_Wr(0xA1);
 Dado = I2C1_Rd(0u);
 I2C1_Stop();
 return(Dado);
}


void Transform_Time(char *sec, char *min, char *hr) {
*sec = ((*sec & 0xF0) >> 4)*10 + (*sec & 0x0F);
*min = ((*min & 0xF0) >> 4)*10 + (*min & 0x0F);
*hr = ((*hr & 0xF0) >> 4)*10 + (*hr & 0x0F);
}

int hora_maxima;
int minuto_maximo;

void main() {
 UART1_Init(19200);
 I2C1_Init(100000);

 ADCON1=0B00001110;
 TRISB = 0B00001111;
 PORTB = 0B00000000;
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 CustomChar();

 if(PORTB == 0B00000100){
 Write_EEPROM(0, 0xFF);
 Write_EEPROM(1, 0xFF);
 Write_EEPROM(2, 0xFF);
 UART1_Write_Text("A memoria foi limpa!");
 Pula_Linha();
 }

 if(Read_EEPROM(0) == 0xFF || Read_EEPROM(1) == 0xFF || Read_EEPROM(2) == 0xFF) {
 UART1_Write_Text("QUAL A TEMPERATURA MAXIMA\r");
 while(!(UART1_Data_Ready() == 1));
 UART1_Read_Text(ENTRADA, ENTER, 32);
 UART1_Write_Text(ENTRADA);
 Pula_Linha();

 temp=atoi(ENTRADA);
 Write_EEPROM(0, temp);

 UART1_Write_Text("QUAL A HORA MAXIMA\r");
 while(!(UART1_Data_Ready() == 1));
 UART1_Read_Text(ENTRADA2, ENTER, 32);
 UART1_Write_Text(ENTRADA2);
 Pula_Linha();

 hora_maxima=atoi(ENTRADA2);
 Write_EEPROM(1, hora_maxima);

 UART1_Write_Text("QUAL O MINUTO MAXIMO\r");
 while(!(UART1_Data_Ready() == 1));
 UART1_Read_Text(ENTRADA2, ENTER, 32);
 UART1_Write_Text(ENTRADA2);
 Pula_Linha();

 minuto_maximo=atoi(ENTRADA2);
 Write_EEPROM(2, minuto_maximo);
 } else {
 temp = Read_EEPROM(0);
 inttostr(temp, ENTRADA);

 hora_maxima = Read_EEPROM(1);
 minuto_maximo = Read_EEPROM(2);
 }

 Lcd_Out(1, 1, "TEMP. ATUAL:");
 Lcd_Out(2, 1, "TEMP. MAX:");
 lcd_Out(2, 13, ENTRADA);
 lcd_chr_cp(0);
 lcd_chr_cp('C');
 while(1) {
 sss= Read_RTC(0);
 mmm= Read_RTC(1);
 hhh= Read_RTC(2);
 Transform_Time(&sss,&mmm,&hhh);

 sprintf(HORA_TXT, "T: %02d:%02d", hhh, mmm);
 lcd_Out(4, 1, HORA_TXT);

 sprintf(HORA_TXT, "M: %02d:%02d", hora_maxima, minuto_maximo);
 lcd_Out(4, 13, HORA_TXT);




 AD = ADC_Read(0);
 Temperatura = ((float) AD * 5.0/1024.0) * 100.0;
 inttostr(Temperatura, TXT);


 Lcd_Out(1, 13, TXT);
 Lcd_Chr_Cp(0);
 Lcd_Chr_CP('C');
 if(Temperatura >= temp && (hhh >= hora_maxima && mmm >= minuto_maximo))
 Alert();
 }
}
