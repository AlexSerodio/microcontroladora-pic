
_Pula_Linha:

;display-lcd.c,37 :: 		void Pula_Linha(void)
;display-lcd.c,39 :: 		UART1_WRITE(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;display-lcd.c,40 :: 		UART1_WRITE(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;display-lcd.c,41 :: 		}
	RETURN      0
; end of _Pula_Linha

_CustomChar:

;display-lcd.c,50 :: 		void CustomChar() {
;display-lcd.c,52 :: 		LCD_Cmd(64); //entra na CGRAM
	MOVLW       64
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;display-lcd.c,53 :: 		for (i = 0; i<=7; i++) LCD_Chr_Cp(character_0[i]); //grava 8 bytes na cgram ENDER 0 a 7  cgram
	CLRF        CustomChar_i_L0+0 
L_CustomChar0:
	MOVF        CustomChar_i_L0+0, 0 
	SUBLW       7
	BTFSS       STATUS+0, 0 
	GOTO        L_CustomChar1
	MOVLW       _character_0+0
	ADDWF       CustomChar_i_L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_character_0+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_character_0+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Lcd_Chr_CP_out_char+0
	CALL        _Lcd_Chr_CP+0, 0
	INCF        CustomChar_i_L0+0, 1 
	GOTO        L_CustomChar0
L_CustomChar1:
;display-lcd.c,54 :: 		for (i = 0; i<=7; i++) LCD_Chr_Cp(character_1[i]); //grava 8 bytes na cgram ENDER 8 a 15 cgram
	CLRF        CustomChar_i_L0+0 
L_CustomChar3:
	MOVF        CustomChar_i_L0+0, 0 
	SUBLW       7
	BTFSS       STATUS+0, 0 
	GOTO        L_CustomChar4
	MOVLW       _character_1+0
	ADDWF       CustomChar_i_L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_character_1+0)
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      TBLPTRH, 1 
	MOVLW       higher_addr(_character_1+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Lcd_Chr_CP_out_char+0
	CALL        _Lcd_Chr_CP+0, 0
	INCF        CustomChar_i_L0+0, 1 
	GOTO        L_CustomChar3
L_CustomChar4:
;display-lcd.c,55 :: 		LCD_Cmd(_LCD_RETURN_HOME); //sai da cgram
	MOVLW       2
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;display-lcd.c,56 :: 		}
	RETURN      0
; end of _CustomChar

_Move_Delay:

;display-lcd.c,58 :: 		void Move_Delay() {                  // Function used for text moving
;display-lcd.c,59 :: 		Delay_ms(200);                     // You can change the moving speed here
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_Move_Delay6:
	DECFSZ      R13, 1, 0
	BRA         L_Move_Delay6
	DECFSZ      R12, 1, 0
	BRA         L_Move_Delay6
	DECFSZ      R11, 1, 0
	BRA         L_Move_Delay6
;display-lcd.c,60 :: 		}
	RETURN      0
; end of _Move_Delay

_main:

;display-lcd.c,64 :: 		void main()
;display-lcd.c,67 :: 		ADCON1=0B00001110;
	MOVLW       14
	MOVWF       ADCON1+0 
;display-lcd.c,68 :: 		TRISB = 0B00001111;
	MOVLW       15
	MOVWF       TRISB+0 
;display-lcd.c,69 :: 		PORTB = 0B00000000;
	CLRF        PORTB+0 
;display-lcd.c,70 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;display-lcd.c,72 :: 		UART1_Init(19200);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;display-lcd.c,74 :: 		Lcd_Out(1, 1, "Temperatura atual: ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_display_45lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_display_45lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;display-lcd.c,75 :: 		Lcd_Out(3, 1, "Temperatura máxima: ");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_display_45lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_display_45lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;display-lcd.c,77 :: 		UART1_Write_Text("Informe a Temperatura máxima: \r");
	MOVLW       ?lstr3_display_45lcd+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_display_45lcd+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;display-lcd.c,78 :: 		while(tempMaxima == -1)
L_main7:
	MOVLW       255
	XORWF       _tempMaxima+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main24
	MOVLW       255
	XORWF       _tempMaxima+0, 0 
L__main24:
	BTFSS       STATUS+0, 2 
	GOTO        L_main8
;display-lcd.c,80 :: 		if (UART1_Data_Ready() == 1) {
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
;display-lcd.c,81 :: 		UART1_Read_Text(ENTRADA, ENTER, 32);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       _ENTER+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(_ENTER+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       32
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;display-lcd.c,82 :: 		UART1_Write_Text(ENTRADA);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;display-lcd.c,83 :: 		UART1_Write_Text("\r");
	MOVLW       ?lstr4_display_45lcd+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_display_45lcd+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;display-lcd.c,85 :: 		tempMaxima = atoi(ENTRADA);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _tempMaxima+0 
	MOVF        R1, 0 
	MOVWF       _tempMaxima+1 
;display-lcd.c,86 :: 		Lcd_Out(4, 1, ENTRADA);
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ENTRADA+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;display-lcd.c,87 :: 		}
L_main9:
;display-lcd.c,88 :: 		}
	GOTO        L_main7
L_main8:
;display-lcd.c,90 :: 		while(Temperatura <= tempMaxima) {
L_main10:
	MOVLW       128
	XORWF       _tempMaxima+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main25
	MOVF        _Temperatura+0, 0 
	SUBWF       _tempMaxima+0, 0 
L__main25:
	BTFSS       STATUS+0, 0 
	GOTO        L_main11
;display-lcd.c,91 :: 		AD = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _AD+0 
	MOVF        R1, 0 
	MOVWF       _AD+1 
;display-lcd.c,92 :: 		Temperatura = ((float) AD * 5.0/1024.0) * 100.0;
	CALL        _Word2Double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
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
	MOVWF       _Temperatura+0 
;display-lcd.c,94 :: 		if(Temperatura != TemperaturaAntiga) {
	MOVF        R0, 0 
	XORWF       _TemperaturaAntiga+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
;display-lcd.c,95 :: 		TemperaturaAntiga = Temperatura;
	MOVF        _Temperatura+0, 0 
	MOVWF       _TemperaturaAntiga+0 
;display-lcd.c,96 :: 		inttostr(Temperatura, TXT);
	MOVF        _Temperatura+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _TXT+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;display-lcd.c,97 :: 		Lcd_Out(2, 1, TXT);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _TXT+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;display-lcd.c,98 :: 		}
L_main12:
;display-lcd.c,99 :: 		}
	GOTO        L_main10
L_main11:
;display-lcd.c,101 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;display-lcd.c,102 :: 		Lcd_Out(1, 1, "Temperatura");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_display_45lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_display_45lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;display-lcd.c,103 :: 		Lcd_Out(2, 1, "Maxima de ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_display_45lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_display_45lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;display-lcd.c,104 :: 		Lcd_Out(3, 1, "");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_display_45lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_display_45lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;display-lcd.c,105 :: 		Lcd_Out(3, 1, TXT);
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _TXT+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;display-lcd.c,106 :: 		Lcd_Out(4, 1, "Atingida");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_display_45lcd+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_display_45lcd+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;display-lcd.c,109 :: 		for(i=0; i<4; i++) {               // Move text to the right 4 times
	CLRF        _i+0 
	CLRF        _i+1 
L_main13:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main26
	MOVLW       4
	SUBWF       _i+0, 0 
L__main26:
	BTFSC       STATUS+0, 0 
	GOTO        L_main14
;display-lcd.c,110 :: 		Lcd_Cmd(_LCD_SHIFT_RIGHT);
	MOVLW       28
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;display-lcd.c,109 :: 		for(i=0; i<4; i++) {               // Move text to the right 4 times
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;display-lcd.c,111 :: 		}
	GOTO        L_main13
L_main14:
;display-lcd.c,112 :: 		while(1) {
L_main16:
;display-lcd.c,113 :: 		for(i=0; i<4; i++) {               // Move text to the right 4 times
	CLRF        _i+0 
	CLRF        _i+1 
L_main18:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main27
	MOVLW       4
	SUBWF       _i+0, 0 
L__main27:
	BTFSC       STATUS+0, 0 
	GOTO        L_main19
;display-lcd.c,114 :: 		Lcd_Cmd(_LCD_SHIFT_RIGHT);
	MOVLW       28
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;display-lcd.c,115 :: 		Move_Delay();
	CALL        _Move_Delay+0, 0
;display-lcd.c,113 :: 		for(i=0; i<4; i++) {               // Move text to the right 4 times
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;display-lcd.c,116 :: 		}
	GOTO        L_main18
L_main19:
;display-lcd.c,118 :: 		for(i=0; i<4; i++) {               // Move text to the right 4 times
	CLRF        _i+0 
	CLRF        _i+1 
L_main21:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main28
	MOVLW       4
	SUBWF       _i+0, 0 
L__main28:
	BTFSC       STATUS+0, 0 
	GOTO        L_main22
;display-lcd.c,119 :: 		Lcd_Cmd(_LCD_SHIFT_LEFT);
	MOVLW       24
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;display-lcd.c,120 :: 		Move_Delay();
	CALL        _Move_Delay+0, 0
;display-lcd.c,118 :: 		for(i=0; i<4; i++) {               // Move text to the right 4 times
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;display-lcd.c,121 :: 		}
	GOTO        L_main21
L_main22:
;display-lcd.c,122 :: 		}
	GOTO        L_main16
;display-lcd.c,127 :: 		}
	GOTO        $+0
; end of _main
