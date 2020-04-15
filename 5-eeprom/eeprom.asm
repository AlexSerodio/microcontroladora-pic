
_Pula_Linha:

;eeprom.c,50 :: 		void Pula_Linha(void)
;eeprom.c,52 :: 		UART1_WRITE(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;eeprom.c,53 :: 		UART1_WRITE(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;eeprom.c,54 :: 		}
	RETURN      0
; end of _Pula_Linha

_Move_Delay:

;eeprom.c,58 :: 		void Move_Delay() {                  // Function used for text moving
;eeprom.c,59 :: 		Delay_ms(100);                     // You can change the moving speed here
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
;eeprom.c,60 :: 		}
	RETURN      0
; end of _Move_Delay

_CustomChar:

;eeprom.c,69 :: 		void CustomChar() {
;eeprom.c,71 :: 		LCD_Cmd(64); //entra na CGRAM
	MOVLW       64
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;eeprom.c,72 :: 		for (i = 0; i<=7; i++) LCD_Chr_Cp(character_0[i]); //grava 8 bytes na cgram ENDER 0 a 7  cgram
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
;eeprom.c,73 :: 		for (i = 0; i<=7; i++) LCD_Chr_Cp(character_1[i]); //grava 8 bytes na cgram ENDER 8 a 15 cgram
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
;eeprom.c,74 :: 		LCD_Cmd(_LCD_RETURN_HOME); //sai da cgram
	MOVLW       2
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;eeprom.c,75 :: 		}
	RETURN      0
; end of _CustomChar

_Alert:

;eeprom.c,79 :: 		void Alert()
;eeprom.c,85 :: 		for(i=0; i<1; i++) {               // Move text to the right 4 times
	CLRF        Alert_i_L0+0 
	CLRF        Alert_i_L0+1 
L_Alert7:
	MOVLW       128
	XORWF       Alert_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Alert35
	MOVLW       1
	SUBWF       Alert_i_L0+0, 0 
L__Alert35:
	BTFSC       STATUS+0, 0 
	GOTO        L_Alert8
;eeprom.c,86 :: 		Lcd_Cmd(_LCD_SHIFT_RIGHT);
	MOVLW       28
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;eeprom.c,87 :: 		Move_Delay();
	CALL        _Move_Delay+0, 0
;eeprom.c,85 :: 		for(i=0; i<1; i++) {               // Move text to the right 4 times
	INFSNZ      Alert_i_L0+0, 1 
	INCF        Alert_i_L0+1, 1 
;eeprom.c,88 :: 		}
	GOTO        L_Alert7
L_Alert8:
;eeprom.c,89 :: 		for(i=0; i<1; i++) {               // Move text to the left 4 times
	CLRF        Alert_i_L0+0 
	CLRF        Alert_i_L0+1 
L_Alert10:
	MOVLW       128
	XORWF       Alert_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Alert36
	MOVLW       1
	SUBWF       Alert_i_L0+0, 0 
L__Alert36:
	BTFSC       STATUS+0, 0 
	GOTO        L_Alert11
;eeprom.c,90 :: 		Lcd_Cmd(_LCD_SHIFT_LEFT);
	MOVLW       24
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;eeprom.c,91 :: 		Move_Delay();
	CALL        _Move_Delay+0, 0
;eeprom.c,89 :: 		for(i=0; i<1; i++) {               // Move text to the left 4 times
	INFSNZ      Alert_i_L0+0, 1 
	INCF        Alert_i_L0+1, 1 
;eeprom.c,92 :: 		}
	GOTO        L_Alert10
L_Alert11:
;eeprom.c,96 :: 		}
	RETURN      0
; end of _Alert

_Write_RTC:

;eeprom.c,100 :: 		void Write_RTC(int END, int DADO)
;eeprom.c,102 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;eeprom.c,103 :: 		I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,104 :: 		I2C1_Wr(END);             // send byte (address of EEPROM location)
	MOVF        FARG_Write_RTC_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,105 :: 		I2C1_Wr(DADO);          // send data (data to be written)
	MOVF        FARG_Write_RTC_DADO+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,106 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;eeprom.c,107 :: 		}
	RETURN      0
; end of _Write_RTC

_Write_EEPROM:

;eeprom.c,109 :: 		void Write_EEPROM(int END, int DADO)
;eeprom.c,111 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;eeprom.c,112 :: 		I2C1_Wr(0xA0);          // send byte via I2C  (device address + W)
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,113 :: 		I2C1_Wr(END);             // send byte (address of EEPROM location)
	MOVF        FARG_Write_EEPROM_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,114 :: 		I2C1_Wr(DADO);          // send data (data to be written)
	MOVF        FARG_Write_EEPROM_DADO+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,115 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;eeprom.c,116 :: 		delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_Write_EEPROM13:
	DECFSZ      R13, 1, 0
	BRA         L_Write_EEPROM13
	DECFSZ      R12, 1, 0
	BRA         L_Write_EEPROM13
	NOP
;eeprom.c,117 :: 		}
	RETURN      0
