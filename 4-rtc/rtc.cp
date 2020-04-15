#line 1 "C:/Users/alexb/Desktop/eletiva_iv/projetos/4-rtc/rtc.c"

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



int hhh, mmm, sss;



char ENTER[2] = {13,0};



char ENTRADA[33];



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

void Transform_Time(char *sec, char *min, char *hr) {
*sec = ((*sec & 0xF0) >> 4)*10 + (*sec & 0x0F);
*min = ((*min & 0xF0) >> 4)*10 + (*min & 0x0F);
*hr = ((*hr & 0xF0) >> 4)*10 + (*hr & 0x0F);
}



void main()
 {
 UART1_Init(19200);
 I2C1_Init(100000);



 UART1_Write_Text("QUAL A TEMPERATURA MAXIMA\r");
 while(!(UART1_Data_Ready() == 1));
 UART1_Read_Text(ENTRADA, ENTER, 32);
 UART1_Write_Text(ENTRADA);
 temp=atoi(ENTRADA);



 ADCON1=0B00001110;
 TRISB = 0B00001111;
 PORTB = 0B00000000;
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 CustomChar();



 Lcd_Out(1, 2, "TEMPERATURA ATUAL");
 Lcd_Out(3, 2, "TEMPERATURA MAXIMA");
 lcd_Out(4, 9, ENTRADA);
 lcd_chr_cp(0);
 lcd_chr_cp('C');



 while(1)
 {
 while(1)
 {
 sss= Read_RTC(0);
 mmm= Read_RTC(1);
 hhh= Read_RTC(2);

 Transform_Time(&sss,&mmm,&hhh);

 inttostr(hhh, TXT);
 UART1_Write_Text(TXT);
 UART1_Write(':');
 inttostr(mmm, TXT);
 UART1_Write_Text(TXT);
 UART1_Write(':');
 inttostr(sss, TXT);
 UART1_Write_Text(TXT);
 Pula_Linha();
 delay_ms(1000);
 }










 AD = ADC_Read(0);
 Temperatura = ((float) AD * 5.0/1024.0) * 100.0;
 inttostr(Temperatura, TXT);


 Lcd_Out(2, 5, TXT);
 Lcd_Chr_Cp(0);
 Lcd_Chr_CP('C');
 if(Temperatura >= temp)
 Alert();
 }
}
