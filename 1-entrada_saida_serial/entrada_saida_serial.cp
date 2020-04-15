#line 1 "C:/Users/tcpipchip/Desktop/eletiva_iv/projetos/entrada_saida_serial/entrada_saida_serial.c"
void main() {
 ADCON1=0x0F;
 TRISB=0B00001111;
 UART1_Init(19200);
 UART1_Write_Text("Hello World...\r");
 while(1)
 {
 PORTB = PORTB << 4;
 }
}
