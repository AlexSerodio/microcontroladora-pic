
_main:

;entrada_saida_serial.c,1 :: 		void main() {
;entrada_saida_serial.c,2 :: 		ADCON1=0x0F;      //TODOS PINOS SAO DIGITAIS
	MOVLW       15
	MOVWF       ADCON1+0 
;entrada_saida_serial.c,3 :: 		TRISB=0B00001111; //RB0..RB3 INPUT, RB4..RB7 OUTPUT
	MOVLW       15
	MOVWF       TRISB+0 
;entrada_saida_serial.c,4 :: 		UART1_Init(19200);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;entrada_saida_serial.c,5 :: 		UART1_Write_Text("Hello World...\r");
	MOVLW       ?lstr1_entrada_saida_serial+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_entrada_saida_serial+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;entrada_saida_serial.c,6 :: 		while(1)
L_main0:
;entrada_saida_serial.c,8 :: 		PORTB = PORTB << 4;
	MOVF        PORTB+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	MOVWF       PORTB+0 
;entrada_saida_serial.c,9 :: 		}
	GOTO        L_main0
;entrada_saida_serial.c,10 :: 		}
	GOTO        $+0
; end of _main
