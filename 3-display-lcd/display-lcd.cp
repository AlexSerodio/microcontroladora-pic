#line 1 "C:/Users/alexb/Desktop/eletiva_iv/projetos/3-display-lcd/display-lcd.c"

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
unsigned short TemperaturaAntiga;

char ENTRADA[33];
char ENTER[2] = {13, 0};

int tempMaxima = -1;

void Pula_Linha(void)
{
 UART1_WRITE(13);
 UART1_WRITE(10);
}



const char character_0[] = {0,10,0,4,17,10,14,0};
const char character_1[] = {1,1,1,1,1,1,1,1};



void CustomChar() {
 char i;
 LCD_Cmd(64);
 for (i = 0; i<=7; i++) LCD_Chr_Cp(character_0[i]);
 for (i = 0; i<=7; i++) LCD_Chr_Cp(character_1[i]);
 LCD_Cmd(_LCD_RETURN_HOME);
}

void Move_Delay() {
 Delay_ms(200);
}

int i;

void main()
{

 ADCON1=0B00001110;
 TRISB = 0B00001111;
 PORTB = 0B00000000;
 Lcd_Init();

 UART1_Init(19200);

 Lcd_Out(1, 1, "Temperatura atual: ");
 Lcd_Out(3, 1, "Temperatura máxima: ");

 UART1_Write_Text("Informe a Temperatura máxima: \r");
 while(tempMaxima == -1)
 {
 if (UART1_Data_Ready() == 1) {
 UART1_Read_Text(ENTRADA, ENTER, 32);
 UART1_Write_Text(ENTRADA);
 UART1_Write_Text("\r");

 tempMaxima = atoi(ENTRADA);
 Lcd_Out(4, 1, ENTRADA);
 }
 }

 while(Temperatura <= tempMaxima) {
 AD = ADC_Read(0);
 Temperatura = ((float) AD * 5.0/1024.0) * 100.0;

 if(Temperatura != TemperaturaAntiga) {
 TemperaturaAntiga = Temperatura;
 inttostr(Temperatura, TXT);
 Lcd_Out(2, 1, TXT);
 }
 }

 Lcd_Init();
 Lcd_Out(1, 1, "Temperatura");
 Lcd_Out(2, 1, "Maxima de ");
 Lcd_Out(3, 1, "");
 Lcd_Out(3, 1, TXT);
 Lcd_Out(4, 1, "Atingida");


 for(i=0; i<4; i++) {
 Lcd_Cmd(_LCD_SHIFT_RIGHT);
 }
 while(1) {
 for(i=0; i<4; i++) {
 Lcd_Cmd(_LCD_SHIFT_RIGHT);
 Move_Delay();
 }

 for(i=0; i<4; i++) {
 Lcd_Cmd(_LCD_SHIFT_LEFT);
 Move_Delay();
 }
 }

 CustomChar();


}
