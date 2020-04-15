#line 1 "C:/Users/alexb/Desktop/eletiva_iv/projetos/analogicos_temperatura/analogico.c"

int AD;
char TXT[7];
unsigned short temperatura;
float step = (5.0 / 1024.0);

void pula_linha() {
 UART1_Write(13);
 UART1_Write(10);
}

void main() {

 UART1_Init(19200);
 ADCON1 = 0B00001110;
 TRISB = 0B00001111;
 PORTB = 0B00000000;

 while(1) {
 AD = ADC_Read(0);
 temperatura = (float) AD * step * 100;

 if(temperatura >= 0 && temperatura <= 24) {

 PORTB = 0B10000000;
 } else if(temperatura >= 25 && temperatura <= 33) {

 PORTB = 0B11000000;
 } else if(temperatura >= 34 && temperatura <= 43) {

 PORTB = 0B11100000;
 } else if(temperatura >= 44 && temperatura <= 89) {

 PORTB = 0B11110000;
 }

 inttostr(temperatura, TXT);
 UART1_Write_Text(TXT);
 pula_linha();
 }

}
