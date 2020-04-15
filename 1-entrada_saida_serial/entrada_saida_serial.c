void main() {
     ADCON1=0x0F;      //TODOS PINOS SAO DIGITAIS
     TRISB=0B00001111; //RB0..RB3 INPUT, RB4..RB7 OUTPUT
     UART1_Init(19200);
     UART1_Write_Text("Hello World...\r");
     while(1)
     {
      //LE ENTRADAS (RB0..3) E ESCREVE NA SAIDA (RB4..RB7)
      //LE ENTRADA, ROTACIONA 4 VEZES OS BITS E ESCREVE NA SAIDA!
      PORTB = PORTB << 4;
     }
}
