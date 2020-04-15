
_Pula_Linha:

;rtc.c,50 :: 		void Pula_Linha(void)
;rtc.c,52 :: 		UART1_WRITE(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rtc.c,53 :: 		UART1_WRITE(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rtc.c,54 :: 		}
	RETURN      0
; end of _Pula_Linha

_Move_Delay:

;rtc.c,58 :: 		void Move_Delay() {                  // Function used for text moving
;rtc.c,59 :: 		Delay_ms(100);                     // You can change the moving speed here
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_Move_Delay0:
	DECFSZ      R13, 1, 0
	BRA         L_Move_Delay0
	DECFSZ      R12, 1, 0
	BRA         L_Move_Delay0
	DECFSZ      R11, 1, 0
	BRA         L_Move_Delay0
	NOP
;rtc.c,60 :: 		}
	RETURN      0
; end of _Move_Delay

_CustomChar:

;rtc.c,69 :: 		void CustomChar() {
;rtc.c,71 :: 		LCD_Cmd(64); //entra na CGRAM
	MOVLW       64
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;rtc.c,72 :: 		for (i = 0; i<=7; i++) LCD_Chr_Cp(character_0[i]); //grava 8 bytes na cgram ENDER 0 a 7  cgram
	CLRF        CustomChar_i_L0+0 
L_CustomChar1:
	MOVF        CustomChar_i_L0+0, 0 
	SUBLW       7
	BTFSS       STATUS+0, 0 
	GOTO        L_CustomChar2
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
	GOTO        L_CustomChar1
L_CustomChar2:
;rtc.c,73 :: 		for (i = 0; i<=7; i++) LCD_Chr_Cp(character_1[i]); //grava 8 bytes na cgram ENDER 8 a 15 cgram
	CLRF        CustomChar_i_L0+0 
L_CustomChar4:
	MOVF        CustomChar_i_L0+0, 0 
	SUBLW       7
	BTFSS       STATUS+0, 0 
	GOTO        L_CustomChar5
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
	GOTO        L_CustomChar4
L_CustomChar5:
;rtc.c,74 :: 		LCD_Cmd(_LCD_RETURN_HOME); //sai da cgram
	MOVLW       2
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;rtc.c,75 :: 		}
	RETURN      0
; end of _CustomChar

_Alert:

;rtc.c,79 :: 		void Alert()
;rtc.c,85 :: 		for(i=0; i<1; i++) {               // Move text to the right 4 times
	CLRF        Alert_i_L0+0 
	CLRF        Alert_i_L0+1 
L_Alert7:
	MOVLW       128
	XORWF       Alert_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Alert21
	MOVLW       1
	SUBWF       Alert_i_L0+0, 0 
L__Alert21:
	BTFSC       STATUS+0, 0 
	GOTO        L_Alert8
;rtc.c,86 :: 		Lcd_Cmd(_LCD_SHIFT_RIGHT);
	MOVLW       28
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;rtc.c,87 :: 		Move_Delay();
	CALL        _Move_Delay+0, 0
;rtc.c,85 :: 		for(i=0; i<1; i++) {               // Move text to the right 4 times
	INFSNZ      Alert_i_L0+0, 1 
	INCF        Alert_i_L0+1, 1 
;rtc.c,88 :: 		}
	GOTO        L_Alert7
L_Alert8:
;rtc.c,89 :: 		for(i=0; i<1; i++) {               // Move text to the left 4 times
	CLRF        Alert_i_L0+0 
	CLRF        Alert_i_L0+1 
L_Alert10:
	MOVLW       128
	XORWF       Alert_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Alert22
	MOVLW       1
	SUBWF       Alert_i_L0+0, 0 
L__Alert22:
	BTFSC       STATUS+0, 0 
	GOTO        L_Alert11
;rtc.c,90 :: 		Lcd_Cmd(_LCD_SHIFT_LEFT);
	MOVLW       24
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;rtc.c,91 :: 		Move_Delay();
	CALL        _Move_Delay+0, 0
;rtc.c,89 :: 		for(i=0; i<1; i++) {               // Move text to the left 4 times
	INFSNZ      Alert_i_L0+0, 1 
	INCF        Alert_i_L0+1, 1 
;rtc.c,92 :: 		}
	GOTO        L_Alert10
L_Alert11:
;rtc.c,96 :: 		}
	RETURN      0
; end of _Alert

_Write_RTC:

;rtc.c,100 :: 		void Write_RTC(int END, int DADO)
;rtc.c,102 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;rtc.c,103 :: 		I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;rtc.c,104 :: 		I2C1_Wr(END);             // send byte (address of EEPROM location)
	MOVF        FARG_Write_RTC_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;rtc.c,105 :: 		I2C1_Wr(DADO);          // send data (data to be written)
	MOVF        FARG_Write_RTC_DADO+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;rtc.c,106 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;rtc.c,107 :: 		}
	RETURN      0
; end of _Write_RTC

_Read_RTC:

;rtc.c,111 :: 		int Read_RTC(int END)
;rtc.c,117 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;rtc.c,118 :: 		I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;rtc.c,119 :: 		I2C1_Wr(END);             // send byte (data address)
	MOVF        FARG_Read_RTC_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;rtc.c,120 :: 		I2C1_Repeated_Start();  // issue I2C signal repeated start
	CALL        _I2C1_Repeated_Start+0, 0
;rtc.c,121 :: 		I2C1_Wr(0xD1);          // send byte (device address + R)
	MOVLW       209
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;rtc.c,122 :: 		Dado = I2C1_Rd(0u);    // Read the data (NO acknowledge)
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Dado_L0+0 
	MOVLW       0
	MOVWF       Read_RTC_Dado_L0+1 
;rtc.c,123 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;rtc.c,124 :: 		return(Dado);
	MOVF        Read_RTC_Dado_L0+0, 0 
	MOVWF       R0 
	MOVF        Read_RTC_Dado_L0+1, 0 
	MOVWF       R1 
;rtc.c,125 :: 		}
	RETURN      0
