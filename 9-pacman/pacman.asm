
_InitTimer2_Int0:

;pacman.c,38 :: 		void InitTimer2_Int0(){
;pacman.c,39 :: 		T2CON         = 0x3C;
	MOVLW       60
	MOVWF       T2CON+0 
;pacman.c,40 :: 		TMR2IE_bit         = 1;
	BSF         TMR2IE_bit+0, 1 
;pacman.c,41 :: 		PR2                 = 249;
	MOVLW       249
	MOVWF       PR2+0 
;pacman.c,42 :: 		INTCON         = 0xD0;  //INTCON = 1100 0000 (HABILITA TMR2 INTERRUPT E INT0 INTERRUPT)
	MOVLW       208
	MOVWF       INTCON+0 
;pacman.c,43 :: 		}
	RETURN      0
; end of _InitTimer2_Int0

_interrupt:

;pacman.c,45 :: 		void interrupt() {
;pacman.c,46 :: 		if(int0if_bit)
	BTFSS       INT0IF_bit+0, 1 
	GOTO        L_interrupt0
;pacman.c,48 :: 		cnt2++;
	INFSNZ      _cnt2+0, 1 
	INCF        _cnt2+1, 1 
;pacman.c,50 :: 		if(cnt2>4){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _cnt2+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt99
	MOVF        _cnt2+0, 0 
	SUBLW       4
L__interrupt99:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt1
;pacman.c,51 :: 		cnt2=0;
	CLRF        _cnt2+0 
	CLRF        _cnt2+1 
;pacman.c,52 :: 		PORTA.F2 = ~PORTA.F2;
	BTG         PORTA+0, 2 
;pacman.c,53 :: 		}
L_interrupt1:
;pacman.c,54 :: 		int0if_bit=0;   // clear int0if_bit
	BCF         INT0IF_bit+0, 1 
;pacman.c,55 :: 		}
L_interrupt0:
;pacman.c,57 :: 		if (TMR2IF_bit) {
	BTFSS       TMR2IF_bit+0, 1 
	GOTO        L_interrupt2
;pacman.c,58 :: 		cnt++;
	INFSNZ      _cnt+0, 1 
	INCF        _cnt+1, 1 
;pacman.c,59 :: 		if (cnt >= 1000) {
	MOVLW       128
	XORWF       _cnt+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt100
	MOVLW       232
	SUBWF       _cnt+0, 0 
L__interrupt100:
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt3
;pacman.c,60 :: 		PORTA.F1 = ~PORTA.F1;
	BTG         PORTA+0, 1 
;pacman.c,61 :: 		cnt = 0;
	CLRF        _cnt+0 
	CLRF        _cnt+1 
;pacman.c,62 :: 		}
L_interrupt3:
;pacman.c,63 :: 		TMR2IF_bit = 0;        // clear TMR2IF
	BCF         TMR2IF_bit+0, 1 
;pacman.c,64 :: 		}
L_interrupt2:
;pacman.c,65 :: 		}
L__interrupt98:
	RETFIE      1
; end of _interrupt

_Le_Teclado:

;pacman.c,68 :: 		short Le_Teclado()
;pacman.c,70 :: 		PORTD = 0B00010000; // VOCÊ SELECIONOU LA
	MOVLW       16
	MOVWF       PORTD+0 
;pacman.c,71 :: 		if (PORTA.RA5 == 1) {
	BTFSS       PORTA+0, 5 
	GOTO        L_Le_Teclado4
;pacman.c,72 :: 		while(PORTA.RA5 == 1);
L_Le_Teclado5:
	BTFSS       PORTA+0, 5 
	GOTO        L_Le_Teclado6
	GOTO        L_Le_Teclado5
L_Le_Teclado6:
;pacman.c,73 :: 		return '7';
	MOVLW       55
	MOVWF       R0 
	RETURN      0
;pacman.c,74 :: 		}
L_Le_Teclado4:
;pacman.c,75 :: 		if (PORTB.RB1 == 1) {
	BTFSS       PORTB+0, 1 
	GOTO        L_Le_Teclado7
;pacman.c,76 :: 		while(PORTB.RB1 == 1);
L_Le_Teclado8:
	BTFSS       PORTB+0, 1 
	GOTO        L_Le_Teclado9
	GOTO        L_Le_Teclado8
L_Le_Teclado9:
;pacman.c,77 :: 		return '8';
	MOVLW       56
	MOVWF       R0 
	RETURN      0
;pacman.c,78 :: 		}
L_Le_Teclado7:
;pacman.c,79 :: 		if (PORTB.RB2 == 1) {
	BTFSS       PORTB+0, 2 
	GOTO        L_Le_Teclado10
;pacman.c,80 :: 		while(PORTB.RB2 == 1);
L_Le_Teclado11:
	BTFSS       PORTB+0, 2 
	GOTO        L_Le_Teclado12
	GOTO        L_Le_Teclado11
L_Le_Teclado12:
;pacman.c,81 :: 		return '9';
	MOVLW       57
	MOVWF       R0 
	RETURN      0
;pacman.c,82 :: 		}
L_Le_Teclado10:
;pacman.c,83 :: 		if (PORTB.RB3 == 1) {
	BTFSS       PORTB+0, 3 
	GOTO        L_Le_Teclado13
;pacman.c,84 :: 		while(PORTB.RB3 == 1);
L_Le_Teclado14:
	BTFSS       PORTB+0, 3 
	GOTO        L_Le_Teclado15
	GOTO        L_Le_Teclado14
L_Le_Teclado15:
;pacman.c,85 :: 		return '%';
	MOVLW       37
	MOVWF       R0 
	RETURN      0
;pacman.c,86 :: 		}
L_Le_Teclado13:
;pacman.c,88 :: 		PORTD = 0B00100000; // VOCÊ SELECIONOU LB
	MOVLW       32
	MOVWF       PORTD+0 