; end of _Write_EEPROM

_Read_RTC:

;eeprom.c,119 :: 		int Read_RTC(int END)
;eeprom.c,123 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;eeprom.c,124 :: 		I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,125 :: 		I2C1_Wr(END);             // send byte (data address)
	MOVF        FARG_Read_RTC_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,126 :: 		I2C1_Repeated_Start();  // issue I2C signal repeated start
	CALL        _I2C1_Repeated_Start+0, 0
;eeprom.c,127 :: 		I2C1_Wr(0xD1);          // send byte (device address + R)
	MOVLW       209
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,128 :: 		Dado = I2C1_Rd(0u);    // Read the data (NO acknowledge)
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Dado_L0+0 
	MOVLW       0
	MOVWF       Read_RTC_Dado_L0+1 
;eeprom.c,129 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;eeprom.c,130 :: 		return(Dado);
	MOVF        Read_RTC_Dado_L0+0, 0 
	MOVWF       R0 
	MOVF        Read_RTC_Dado_L0+1, 0 
	MOVWF       R1 
;eeprom.c,131 :: 		}
	RETURN      0
; end of _Read_RTC

_Read_EEPROM:

;eeprom.c,133 :: 		int Read_EEPROM(int END)
;eeprom.c,137 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;eeprom.c,138 :: 		I2C1_Wr(0xA0);          // send byte via I2C  (device address + W)
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,139 :: 		I2C1_Wr(END);             // send byte (data address)
	MOVF        FARG_Read_EEPROM_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,140 :: 		I2C1_Repeated_Start();  // issue I2C signal repeated start
	CALL        _I2C1_Repeated_Start+0, 0
;eeprom.c,141 :: 		I2C1_Wr(0xA1);          // send byte (device address + R)
	MOVLW       161
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;eeprom.c,142 :: 		Dado = I2C1_Rd(0u);    // Read the data (NO acknowledge)
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_EEPROM_Dado_L0+0 
	MOVLW       0
	MOVWF       Read_EEPROM_Dado_L0+1 
;eeprom.c,143 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;eeprom.c,144 :: 		return(Dado);
	MOVF        Read_EEPROM_Dado_L0+0, 0 
	MOVWF       R0 
	MOVF        Read_EEPROM_Dado_L0+1, 0 
	MOVWF       R1 
;eeprom.c,145 :: 		}
	RETURN      0
; end of _Read_EEPROM

_Transform_Time:

;eeprom.c,148 :: 		void Transform_Time(char *sec, char *min, char *hr) {
;eeprom.c,149 :: 		*sec = ((*sec & 0xF0) >> 4)*10 + (*sec & 0x0F);
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
;eeprom.c,150 :: 		*min = ((*min & 0xF0) >> 4)*10 + (*min & 0x0F);
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
;eeprom.c,151 :: 		*hr = ((*hr & 0xF0) >> 4)*10 + (*hr & 0x0F);
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
;eeprom.c,152 :: 		}
	RETURN      0
; end of _Transform_Time

_main:

;eeprom.c,157 :: 		void main() {
;eeprom.c,158 :: 		UART1_Init(19200);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;eeprom.c,159 :: 		I2C1_Init(100000);// i2c para acessar ID = D0h  = RTC
	MOVLW       20
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;eeprom.c,161 :: 		ADCON1=0B00001110;
	MOVLW       14
	MOVWF       ADCON1+0 
;eeprom.c,162 :: 		TRISB = 0B00001111;
	MOVLW       15
	MOVWF       TRISB+0 
;eeprom.c,163 :: 		PORTB = 0B00000000;
	CLRF        PORTB+0 
;eeprom.c,164 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;eeprom.c,165 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;eeprom.c,166 :: 		CustomChar();
	CALL        _CustomChar+0, 0
;eeprom.c,168 :: 		if(PORTB == 0B00000100){
	MOVF        PORTB+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main14
;eeprom.c,169 :: 		Write_EEPROM(0, 0xFF);
	CLRF        FARG_Write_EEPROM_END+0 
	CLRF        FARG_Write_EEPROM_END+1 
	MOVLW       255
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;eeprom.c,170 :: 		Write_EEPROM(1, 0xFF);
	MOVLW       1
	MOVWF       FARG_Write_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_END+1 
	MOVLW       255
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;eeprom.c,171 :: 		Write_EEPROM(2, 0xFF);
	MOVLW       2
	MOVWF       FARG_Write_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_END+1 
	MOVLW       255
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;eeprom.c,172 :: 		UART1_Write_Text("A memoria foi limpa!");
	MOVLW       ?lstr1_eeprom+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_eeprom+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;eeprom.c,173 :: 		Pula_Linha();
	CALL        _Pula_Linha+0, 0
;eeprom.c,174 :: 		}
L_main14:
;eeprom.c,176 :: 		if(Read_EEPROM(0) == 0xFF || Read_EEPROM(1) == 0xFF || Read_EEPROM(2) == 0xFF) {
	CLRF        FARG_Read_EEPROM_END+0 
	CLRF        FARG_Read_EEPROM_END+1 
	CALL        _Read_EEPROM+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main37
	MOVLW       255
	XORWF       R0, 0 
L__main37:
	BTFSC       STATUS+0, 2 
	GOTO        L__main34
	MOVLW       1
	MOVWF       FARG_Read_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Read_EEPROM_END+1 
	CALL        _Read_EEPROM+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main38
	MOVLW       255
	XORWF       R0, 0 
L__main38:
	BTFSC       STATUS+0, 2 
	GOTO        L__main34
	MOVLW       2
	MOVWF       FARG_Read_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Read_EEPROM_END+1 
	CALL        _Read_EEPROM+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main39
	MOVLW       255
	XORWF       R0, 0 
L__main39:
	BTFSC       STATUS+0, 2 
	GOTO        L__main34
	GOTO        L_main17
L__main34:
;eeprom.c,177 :: 		UART1_Write_Text("QUAL A TEMPERATURA MAXIMA\r");
	MOVLW       ?lstr2_eeprom+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_eeprom+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;eeprom.c,178 :: 		while(!(UART1_Data_Ready() == 1));         //AGUARDA CHEGAR ALGO NA SERIAL VINDO DO TERMINAL BURRO
L_main18:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main19
	GOTO        L_main18
L_main19:
;eeprom.c,179 :: 		UART1_Read_Text(ENTRADA, ENTER, 32);
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
;eeprom.c,180 :: 		UART1_Write_Text(ENTRADA);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;eeprom.c,181 :: 		Pula_Linha();
	CALL        _Pula_Linha+0, 0
;eeprom.c,183 :: 		temp=atoi(ENTRADA);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _temp+0 
	MOVF        R1, 0 
	MOVWF       _temp+1 
;eeprom.c,184 :: 		Write_EEPROM(0, temp);
	CLRF        FARG_Write_EEPROM_END+0 
	CLRF        FARG_Write_EEPROM_END+1 
	MOVF        R0, 0 
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVF        R1, 0 
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;eeprom.c,186 :: 		UART1_Write_Text("QUAL A HORA MAXIMA\r");
	MOVLW       ?lstr3_eeprom+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_eeprom+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;eeprom.c,187 :: 		while(!(UART1_Data_Ready() == 1));         //AGUARDA CHEGAR ALGO NA SERIAL VINDO DO TERMINAL BURRO
L_main20:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main21
	GOTO        L_main20
L_main21:
;eeprom.c,188 :: 		UART1_Read_Text(ENTRADA2, ENTER, 32);
	MOVLW       _ENTRADA2+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_ENTRADA2+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       _ENTER+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(_ENTER+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       32
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;eeprom.c,189 :: 		UART1_Write_Text(ENTRADA2);
	MOVLW       _ENTRADA2+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_ENTRADA2+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;eeprom.c,190 :: 		Pula_Linha();
	CALL        _Pula_Linha+0, 0
;eeprom.c,192 :: 		hora_maxima=atoi(ENTRADA2);
	MOVLW       _ENTRADA2+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_ENTRADA2+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _hora_maxima+0 
	MOVF        R1, 0 
	MOVWF       _hora_maxima+1 
;eeprom.c,193 :: 		Write_EEPROM(1, hora_maxima);
	MOVLW       1
	MOVWF       FARG_Write_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_END+1 
	MOVF        R0, 0 
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVF        R1, 0 
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;eeprom.c,195 :: 		UART1_Write_Text("QUAL O MINUTO MAXIMO\r");
	MOVLW       ?lstr4_eeprom+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_eeprom+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;eeprom.c,196 :: 		while(!(UART1_Data_Ready() == 1));         //AGUARDA CHEGAR ALGO NA SERIAL VINDO DO TERMINAL BURRO
L_main22:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main23
	GOTO        L_main22
L_main23:
;eeprom.c,197 :: 		UART1_Read_Text(ENTRADA2, ENTER, 32);
	MOVLW       _ENTRADA2+0
	MOVWF       FARG_UART1_Read_Text_Output+0 
	MOVLW       hi_addr(_ENTRADA2+0)
	MOVWF       FARG_UART1_Read_Text_Output+1 
	MOVLW       _ENTER+0
	MOVWF       FARG_UART1_Read_Text_Delimiter+0 
	MOVLW       hi_addr(_ENTER+0)
	MOVWF       FARG_UART1_Read_Text_Delimiter+1 
	MOVLW       32
	MOVWF       FARG_UART1_Read_Text_Attempts+0 
	CALL        _UART1_Read_Text+0, 0
;eeprom.c,198 :: 		UART1_Write_Text(ENTRADA2);
	MOVLW       _ENTRADA2+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_ENTRADA2+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;eeprom.c,199 :: 		Pula_Linha();
	CALL        _Pula_Linha+0, 0
;eeprom.c,201 :: 		minuto_maximo=atoi(ENTRADA2);
	MOVLW       _ENTRADA2+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_ENTRADA2+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _minuto_maximo+0 
	MOVF        R1, 0 
	MOVWF       _minuto_maximo+1 
;eeprom.c,202 :: 		Write_EEPROM(2, minuto_maximo);
	MOVLW       2
	MOVWF       FARG_Write_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_END+1 
	MOVF        R0, 0 
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVF        R1, 0 
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;eeprom.c,203 :: 		} else {
	GOTO        L_main24
L_main17:
;eeprom.c,204 :: 		temp = Read_EEPROM(0);
	CLRF        FARG_Read_EEPROM_END+0 
	CLRF        FARG_Read_EEPROM_END+1 
	CALL        _Read_EEPROM+0, 0
	MOVF        R0, 0 
	MOVWF       _temp+0 
	MOVF        R1, 0 
	MOVWF       _temp+1 
;eeprom.c,205 :: 		inttostr(temp, ENTRADA);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _ENTRADA+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;eeprom.c,207 :: 		hora_maxima = Read_EEPROM(1);
	MOVLW       1
	MOVWF       FARG_Read_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Read_EEPROM_END+1 
	CALL        _Read_EEPROM+0, 0
	MOVF        R0, 0 
	MOVWF       _hora_maxima+0 
	MOVF        R1, 0 
	MOVWF       _hora_maxima+1 
;eeprom.c,208 :: 		minuto_maximo = Read_EEPROM(2);
	MOVLW       2
	MOVWF       FARG_Read_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Read_EEPROM_END+1 
	CALL        _Read_EEPROM+0, 0
	MOVF        R0, 0 
	MOVWF       _minuto_maximo+0 
	MOVF        R1, 0 
	MOVWF       _minuto_maximo+1 
;eeprom.c,209 :: 		}
L_main24:
;eeprom.c,211 :: 		Lcd_Out(1, 1, "TEMP. ATUAL:");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_eeprom+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_eeprom+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;eeprom.c,212 :: 		Lcd_Out(2, 1, "TEMP. MAX:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_eeprom+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_eeprom+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;eeprom.c,213 :: 		lcd_Out(2, 13, ENTRADA);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _ENTRADA+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;eeprom.c,214 :: 		lcd_chr_cp(0);
	CLRF        FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;eeprom.c,215 :: 		lcd_chr_cp('C');
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;eeprom.c,216 :: 		while(1) {
L_main25:
;eeprom.c,217 :: 		sss= Read_RTC(0); //le segundos
	CLRF        FARG_Read_RTC_END+0 
	CLRF        FARG_Read_RTC_END+1 
	CALL        _Read_RTC+0, 0
	MOVF        R0, 0 
	MOVWF       _sss+0 
	MOVF        R1, 0 
	MOVWF       _sss+1 
;eeprom.c,218 :: 		mmm= Read_RTC(1); //le minutos
	MOVLW       1
	MOVWF       FARG_Read_RTC_END+0 
	MOVLW       0
	MOVWF       FARG_Read_RTC_END+1 
	CALL        _Read_RTC+0, 0
	MOVF        R0, 0 
	MOVWF       _mmm+0 
	MOVF        R1, 0 
	MOVWF       _mmm+1 
;eeprom.c,219 :: 		hhh= Read_RTC(2); //le horas
	MOVLW       2
	MOVWF       FARG_Read_RTC_END+0 
	MOVLW       0
	MOVWF       FARG_Read_RTC_END+1 
	CALL        _Read_RTC+0, 0
	MOVF        R0, 0 
	MOVWF       _hhh+0 
	MOVF        R1, 0 
	MOVWF       _hhh+1 
;eeprom.c,220 :: 		Transform_Time(&sss,&mmm,&hhh);
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
;eeprom.c,222 :: 		sprintf(HORA_TXT, "T: %02d:%02d", hhh, mmm);
	MOVLW       _HORA_TXT+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_HORA_TXT+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_7_eeprom+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_7_eeprom+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_7_eeprom+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _hhh+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _hhh+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _mmm+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        _mmm+1, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;eeprom.c,223 :: 		lcd_Out(4, 1, HORA_TXT);
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _HORA_TXT+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_HORA_TXT+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;eeprom.c,225 :: 		sprintf(HORA_TXT, "M: %02d:%02d", hora_maxima, minuto_maximo);
	MOVLW       _HORA_TXT+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_HORA_TXT+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_8_eeprom+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_8_eeprom+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_8_eeprom+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _hora_maxima+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _hora_maxima+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _minuto_maximo+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        _minuto_maximo+1, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;eeprom.c,226 :: 		lcd_Out(4, 13, HORA_TXT);
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _HORA_TXT+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_HORA_TXT+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;eeprom.c,231 :: 		AD = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _AD+0 
	MOVF        R1, 0 
	MOVWF       _AD+1 
;eeprom.c,232 :: 		Temperatura = ((float) AD * 5.0/1024.0) * 100.0;
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
;eeprom.c,233 :: 		inttostr(Temperatura, TXT);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _TXT+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;eeprom.c,236 :: 		Lcd_Out(1, 13, TXT);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _TXT+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;eeprom.c,237 :: 		Lcd_Chr_Cp(0);
	CLRF        FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;eeprom.c,238 :: 		Lcd_Chr_CP('C');
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;eeprom.c,239 :: 		if(Temperatura >= temp && (hhh >= hora_maxima && mmm >= minuto_maximo))
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _temp+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main40
	MOVF        _temp+0, 0 
	SUBWF       _Temperatura+0, 0 
L__main40:
	BTFSS       STATUS+0, 0 
	GOTO        L_main31
	MOVLW       128
	XORWF       _hhh+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _hora_maxima+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main41
	MOVF        _hora_maxima+0, 0 
	SUBWF       _hhh+0, 0 
L__main41:
	BTFSS       STATUS+0, 0 
	GOTO        L_main31
	MOVLW       128
	XORWF       _mmm+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _minuto_maximo+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main42
	MOVF        _minuto_maximo+0, 0 
	SUBWF       _mmm+0, 0 
L__main42:
	BTFSS       STATUS+0, 0 
	GOTO        L_main31
L__main33:
L__main32:
;eeprom.c,240 :: 		Alert();
	CALL        _Alert+0, 0
L_main31:
;eeprom.c,241 :: 		}
	GOTO        L_main25
;eeprom.c,242 :: 		}
	GOTO        $+0
; end of _main