; end of _Read_RTC

_Transform_Time:

;rtc.c,127 :: 		void Transform_Time(char *sec, char *min, char *hr) {
;rtc.c,128 :: 		*sec = ((*sec & 0xF0) >> 4)*10 + (*sec & 0x0F);
	MOVFF       FARG_Transform_Time_sec+0, FSR0L
	MOVFF       FARG_Transform_Time_sec+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       240
	ANDWF       R3, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       10
	MULWF       R0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVLW       15
	ANDWF       R3, 0 
	MOVWF       R0 
	MOVFF       FARG_Transform_Time_sec+0, FSR1L
	MOVFF       FARG_Transform_Time_sec+1, FSR1H
	MOVF        R0, 0 
	ADDWF       R1, 0 
	MOVWF       POSTINC1+0 
;rtc.c,129 :: 		*min = ((*min & 0xF0) >> 4)*10 + (*min & 0x0F);
	MOVFF       FARG_Transform_Time_min+0, FSR0L
	MOVFF       FARG_Transform_Time_min+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       240
	ANDWF       R3, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       10
	MULWF       R0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVLW       15
	ANDWF       R3, 0 
	MOVWF       R0 
	MOVFF       FARG_Transform_Time_min+0, FSR1L
	MOVFF       FARG_Transform_Time_min+1, FSR1H
	MOVF        R0, 0 
	ADDWF       R1, 0 
	MOVWF       POSTINC1+0 
;rtc.c,130 :: 		*hr = ((*hr & 0xF0) >> 4)*10 + (*hr & 0x0F);
	MOVFF       FARG_Transform_Time_hr+0, FSR0L
	MOVFF       FARG_Transform_Time_hr+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       240
	ANDWF       R3, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       10
	MULWF       R0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVLW       15
	ANDWF       R3, 0 
	MOVWF       R0 
	MOVFF       FARG_Transform_Time_hr+0, FSR1L
	MOVFF       FARG_Transform_Time_hr+1, FSR1H
	MOVF        R0, 0 
	ADDWF       R1, 0 
	MOVWF       POSTINC1+0 
;rtc.c,131 :: 		}
	RETURN      0
; end of _Transform_Time

_main:

;rtc.c,135 :: 		void main()
;rtc.c,137 :: 		UART1_Init(19200);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;rtc.c,138 :: 		I2C1_Init(100000);// i2c para acessar ID = D0h  = RTC
	MOVLW       20
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;rtc.c,142 :: 		UART1_Write_Text("QUAL A TEMPERATURA MAXIMA\r");
	MOVLW       ?lstr1_rtc+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_rtc+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;rtc.c,143 :: 		while(!(UART1_Data_Ready() == 1));         //AGUARDA CHEGAR ALGO NA SERIAL VINDO DO TERMINAL BURRO
L_main13:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
	GOTO        L_main13
L_main14:
;rtc.c,144 :: 		UART1_Read_Text(ENTRADA, ENTER, 32);
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
;rtc.c,145 :: 		UART1_Write_Text(ENTRADA);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;rtc.c,146 :: 		temp=atoi(ENTRADA);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _temp+0 
	MOVF        R1, 0 
	MOVWF       _temp+1 