;pacman.c,89 :: 		if (PORTA.RA5 == 1) {
	BTFSS       PORTA+0, 5 
	GOTO        L_Le_Teclado16
;pacman.c,90 :: 		while(PORTA.RA5 == 1);
L_Le_Teclado17:
	BTFSS       PORTA+0, 5 
	GOTO        L_Le_Teclado18
	GOTO        L_Le_Teclado17
L_Le_Teclado18:
;pacman.c,91 :: 		return '4';
	MOVLW       52
	MOVWF       R0 
	RETURN      0
;pacman.c,92 :: 		}
L_Le_Teclado16:
;pacman.c,93 :: 		if (PORTB.RB1 == 1) {
	BTFSS       PORTB+0, 1 
	GOTO        L_Le_Teclado19
;pacman.c,94 :: 		while(PORTB.RB1 == 1);
L_Le_Teclado20:
	BTFSS       PORTB+0, 1 
	GOTO        L_Le_Teclado21
	GOTO        L_Le_Teclado20
L_Le_Teclado21:
;pacman.c,95 :: 		return '5';
	MOVLW       53
	MOVWF       R0 
	RETURN      0
;pacman.c,96 :: 		}
L_Le_Teclado19:
;pacman.c,97 :: 		if (PORTB.RB2 == 1) {
	BTFSS       PORTB+0, 2 
	GOTO        L_Le_Teclado22
;pacman.c,98 :: 		while(PORTB.RB2 == 1);
L_Le_Teclado23:
	BTFSS       PORTB+0, 2 
	GOTO        L_Le_Teclado24
	GOTO        L_Le_Teclado23
L_Le_Teclado24:
;pacman.c,99 :: 		return '6';
	MOVLW       54
	MOVWF       R0 
	RETURN      0
;pacman.c,100 :: 		}
L_Le_Teclado22:
;pacman.c,101 :: 		if (PORTB.RB3 == 1) {
	BTFSS       PORTB+0, 3 
	GOTO        L_Le_Teclado25
;pacman.c,102 :: 		while(PORTB.RB3 == 1);
L_Le_Teclado26:
	BTFSS       PORTB+0, 3 
	GOTO        L_Le_Teclado27
	GOTO        L_Le_Teclado26
L_Le_Teclado27:
;pacman.c,103 :: 		return '*';
	MOVLW       42
	MOVWF       R0 
	RETURN      0
;pacman.c,104 :: 		}
L_Le_Teclado25:
;pacman.c,106 :: 		PORTD = 0B01000000; // VOCÊ SELECIONOU LC
	MOVLW       64
	MOVWF       PORTD+0 
;pacman.c,107 :: 		if (PORTA.RA5 == 1) {
	BTFSS       PORTA+0, 5 
	GOTO        L_Le_Teclado28
;pacman.c,108 :: 		while(PORTA.RA5 == 1);
L_Le_Teclado29:
	BTFSS       PORTA+0, 5 
	GOTO        L_Le_Teclado30
	GOTO        L_Le_Teclado29
L_Le_Teclado30:
;pacman.c,109 :: 		return '1';
	MOVLW       49
	MOVWF       R0 
	RETURN      0
;pacman.c,110 :: 		}
L_Le_Teclado28:
;pacman.c,111 :: 		if (PORTB.RB1 == 1) {
	BTFSS       PORTB+0, 1 
	GOTO        L_Le_Teclado31
;pacman.c,112 :: 		while(PORTB.RB1 == 1);
L_Le_Teclado32:
	BTFSS       PORTB+0, 1 
	GOTO        L_Le_Teclado33
	GOTO        L_Le_Teclado32
L_Le_Teclado33:
;pacman.c,113 :: 		return '2';
	MOVLW       50
	MOVWF       R0 
	RETURN      0
;pacman.c,114 :: 		}
L_Le_Teclado31:
;pacman.c,115 :: 		if (PORTB.RB2 == 1) {
	BTFSS       PORTB+0, 2 
	GOTO        L_Le_Teclado34
;pacman.c,116 :: 		while(PORTB.RB2 == 1);
L_Le_Teclado35:
	BTFSS       PORTB+0, 2 
	GOTO        L_Le_Teclado36
	GOTO        L_Le_Teclado35
L_Le_Teclado36:
;pacman.c,117 :: 		return '3';
	MOVLW       51
	MOVWF       R0 
	RETURN      0
;pacman.c,118 :: 		}
L_Le_Teclado34:
;pacman.c,119 :: 		if (PORTB.RB3 == 1) {
	BTFSS       PORTB+0, 3 
	GOTO        L_Le_Teclado37
;pacman.c,120 :: 		while(PORTB.RB3 == 1);
L_Le_Teclado38:
	BTFSS       PORTB+0, 3 
	GOTO        L_Le_Teclado39
	GOTO        L_Le_Teclado38
L_Le_Teclado39:
;pacman.c,121 :: 		return '-';
	MOVLW       45
	MOVWF       R0 
	RETURN      0
;pacman.c,122 :: 		}
L_Le_Teclado37:
;pacman.c,124 :: 		PORTD = 0B10000000; // VOCÊ SELECIONOU LD
	MOVLW       128
	MOVWF       PORTD+0 
