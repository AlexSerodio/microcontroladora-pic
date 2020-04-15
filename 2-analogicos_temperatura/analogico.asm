
_pula_linha:

;analogico.c,7 :: 		void pula_linha() {
;analogico.c,8 :: 		UART1_Write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;analogico.c,9 :: 		UART1_Write(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;analogico.c,10 :: 		}
	RETURN      0
; end of _pula_linha

_main:

;analogico.c,12 :: 		void main() {
;analogico.c,14 :: 		UART1_Init(19200);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;analogico.c,15 :: 		ADCON1 = 0B00001110;
	MOVLW       14
	MOVWF       ADCON1+0 
;analogico.c,16 :: 		TRISB = 0B00001111; // saida RB7 a RB4 | entrada RB3 a RB0
	MOVLW       15
	MOVWF       TRISB+0 
;analogico.c,17 :: 		PORTB = 0B00000000;
	CLRF        PORTB+0 
;analogico.c,19 :: 		while(1) {
L_main0:
;analogico.c,20 :: 		AD = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _AD+0 
	MOVF        R1, 0 
	MOVWF       _AD+1 
;analogico.c,21 :: 		temperatura = (float) AD * step * 100;
	CALL        _Int2Double+0, 0
	MOVF        _step+0, 0 
	MOVWF       R4 
	MOVF        _step+1, 0 
	MOVWF       R5 
	MOVF        _step+2, 0 
	MOVWF       R6 
	MOVF        _step+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _Double2Byte+0, 0
	MOVF        R0, 0 
	MOVWF       _temperatura+0 
;analogico.c,23 :: 		if(temperatura >= 0 && temperatura <= 24) {
	MOVLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main4
	MOVF        _temperatura+0, 0 
	SUBLW       24
	BTFSS       STATUS+0, 0 
	GOTO        L_main4
L__main20:
;analogico.c,25 :: 		PORTB = 0B10000000;
	MOVLW       128
	MOVWF       PORTB+0 
;analogico.c,26 :: 		} else if(temperatura >= 25 && temperatura <= 33) {
	GOTO        L_main5
L_main4:
	MOVLW       25
	SUBWF       _temperatura+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main8
	MOVF        _temperatura+0, 0 
	SUBLW       33
	BTFSS       STATUS+0, 0 
	GOTO        L_main8
L__main19:
;analogico.c,28 :: 		PORTB = 0B11000000;
	MOVLW       192
	MOVWF       PORTB+0 
;analogico.c,29 :: 		} else if(temperatura >= 34 && temperatura <= 43) {
	GOTO        L_main9
L_main8:
	MOVLW       34
	SUBWF       _temperatura+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main12
	MOVF        _temperatura+0, 0 
	SUBLW       43
	BTFSS       STATUS+0, 0 
	GOTO        L_main12
L__main18:
;analogico.c,31 :: 		PORTB = 0B11100000;
	MOVLW       224
	MOVWF       PORTB+0 
;analogico.c,32 :: 		} else if(temperatura >= 44 && temperatura <= 89) {
	GOTO        L_main13
L_main12:
	MOVLW       44
	SUBWF       _temperatura+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main16
	MOVF        _temperatura+0, 0 
	SUBLW       89
	BTFSS       STATUS+0, 0 
	GOTO        L_main16
L__main17:
;analogico.c,34 :: 		PORTB = 0B11110000;
	MOVLW       240
	MOVWF       PORTB+0 
;analogico.c,35 :: 		}
L_main16:
L_main13:
L_main9:
L_main5:
;analogico.c,37 :: 		inttostr(temperatura, TXT);
	MOVF        _temperatura+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _TXT+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;analogico.c,38 :: 		UART1_Write_Text(TXT);
	MOVLW       _TXT+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;analogico.c,39 :: 		pula_linha();
	CALL        _pula_linha+0, 0
;analogico.c,40 :: 		}
	GOTO        L_main0
;analogico.c,42 :: 		}
	GOTO        $+0
; end of _main