;rtc.c,150 :: 		ADCON1=0B00001110;
	MOVLW       14
	MOVWF       ADCON1+0 
;rtc.c,151 :: 		TRISB = 0B00001111;
	MOVLW       15
	MOVWF       TRISB+0 
;rtc.c,152 :: 		PORTB = 0B00000000;
	CLRF        PORTB+0 
;rtc.c,153 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;rtc.c,154 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;rtc.c,155 :: 		CustomChar();
	CALL        _CustomChar+0, 0
;rtc.c,159 :: 		Lcd_Out(1, 2, "TEMPERATURA ATUAL");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_rtc+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_rtc+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;rtc.c,160 :: 		Lcd_Out(3, 2, "TEMPERATURA MAXIMA");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_rtc+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_rtc+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;rtc.c,161 :: 		lcd_Out(4, 9, ENTRADA);
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ENTRADA+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;rtc.c,162 :: 		lcd_chr_cp(0);
	CLRF        FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;rtc.c,163 :: 		lcd_chr_cp('C');
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;rtc.c,169 :: 		while(1)
L_main17:
;rtc.c,171 :: 		sss= Read_RTC(0); //le segundos
	CLRF        FARG_Read_RTC_END+0 
	CLRF        FARG_Read_RTC_END+1 
	CALL        _Read_RTC+0, 0
	MOVF        R0, 0 
	MOVWF       _sss+0 
	MOVF        R1, 0 
	MOVWF       _sss+1 
;rtc.c,172 :: 		mmm= Read_RTC(1); //le minutos
	MOVLW       1
	MOVWF       FARG_Read_RTC_END+0 
	MOVLW       0
	MOVWF       FARG_Read_RTC_END+1 
	CALL        _Read_RTC+0, 0
	MOVF        R0, 0 
	MOVWF       _mmm+0 
	MOVF        R1, 0 
	MOVWF       _mmm+1 
;rtc.c,173 :: 		hhh= Read_RTC(2); //le horas
	MOVLW       2
	MOVWF       FARG_Read_RTC_END+0 
	MOVLW       0
	MOVWF       FARG_Read_RTC_END+1 
	CALL        _Read_RTC+0, 0
	MOVF        R0, 0 
	MOVWF       _hhh+0 
	MOVF        R1, 0 
	MOVWF       _hhh+1 
;rtc.c,175 :: 		Transform_Time(&sss,&mmm,&hhh);
	MOVLW       _sss+0
	MOVWF       FARG_Transform_Time_sec+0 
	MOVLW       hi_addr(_sss+0)
	MOVWF       FARG_Transform_Time_sec+1 
	MOVLW       _mmm+0
	MOVWF       FARG_Transform_Time_min+0 
	MOVLW       hi_addr(_mmm+0)
	MOVWF       FARG_Transform_Time_min+1 
	MOVLW       _hhh+0
	MOVWF       FARG_Transform_Time_hr+0 
	MOVLW       hi_addr(_hhh+0)
	MOVWF       FARG_Transform_Time_hr+1 
	CALL        _Transform_Time+0, 0
;rtc.c,177 :: 		inttostr(hhh, TXT);
	MOVF        _hhh+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _hhh+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _TXT+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;rtc.c,178 :: 		UART1_Write_Text(TXT);
	MOVLW       _TXT+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;rtc.c,179 :: 		UART1_Write(':');
	MOVLW       58
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rtc.c,180 :: 		inttostr(mmm, TXT);
	MOVF        _mmm+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _mmm+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _TXT+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;rtc.c,181 :: 		UART1_Write_Text(TXT);
	MOVLW       _TXT+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;rtc.c,182 :: 		UART1_Write(':');
	MOVLW       58
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rtc.c,183 :: 		inttostr(sss, TXT);
	MOVF        _sss+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _sss+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _TXT+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;rtc.c,184 :: 		UART1_Write_Text(TXT);
	MOVLW       _TXT+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;rtc.c,185 :: 		Pula_Linha();
	CALL        _Pula_Linha+0, 0
;rtc.c,186 :: 		delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main19:
	DECFSZ      R13, 1, 0
	BRA         L_main19
	DECFSZ      R12, 1, 0
	BRA         L_main19
	DECFSZ      R11, 1, 0
	BRA         L_main19
	NOP
	NOP
;rtc.c,187 :: 		}
	GOTO        L_main17
;rtc.c,209 :: 		}
	GOTO        $+0
; end of _main