;pacman.c,125 :: 		if (PORTA.RA5 == 1) {
	BTFSS       PORTA+0, 5 
	GOTO        L_Le_Teclado40
;pacman.c,126 :: 		while(PORTA.RA5 == 1);
L_Le_Teclado41:
	BTFSS       PORTA+0, 5 
	GOTO        L_Le_Teclado42
	GOTO        L_Le_Teclado41
L_Le_Teclado42:
;pacman.c,127 :: 		return 'C';
	MOVLW       67
	MOVWF       R0 
	RETURN      0
;pacman.c,128 :: 		}
L_Le_Teclado40:
;pacman.c,129 :: 		if (PORTB.RB1 == 1) {
	BTFSS       PORTB+0, 1 
	GOTO        L_Le_Teclado43
;pacman.c,130 :: 		while(PORTB.RB1 == 1);
L_Le_Teclado44:
	BTFSS       PORTB+0, 1 
	GOTO        L_Le_Teclado45
	GOTO        L_Le_Teclado44
L_Le_Teclado45:
;pacman.c,131 :: 		return '0';
	MOVLW       48
	MOVWF       R0 
	RETURN      0
;pacman.c,132 :: 		}
L_Le_Teclado43:
;pacman.c,133 :: 		if (PORTB.RB2 == 1) {
	BTFSS       PORTB+0, 2 
	GOTO        L_Le_Teclado46
;pacman.c,134 :: 		while(PORTB.RB2 == 1);
L_Le_Teclado47:
	BTFSS       PORTB+0, 2 
	GOTO        L_Le_Teclado48
	GOTO        L_Le_Teclado47
L_Le_Teclado48:
;pacman.c,135 :: 		return '=';
	MOVLW       61
	MOVWF       R0 
	RETURN      0
;pacman.c,136 :: 		}
L_Le_Teclado46:
;pacman.c,137 :: 		if (PORTB.RB3 == 1) {
	BTFSS       PORTB+0, 3 
	GOTO        L_Le_Teclado49
;pacman.c,138 :: 		while(PORTB.RB3 == 1);
L_Le_Teclado50:
	BTFSS       PORTB+0, 3 
	GOTO        L_Le_Teclado51
	GOTO        L_Le_Teclado50
L_Le_Teclado51:
;pacman.c,139 :: 		return '+';
	MOVLW       43
	MOVWF       R0 
	RETURN      0
;pacman.c,140 :: 		}
L_Le_Teclado49:
;pacman.c,142 :: 		return 255;
	MOVLW       255
	MOVWF       R0 
;pacman.c,143 :: 		}
	RETURN      0
; end of _Le_Teclado

_Pula_Linha:

;pacman.c,145 :: 		void Pula_Linha(void)
;pacman.c,147 :: 		UART1_WRITE(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;pacman.c,148 :: 		UART1_WRITE(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;pacman.c,149 :: 		}
	RETURN      0
; end of _Pula_Linha

_Move_Delay:

;pacman.c,151 :: 		void Move_Delay() {                  // Function used for text moving
;pacman.c,152 :: 		Delay_ms(100);                     // You can change the moving speed here
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_Move_Delay52:
	DECFSZ      R13, 1, 0
	BRA         L_Move_Delay52
	DECFSZ      R12, 1, 0
	BRA         L_Move_Delay52
	DECFSZ      R11, 1, 0
	BRA         L_Move_Delay52
	NOP
;pacman.c,153 :: 		}
	RETURN      0
; end of _Move_Delay

_CustomChar:

;pacman.c,158 :: 		void CustomChar() {
;pacman.c,160 :: 		LCD_Cmd(64); //entra na CGRAM
	MOVLW       64
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,161 :: 		for (i = 0; i<=7; i++) LCD_Chr_Cp(character_0[i]); //grava 8 bytes na cgram ENDER 0 a 7  cgram
	CLRF        CustomChar_i_L0+0 
L_CustomChar53:
	MOVF        CustomChar_i_L0+0, 0 
	SUBLW       7
	BTFSS       STATUS+0, 0 
	GOTO        L_CustomChar54
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
	GOTO        L_CustomChar53
L_CustomChar54:
;pacman.c,162 :: 		for (i = 0; i<=7; i++) LCD_Chr_Cp(character_1[i]); //grava 8 bytes na cgram ENDER 8 a 15 cgram
	CLRF        CustomChar_i_L0+0 
L_CustomChar56:
	MOVF        CustomChar_i_L0+0, 0 
	SUBLW       7
	BTFSS       STATUS+0, 0 
	GOTO        L_CustomChar57
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
	GOTO        L_CustomChar56
L_CustomChar57:
;pacman.c,163 :: 		LCD_Cmd(_LCD_RETURN_HOME); //sai da cgram
	MOVLW       2
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,164 :: 		}
	RETURN      0
; end of _CustomChar

_Alert:

;pacman.c,166 :: 		void Alert()
;pacman.c,169 :: 		for(i=0; i<1; i++) {               // Move text to the right 4 times
	CLRF        Alert_i_L0+0 
	CLRF        Alert_i_L0+1 
L_Alert59:
	MOVLW       128
	XORWF       Alert_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Alert101
	MOVLW       1
	SUBWF       Alert_i_L0+0, 0 
L__Alert101:
	BTFSC       STATUS+0, 0 
	GOTO        L_Alert60
;pacman.c,170 :: 		Lcd_Cmd(_LCD_SHIFT_RIGHT);
	MOVLW       28
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,171 :: 		Move_Delay();
	CALL        _Move_Delay+0, 0
;pacman.c,169 :: 		for(i=0; i<1; i++) {               // Move text to the right 4 times
	INFSNZ      Alert_i_L0+0, 1 
	INCF        Alert_i_L0+1, 1 
;pacman.c,172 :: 		}
	GOTO        L_Alert59
L_Alert60:
;pacman.c,173 :: 		for(i=0; i<1; i++) {               // Move text to the left 4 times
	CLRF        Alert_i_L0+0 
	CLRF        Alert_i_L0+1 
L_Alert62:
	MOVLW       128
	XORWF       Alert_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Alert102
	MOVLW       1
	SUBWF       Alert_i_L0+0, 0 
L__Alert102:
	BTFSC       STATUS+0, 0 
	GOTO        L_Alert63
;pacman.c,174 :: 		Lcd_Cmd(_LCD_SHIFT_LEFT);
	MOVLW       24
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,175 :: 		Move_Delay();
	CALL        _Move_Delay+0, 0
;pacman.c,173 :: 		for(i=0; i<1; i++) {               // Move text to the left 4 times
	INFSNZ      Alert_i_L0+0, 1 
	INCF        Alert_i_L0+1, 1 
;pacman.c,176 :: 		}
	GOTO        L_Alert62
L_Alert63:
;pacman.c,177 :: 		}
	RETURN      0
; end of _Alert

_Write_EEPROM:

;pacman.c,179 :: 		void Write_EEPROM(int END, int DADO)
;pacman.c,181 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;pacman.c,182 :: 		I2C1_Wr(0xA0);          // send byte via I2C  (device address + W)
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,183 :: 		I2C1_Wr(END);             // send byte (address of EEPROM location)
	MOVF        FARG_Write_EEPROM_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,184 :: 		I2C1_Wr(DADO);          // send data (data to be written)
	MOVF        FARG_Write_EEPROM_DADO+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,185 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;pacman.c,186 :: 		delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_Write_EEPROM65:
	DECFSZ      R13, 1, 0
	BRA         L_Write_EEPROM65
	DECFSZ      R12, 1, 0
	BRA         L_Write_EEPROM65
	NOP
;pacman.c,187 :: 		}
	RETURN      0
; end of _Write_EEPROM

_Read_EEPROM:

;pacman.c,189 :: 		int Read_EEPROM(int END)
;pacman.c,192 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;pacman.c,193 :: 		I2C1_Wr(0xA0);          // send byte via I2C  (device address + W)
	MOVLW       160
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,194 :: 		I2C1_Wr(END);             // send byte (data address)
	MOVF        FARG_Read_EEPROM_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,195 :: 		I2C1_Repeated_Start();  // issue I2C signal repeated start
	CALL        _I2C1_Repeated_Start+0, 0
;pacman.c,196 :: 		I2C1_Wr(0xA1);          // send byte (device address + R)
	MOVLW       161
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,197 :: 		Dado = I2C1_Rd(0u);    // Read the data (NO acknowledge)
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_EEPROM_Dado_L0+0 
	MOVLW       0
	MOVWF       Read_EEPROM_Dado_L0+1 
;pacman.c,198 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;pacman.c,199 :: 		return(Dado);
	MOVF        Read_EEPROM_Dado_L0+0, 0 
	MOVWF       R0 
	MOVF        Read_EEPROM_Dado_L0+1, 0 
	MOVWF       R1 
;pacman.c,200 :: 		}
	RETURN      0
; end of _Read_EEPROM

_Write_RTC:

;pacman.c,202 :: 		void Write_RTC(int END, int DADO)
;pacman.c,204 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;pacman.c,205 :: 		I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,206 :: 		I2C1_Wr(END);             // send byte (address of EEPROM location)
	MOVF        FARG_Write_RTC_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,207 :: 		I2C1_Wr(DADO);          // send data (data to be written)
	MOVF        FARG_Write_RTC_DADO+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,208 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;pacman.c,209 :: 		}
	RETURN      0
; end of _Write_RTC

_Read_RTC:

;pacman.c,211 :: 		int Read_RTC(int END)
;pacman.c,214 :: 		I2C1_Start();           // issue I2C start signal
	CALL        _I2C1_Start+0, 0
;pacman.c,215 :: 		I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,216 :: 		I2C1_Wr(END);             // send byte (data address)
	MOVF        FARG_Read_RTC_END+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,217 :: 		I2C1_Repeated_Start();  // issue I2C signal repeated start
	CALL        _I2C1_Repeated_Start+0, 0
;pacman.c,218 :: 		I2C1_Wr(0xD1);          // send byte (device address + R)
	MOVLW       209
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;pacman.c,219 :: 		Dado = I2C1_Rd(0u);    // Read the data (NO acknowledge)
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       Read_RTC_Dado_L0+0 
	MOVLW       0
	MOVWF       Read_RTC_Dado_L0+1 
;pacman.c,220 :: 		I2C1_Stop();            // issue I2C stop signal
	CALL        _I2C1_Stop+0, 0
;pacman.c,221 :: 		return(Dado);
	MOVF        Read_RTC_Dado_L0+0, 0 
	MOVWF       R0 
	MOVF        Read_RTC_Dado_L0+1, 0 
	MOVWF       R1 
;pacman.c,222 :: 		}
	RETURN      0
; end of _Read_RTC

_Transform_Time:

;pacman.c,224 :: 		void Transform_Time(char *sec, char *min, char *hr) {
;pacman.c,225 :: 		*sec = ((*sec & 0xF0) >> 4)*10 + (*sec & 0x0F);
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
;pacman.c,226 :: 		*min = ((*min & 0xF0) >> 4)*10 + (*min & 0x0F);
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
;pacman.c,227 :: 		*hr = ((*hr & 0xF0) >> 4)*10 + (*hr & 0x0F);
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
;pacman.c,228 :: 		}
	RETURN      0
; end of _Transform_Time

_Le_Entrada_Cmd:

;pacman.c,232 :: 		void Le_Entrada_Cmd(char slot[], int showInput, int row, int column) {
;pacman.c,233 :: 		for (i = 0; i < sizeof(slot); i++) {
	CLRF        _i+0 
	CLRF        _i+1 
L_Le_Entrada_Cmd66:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Le_Entrada_Cmd103
	MOVLW       2
	SUBWF       _i+0, 0 
L__Le_Entrada_Cmd103:
	BTFSC       STATUS+0, 0 
	GOTO        L_Le_Entrada_Cmd67
;pacman.c,234 :: 		slot[i] = 0;
	MOVF        _i+0, 0 
	ADDWF       FARG_Le_Entrada_Cmd_slot+0, 0 
	MOVWF       FSR1L 
	MOVF        _i+1, 0 
	ADDWFC      FARG_Le_Entrada_Cmd_slot+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;pacman.c,233 :: 		for (i = 0; i < sizeof(slot); i++) {
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;pacman.c,235 :: 		}
	GOTO        L_Le_Entrada_Cmd66
L_Le_Entrada_Cmd67:
;pacman.c,236 :: 		i = 0;
	CLRF        _i+0 
	CLRF        _i+1 
;pacman.c,237 :: 		while((_char = Le_Teclado()) != '=')
L_Le_Entrada_Cmd69:
	CALL        _Le_Teclado+0, 0
	MOVF        R0, 0 
	MOVWF       __char+0 
	MOVF        R0, 0 
	XORLW       61
	BTFSC       STATUS+0, 2 
	GOTO        L_Le_Entrada_Cmd70
;pacman.c,239 :: 		if (_char != 255) {
	MOVF        __char+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_Le_Entrada_Cmd71
;pacman.c,240 :: 		if (_char == '*') {
	MOVF        __char+0, 0 
	XORLW       42
	BTFSS       STATUS+0, 2 
	GOTO        L_Le_Entrada_Cmd72
;pacman.c,241 :: 		if (i > 0) i--;
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _i+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Le_Entrada_Cmd104
	MOVF        _i+0, 0 
	SUBLW       0
L__Le_Entrada_Cmd104:
	BTFSC       STATUS+0, 0 
	GOTO        L_Le_Entrada_Cmd73
	MOVLW       1
	SUBWF       _i+0, 1 
	MOVLW       0
	SUBWFB      _i+1, 1 
L_Le_Entrada_Cmd73:
;pacman.c,242 :: 		slot[i] = 0;
	MOVF        _i+0, 0 
	ADDWF       FARG_Le_Entrada_Cmd_slot+0, 0 
	MOVWF       FSR1L 
	MOVF        _i+1, 0 
	ADDWFC      FARG_Le_Entrada_Cmd_slot+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;pacman.c,243 :: 		if (showInput) {
	MOVF        FARG_Le_Entrada_Cmd_showInput+0, 0 
	IORWF       FARG_Le_Entrada_Cmd_showInput+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Le_Entrada_Cmd74
;pacman.c,244 :: 		Lcd_Out(row, column + i, " ");
	MOVF        FARG_Le_Entrada_Cmd_row+0, 0 
	MOVWF       FARG_Lcd_Out_row+0 
	MOVF        _i+0, 0 
	ADDWF       FARG_Le_Entrada_Cmd_column+0, 0 
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,245 :: 		}
L_Le_Entrada_Cmd74:
;pacman.c,246 :: 		} else {
	GOTO        L_Le_Entrada_Cmd75
L_Le_Entrada_Cmd72:
;pacman.c,247 :: 		slot[i] = _char;
	MOVF        _i+0, 0 
	ADDWF       FARG_Le_Entrada_Cmd_slot+0, 0 
	MOVWF       FSR1L 
	MOVF        _i+1, 0 
	ADDWFC      FARG_Le_Entrada_Cmd_slot+1, 0 
	MOVWF       FSR1H 
	MOVF        __char+0, 0 
	MOVWF       POSTINC1+0 
;pacman.c,248 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;pacman.c,249 :: 		if (showInput) {
	MOVF        FARG_Le_Entrada_Cmd_showInput+0, 0 
	IORWF       FARG_Le_Entrada_Cmd_showInput+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Le_Entrada_Cmd76
;pacman.c,250 :: 		Lcd_Out(row, column, slot);
	MOVF        FARG_Le_Entrada_Cmd_row+0, 0 
	MOVWF       FARG_Lcd_Out_row+0 
	MOVF        FARG_Le_Entrada_Cmd_column+0, 0 
	MOVWF       FARG_Lcd_Out_column+0 
	MOVF        FARG_Le_Entrada_Cmd_slot+0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        FARG_Le_Entrada_Cmd_slot+1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,251 :: 		}
L_Le_Entrada_Cmd76:
;pacman.c,252 :: 		}
L_Le_Entrada_Cmd75:
;pacman.c,253 :: 		}
L_Le_Entrada_Cmd71:
;pacman.c,254 :: 		}
	GOTO        L_Le_Entrada_Cmd69
L_Le_Entrada_Cmd70:
;pacman.c,255 :: 		}
	RETURN      0
; end of _Le_Entrada_Cmd

_Le_Entrada:

;pacman.c,257 :: 		void Le_Entrada(char slot[]) {
;pacman.c,258 :: 		Le_Entrada_Cmd(slot, 0, 0, 0);
	MOVF        FARG_Le_Entrada_slot+0, 0 
	MOVWF       FARG_Le_Entrada_Cmd_slot+0 
	MOVF        FARG_Le_Entrada_slot+1, 0 
	MOVWF       FARG_Le_Entrada_Cmd_slot+1 
	CLRF        FARG_Le_Entrada_Cmd_showInput+0 
	CLRF        FARG_Le_Entrada_Cmd_showInput+1 
	CLRF        FARG_Le_Entrada_Cmd_row+0 
	CLRF        FARG_Le_Entrada_Cmd_row+1 
	CLRF        FARG_Le_Entrada_Cmd_column+0 
	CLRF        FARG_Le_Entrada_Cmd_column+1 
	CALL        _Le_Entrada_Cmd+0, 0
;pacman.c,259 :: 		}
	RETURN      0
; end of _Le_Entrada

_Le_Entrada_Cp:

;pacman.c,261 :: 		void Le_Entrada_Cp(char slot[], int row, int column) {
;pacman.c,262 :: 		Le_Entrada_Cmd(slot, 1, row, column);
	MOVF        FARG_Le_Entrada_Cp_slot+0, 0 
	MOVWF       FARG_Le_Entrada_Cmd_slot+0 
	MOVF        FARG_Le_Entrada_Cp_slot+1, 0 
	MOVWF       FARG_Le_Entrada_Cmd_slot+1 
	MOVLW       1
	MOVWF       FARG_Le_Entrada_Cmd_showInput+0 
	MOVLW       0
	MOVWF       FARG_Le_Entrada_Cmd_showInput+1 
	MOVF        FARG_Le_Entrada_Cp_row+0, 0 
	MOVWF       FARG_Le_Entrada_Cmd_row+0 
	MOVF        FARG_Le_Entrada_Cp_row+1, 0 
	MOVWF       FARG_Le_Entrada_Cmd_row+1 
	MOVF        FARG_Le_Entrada_Cp_column+0, 0 
	MOVWF       FARG_Le_Entrada_Cmd_column+0 
	MOVF        FARG_Le_Entrada_Cp_column+1, 0 
	MOVWF       FARG_Le_Entrada_Cmd_column+1 
	CALL        _Le_Entrada_Cmd+0, 0
;pacman.c,263 :: 		}
	RETURN      0
; end of _Le_Entrada_Cp

_main:

;pacman.c,268 :: 		void main()
;pacman.c,270 :: 		UART1_Init(19200);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;pacman.c,271 :: 		I2C1_Init(100000);// i2c para acessar ID = D0h  = RTC
	MOVLW       20
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;pacman.c,273 :: 		ADCON1 = 0B00001110;
	MOVLW       14
	MOVWF       ADCON1+0 
;pacman.c,274 :: 		TRISB = 0B00001111;
	MOVLW       15
	MOVWF       TRISB+0 
;pacman.c,275 :: 		TRISA = 0B00100001;
	MOVLW       33
	MOVWF       TRISA+0 
;pacman.c,276 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;pacman.c,278 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,279 :: 		CustomChar();
	CALL        _CustomChar+0, 0
;pacman.c,282 :: 		InitTimer2_Int0();
	CALL        _InitTimer2_Int0+0, 0
;pacman.c,284 :: 		while(1)
L_main77:
;pacman.c,286 :: 		command = Le_Teclado();
	CALL        _Le_Teclado+0, 0
	MOVF        R0, 0 
	MOVWF       _command+0 
;pacman.c,287 :: 		if (command == 'C') {
	MOVF        R0, 0 
	XORLW       67
	BTFSS       STATUS+0, 2 
	GOTO        L_main79
;pacman.c,288 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,289 :: 		Lcd_Out(2, 2, "MODO CONFIGURACAO");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,290 :: 		Delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main80:
	DECFSZ      R13, 1, 0
	BRA         L_main80
	DECFSZ      R12, 1, 0
	BRA         L_main80
	DECFSZ      R11, 1, 0
	BRA         L_main80
	NOP
	NOP
;pacman.c,292 :: 		Write_EEPROM(0, 0xFF);
	CLRF        FARG_Write_EEPROM_END+0 
	CLRF        FARG_Write_EEPROM_END+1 
	MOVLW       255
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;pacman.c,293 :: 		Write_EEPROM(1, 0xFF);
	MOVLW       1
	MOVWF       FARG_Write_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_END+1 
	MOVLW       255
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;pacman.c,294 :: 		Write_EEPROM(2, 0xFF);
	MOVLW       2
	MOVWF       FARG_Write_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_END+1 
	MOVLW       255
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;pacman.c,295 :: 		}
L_main79:
;pacman.c,297 :: 		temp = Read_EEPROM(0);
	CLRF        FARG_Read_EEPROM_END+0 
	CLRF        FARG_Read_EEPROM_END+1 
	CALL        _Read_EEPROM+0, 0
	MOVF        R0, 0 
	MOVWF       _temp+0 
	MOVF        R1, 0 
	MOVWF       _temp+1 
;pacman.c,298 :: 		critic_hhh = Read_EEPROM(1);
	MOVLW       1
	MOVWF       FARG_Read_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Read_EEPROM_END+1 
	CALL        _Read_EEPROM+0, 0
	MOVF        R0, 0 
	MOVWF       _critic_hhh+0 
	MOVF        R1, 0 
	MOVWF       _critic_hhh+1 
;pacman.c,299 :: 		critic_mmm = Read_EEPROM(2);
	MOVLW       2
	MOVWF       FARG_Read_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Read_EEPROM_END+1 
	CALL        _Read_EEPROM+0, 0
	MOVF        R0, 0 
	MOVWF       _critic_mmm+0 
	MOVF        R1, 0 
	MOVWF       _critic_mmm+1 
;pacman.c,301 :: 		if (temp == 0xFF) {
	MOVLW       0
	XORWF       _temp+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main105
	MOVLW       255
	XORWF       _temp+0, 0 
L__main105:
	BTFSS       STATUS+0, 2 
	GOTO        L_main81
;pacman.c,302 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,303 :: 		Lcd_Out(1, 2, "CONFIGURANDO A ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,304 :: 		Lcd_Out(2, 2, "TEMPERATURA");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,305 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main82:
	DECFSZ      R13, 1, 0
	BRA         L_main82
	DECFSZ      R12, 1, 0
	BRA         L_main82
	DECFSZ      R11, 1, 0
	BRA         L_main82
	NOP
;pacman.c,306 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,307 :: 		Lcd_Out(1, 2, "QUAL A TEMPERATURA");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,308 :: 		Lcd_Out(2, 2, "MAXIMA?");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,309 :: 		Lcd_Out(3, 2, "R.: __");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,310 :: 		Le_Entrada_Cp(ENTRADA, 3, 6);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_Le_Entrada_Cp_slot+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_Le_Entrada_Cp_slot+1 
	MOVLW       3
	MOVWF       FARG_Le_Entrada_Cp_row+0 
	MOVLW       0
	MOVWF       FARG_Le_Entrada_Cp_row+1 
	MOVLW       6
	MOVWF       FARG_Le_Entrada_Cp_column+0 
	MOVLW       0
	MOVWF       FARG_Le_Entrada_Cp_column+1 
	CALL        _Le_Entrada_Cp+0, 0
;pacman.c,311 :: 		temp=atoi(ENTRADA);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _temp+0 
	MOVF        R1, 0 
	MOVWF       _temp+1 
;pacman.c,312 :: 		Write_EEPROM(0, temp);
	CLRF        FARG_Write_EEPROM_END+0 
	CLRF        FARG_Write_EEPROM_END+1 
	MOVF        R0, 0 
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVF        R1, 0 
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;pacman.c,313 :: 		}
L_main81:
;pacman.c,315 :: 		if (critic_hhh == 0xFF && critic_mmm == 0xFF) {
	MOVLW       0
	XORWF       _critic_hhh+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main106
	MOVLW       255
	XORWF       _critic_hhh+0, 0 
L__main106:
	BTFSS       STATUS+0, 2 
	GOTO        L_main85
	MOVLW       0
	XORWF       _critic_mmm+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main107
	MOVLW       255
	XORWF       _critic_mmm+0, 0 
L__main107:
	BTFSS       STATUS+0, 2 
	GOTO        L_main85
L__main97:
;pacman.c,316 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,317 :: 		Lcd_Out(1, 2, "CONFIGURANDO O");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,318 :: 		Lcd_Out(2, 2, "HORARIO DO");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr9_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr9_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,319 :: 		Lcd_Out(3, 2, "MONITORAMENTO");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr10_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr10_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,320 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main86:
	DECFSZ      R13, 1, 0
	BRA         L_main86
	DECFSZ      R12, 1, 0
	BRA         L_main86
	DECFSZ      R11, 1, 0
	BRA         L_main86
	NOP
;pacman.c,322 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,323 :: 		Lcd_Out(1, 2, "QUAL A HORA?");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr11_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr11_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,324 :: 		Lcd_Out(2, 2, "R.: __");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr12_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr12_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,325 :: 		Le_Entrada_Cp(ENTRADA, 2, 6);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_Le_Entrada_Cp_slot+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_Le_Entrada_Cp_slot+1 
	MOVLW       2
	MOVWF       FARG_Le_Entrada_Cp_row+0 
	MOVLW       0
	MOVWF       FARG_Le_Entrada_Cp_row+1 
	MOVLW       6
	MOVWF       FARG_Le_Entrada_Cp_column+0 
	MOVLW       0
	MOVWF       FARG_Le_Entrada_Cp_column+1 
	CALL        _Le_Entrada_Cp+0, 0
;pacman.c,326 :: 		critic_hhh = atoi(ENTRADA);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _critic_hhh+0 
	MOVF        R1, 0 
	MOVWF       _critic_hhh+1 
;pacman.c,328 :: 		Lcd_Out(3, 2, "QUAIS OS MINUTOS?");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr13_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr13_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,329 :: 		Lcd_Out(4, 2, "R.: __");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr14_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr14_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,330 :: 		Le_Entrada_Cp(ENTRADA, 4, 6);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_Le_Entrada_Cp_slot+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_Le_Entrada_Cp_slot+1 
	MOVLW       4
	MOVWF       FARG_Le_Entrada_Cp_row+0 
	MOVLW       0
	MOVWF       FARG_Le_Entrada_Cp_row+1 
	MOVLW       6
	MOVWF       FARG_Le_Entrada_Cp_column+0 
	MOVLW       0
	MOVWF       FARG_Le_Entrada_Cp_column+1 
	CALL        _Le_Entrada_Cp+0, 0
;pacman.c,331 :: 		critic_mmm = atoi(ENTRADA);
	MOVLW       _ENTRADA+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_ENTRADA+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _critic_mmm+0 
	MOVF        R1, 0 
	MOVWF       _critic_mmm+1 
;pacman.c,333 :: 		Write_EEPROM(1, critic_hhh);
	MOVLW       1
	MOVWF       FARG_Write_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_END+1 
	MOVF        _critic_hhh+0, 0 
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVF        _critic_hhh+1, 0 
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;pacman.c,334 :: 		Write_EEPROM(2, critic_mmm);
	MOVLW       2
	MOVWF       FARG_Write_EEPROM_END+0 
	MOVLW       0
	MOVWF       FARG_Write_EEPROM_END+1 
	MOVF        _critic_mmm+0, 0 
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVF        _critic_mmm+1, 0 
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;pacman.c,336 :: 		drawInfoLabel = 1;
	MOVLW       1
	MOVWF       _drawInfoLabel+0 
;pacman.c,337 :: 		}
L_main85:
;pacman.c,339 :: 		if (drawInfoLabel) {
	MOVF        _drawInfoLabel+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main87
;pacman.c,340 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;pacman.c,341 :: 		Lcd_Out(1, 2, "TEMP. ATUAL:");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr15_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr15_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,342 :: 		Lcd_Out(2, 2, "TEMP. MAX:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr16_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr16_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,343 :: 		Lcd_Out(3, 2, "H. MON:");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr17_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr17_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,344 :: 		Lcd_Out(4, 2, "H. ATUAL:");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr18_pacman+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr18_pacman+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,345 :: 		drawInfoLabel = 0;
	CLRF        _drawInfoLabel+0 
;pacman.c,346 :: 		}
L_main87:
;pacman.c,348 :: 		if (command == '+') {
	MOVF        _command+0, 0 
	XORLW       43
	BTFSS       STATUS+0, 2 
	GOTO        L_main88
;pacman.c,349 :: 		temp = temp + 1;
	INFSNZ      _temp+0, 1 
	INCF        _temp+1, 1 
;pacman.c,350 :: 		Write_EEPROM(0, temp);
	CLRF        FARG_Write_EEPROM_END+0 
	CLRF        FARG_Write_EEPROM_END+1 
	MOVF        _temp+0, 0 
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVF        _temp+1, 0 
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;pacman.c,351 :: 		}
L_main88:
;pacman.c,353 :: 		if (command == '-') {
	MOVF        _command+0, 0 
	XORLW       45
	BTFSS       STATUS+0, 2 
	GOTO        L_main89
;pacman.c,354 :: 		temp = temp - 1;
	MOVLW       1
	SUBWF       _temp+0, 1 
	MOVLW       0
	SUBWFB      _temp+1, 1 
;pacman.c,355 :: 		Write_EEPROM(0, temp);
	CLRF        FARG_Write_EEPROM_END+0 
	CLRF        FARG_Write_EEPROM_END+1 
	MOVF        _temp+0, 0 
	MOVWF       FARG_Write_EEPROM_DADO+0 
	MOVF        _temp+1, 0 
	MOVWF       FARG_Write_EEPROM_DADO+1 
	CALL        _Write_EEPROM+0, 0
;pacman.c,356 :: 		}
L_main89:
;pacman.c,358 :: 		sprintf(TXT, "%02d", temp);
	MOVLW       _TXT+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_19_pacman+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_19_pacman+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_19_pacman+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _temp+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _temp+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	CALL        _sprintf+0, 0
;pacman.c,359 :: 		Lcd_Out(2, 13, TXT);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _TXT+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,360 :: 		lcd_chr_cp(0);
	CLRF        FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;pacman.c,361 :: 		lcd_chr_cp('C');
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;pacman.c,363 :: 		sprintf(TXT, "%02d:%02d",critic_hhh,critic_mmm);
	MOVLW       _TXT+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_20_pacman+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_20_pacman+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_20_pacman+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _critic_hhh+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _critic_hhh+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _critic_mmm+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        _critic_mmm+1, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;pacman.c,364 :: 		Lcd_Out(3, 10, TXT);
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       10
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _TXT+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,366 :: 		sss = Read_RTC(0); //le segundos
	CLRF        FARG_Read_RTC_END+0 
	CLRF        FARG_Read_RTC_END+1 
	CALL        _Read_RTC+0, 0
	MOVF        R0, 0 
	MOVWF       _sss+0 
	MOVF        R1, 0 
	MOVWF       _sss+1 
;pacman.c,367 :: 		mmm = Read_RTC(1); //le minutos
	MOVLW       1
	MOVWF       FARG_Read_RTC_END+0 
	MOVLW       0
	MOVWF       FARG_Read_RTC_END+1 
	CALL        _Read_RTC+0, 0
	MOVF        R0, 0 
	MOVWF       _mmm+0 
	MOVF        R1, 0 
	MOVWF       _mmm+1 
;pacman.c,368 :: 		hhh = Read_RTC(2); //le horas
	MOVLW       2
	MOVWF       FARG_Read_RTC_END+0 
	MOVLW       0
	MOVWF       FARG_Read_RTC_END+1 
	CALL        _Read_RTC+0, 0
	MOVF        R0, 0 
	MOVWF       _hhh+0 
	MOVF        R1, 0 
	MOVWF       _hhh+1 
;pacman.c,369 :: 		Transform_Time(&sss,&mmm,&hhh);
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
;pacman.c,370 :: 		sprintf(HORA_TXT, "%02d:%02d:%02d",hhh,mmm,sss);
	MOVLW       _HORA_TXT+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_HORA_TXT+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_21_pacman+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_21_pacman+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_21_pacman+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        _hhh+0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        _hhh+1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        _mmm+0, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        _mmm+1, 0 
	MOVWF       FARG_sprintf_wh+8 
	MOVF        _sss+0, 0 
	MOVWF       FARG_sprintf_wh+9 
	MOVF        _sss+1, 0 
	MOVWF       FARG_sprintf_wh+10 
	CALL        _sprintf+0, 0
;pacman.c,371 :: 		lcd_Out(4, 12, HORA_TXT);
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _HORA_TXT+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_HORA_TXT+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,373 :: 		AD = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _AD+0 
	MOVF        R1, 0 
	MOVWF       _AD+1 
;pacman.c,374 :: 		Temperatura = ((float) AD * 5.0/1024.0) * 100.0;
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
;pacman.c,375 :: 		sprintf(TXT, "%02d", Temperatura);
	MOVLW       _TXT+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_22_pacman+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_22_pacman+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_22_pacman+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	CALL        _sprintf+0, 0
;pacman.c,376 :: 		Lcd_Out(1, 15, TXT);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       15
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _TXT+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_TXT+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;pacman.c,377 :: 		Lcd_Chr_Cp(0);
	CLRF        FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;pacman.c,378 :: 		Lcd_Chr_CP('C');
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;pacman.c,380 :: 		if (Temperatura > temp && (hhh >= critic_hhh && mmm >= critic_mmm))
	MOVLW       128
	XORWF       _temp+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main108
	MOVF        _Temperatura+0, 0 
	SUBWF       _temp+0, 0 
L__main108:
	BTFSC       STATUS+0, 0 
	GOTO        L_main94
	MOVLW       128
	XORWF       _hhh+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _critic_hhh+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main109
	MOVF        _critic_hhh+0, 0 
	SUBWF       _hhh+0, 0 
L__main109:
	BTFSS       STATUS+0, 0 
	GOTO        L_main94
	MOVLW       128
	XORWF       _mmm+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _critic_mmm+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main110
	MOVF        _critic_mmm+0, 0 
	SUBWF       _mmm+0, 0 
L__main110:
	BTFSS       STATUS+0, 0 
	GOTO        L_main94
L__main96:
L__main95:
;pacman.c,381 :: 		Alert();
	CALL        _Alert+0, 0
L_main94:
;pacman.c,382 :: 		}
	GOTO        L_main77
;pacman.c,383 :: 		}
	GOTO        $+0
; end of _main
