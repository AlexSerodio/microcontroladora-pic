#include "controller.c"

// Lcd pinout settings
sbit LCD_RS at RE0_bit;
sbit LCD_EN at RE1_bit;

sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

// Pin direction
sbit LCD_RS_Direction at TRISE0_bit;
sbit LCD_EN_Direction at TRISE1_bit;

sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

unsigned int AD;        //0..1023
char TXT[7];
unsigned short Temperatura;

int hhh, mmm, sss;
int critic_hhh, critic_mmm;

char ENTER[2] = {13,0};

char ENTRADA[33]; //32 para o dado entrado + reserva do NULL

int temp;
char _char;

short Le_Teclado()
{
    PORTD = 0B00010000; // VOC� SELECIONOU LA
    if (PORTA.RA5 == 1) {
        while(PORTA.RA5 == 1);
        return '7';
    }
    if (PORTB.RB1 == 1) {
        while(PORTB.RB1 == 1);
        return '8';
    }
    if (PORTB.RB2 == 1) {
        while(PORTB.RB2 == 1);
        return '9';
    }
    if (PORTB.RB3 == 1) {
        while(PORTB.RB3 == 1);
        return '%';
    }

    PORTD = 0B00100000; // VOC� SELECIONOU LB
    if (PORTA.RA5 == 1) {
        while(PORTA.RA5 == 1);
        return '4';
    }
    if (PORTB.RB1 == 1) {
        while(PORTB.RB1 == 1);
        return '5';
    }
    if (PORTB.RB2 == 1) {
        while(PORTB.RB2 == 1);
        return '6';
    }
    if (PORTB.RB3 == 1) {
        while(PORTB.RB3 == 1);
        return '*';
    }

    PORTD = 0B01000000; // VOC� SELECIONOU LC
    if (PORTA.RA5 == 1) {
        while(PORTA.RA5 == 1);
        return '1';
    }
    if (PORTB.RB1 == 1) {
        while(PORTB.RB1 == 1);
        return '2';
    }
    if (PORTB.RB2 == 1) {
        while(PORTB.RB2 == 1);
        return '3';
    }
    if (PORTB.RB3 == 1) {
        while(PORTB.RB3 == 1);
        return '-';
    }

    PORTD = 0B10000000; // VOC� SELECIONOU LD
    if (PORTA.RA5 == 1) {
        while(PORTA.RA5 == 1);
        return 'C';
    }
    if (PORTB.RB1 == 1) {
        while(PORTB.RB1 == 1);
        return '0';
    }
    if (PORTB.RB2 == 1) {
        while(PORTB.RB2 == 1);
        return '=';
    }
    if (PORTB.RB3 == 1) {
        while(PORTB.RB3 == 1);
        return '+';
    }

    return 255;
}

void InitTimer2_Int0(){
    T2CON = 0x3C;
    TMR2IE_bit = 1;
    PR2 = 249;
    INTCON = 0xD0;  //INTCON = 1100 0000 (HABILITA TMR2 INTERRUPT E INT0 INTERRUPT)
}

void interrupt() 
{
    if(int0if_bit) {
        tick();
        // UART1_Write_Text("chamou tick");
        int0if_bit = 0;
    }
}

void Pula_Linha(void) 
{
    UART1_WRITE(13);
    UART1_WRITE(10);
}

void Move_Delay() 
{                         // Function used for text moving
    Delay_ms(100);                             // You can change the moving speed here
}

void Alert() 
{
    int i;
    for(i=0; i<1; i++) {               // Move text to the right 4 times
        Lcd_Cmd(_LCD_SHIFT_RIGHT);
        Move_Delay();
    }
    for(i=0; i<1; i++) {               // Move text to the left 4 times
        Lcd_Cmd(_LCD_SHIFT_LEFT);
        Move_Delay();
    }
}

void Write_EEPROM(int END, int DADO)
{
    I2C1_Start();           // issue I2C start signal
    I2C1_Wr(0xA0);          // send byte via I2C  (device address + W)
    I2C1_Wr(END);           // send byte (address of EEPROM location)
    I2C1_Wr(DADO);          // send data (data to be written)
    I2C1_Stop();            // issue I2C stop signal
    delay_ms(10);
}

int Read_EEPROM(int END) 
{
    int Dado;
    I2C1_Start();           // issue I2C start signal
    I2C1_Wr(0xA0);          // send byte via I2C  (device address + W)
    I2C1_Wr(END);           // send byte (data address)
    I2C1_Repeated_Start();  // issue I2C signal repeated start
    I2C1_Wr(0xA1);          // send byte (device address + R)
    Dado = I2C1_Rd(0u);     // Read the data (NO acknowledge)
    I2C1_Stop();            // issue I2C stop signal
    return(Dado);
}

void Write_RTC(int END, int DADO)
{
    I2C1_Start();           // issue I2C start signal
    I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
    I2C1_Wr(END);           // send byte (address of EEPROM location)
    I2C1_Wr(DADO);          // send data (data to be written)
    I2C1_Stop();            // issue I2C stop signal
}

int Read_RTC(int END)
{
    int Dado;
    I2C1_Start();           // issue I2C start signal
    I2C1_Wr(0xD0);          // send byte via I2C  (device address + W)
    I2C1_Wr(END);           // send byte (data address)
    I2C1_Repeated_Start();  // issue I2C signal repeated start
    I2C1_Wr(0xD1);          // send byte (device address + R)
    Dado = I2C1_Rd(0u);     // Read the data (NO acknowledge)
    I2C1_Stop();            // issue I2C stop signal
    return(Dado);
}
// bcd para binario
void Transform_Time(char *sec, char *min, char *hr)
{
    *sec = ((*sec & 0xF0) >> 4)*10 + (*sec & 0x0F);
    *min = ((*min & 0xF0) >> 4)*10 + (*min & 0x0F);
    *hr = ((*hr & 0xF0) >> 4)*10 + (*hr & 0x0F);
}

void Le_Entrada_Cmd(char slot[], int showInput, int row, int column)
{
    for (i = 0; i < sizeof(slot); i++) 
    {
        slot[i] = 0;
    }
    i = 0;
    while((_char = Le_Teclado()) != '=') 
    {
        if (_char != 255) 
        {
            if (_char == '*') 
            {
                if (i > 0) {
                    i--;
                }
                slot[i] = 0;
                if (showInput) {
                    Lcd_Out(row, column + i, " ");
                }
            } else {
                slot[i] = _char;
                i++;
                if (showInput) {
                    Lcd_Out(row, column, slot);
                }
            }
        }
    }
}

void Le_Entrada(char slot[]) {
    Le_Entrada_Cmd(slot, 0, 0, 0);
}

void Le_Entrada_Cp(char slot[], int row, int column) {
    Le_Entrada_Cmd(slot, 1, row, column);
}

short PACMAN_SYMBOL = 0;
short WALL_SYMBOL = 1;
short GHOST_SYMBOL = 2;
char PILULA_SYMBOL = 'P';

void draw_world() {
    int i;
    int j;
    for(i = 0; i < 4; i++) 
    {
        for(j = 0; j < 20; j++)
        {
            if(_is_fantasma(mapa[i][j]))
            {
                Lcd_Chr(i + 1, j + 1, GHOST_SYMBOL);
            } 
            else if(_is_parede(mapa[i][j]))
            {
                Lcd_Chr(i + 1, j + 1, WALL_SYMBOL);
            }
            else if(_is_pacman(mapa[i][j]))
            {
                Lcd_Chr(i + 1, j + 1, PACMAN_SYMBOL);
            }
            else if(_is_pilula(mapa[i][j]))
            {
                Lcd_Chr(i + 1, j + 1, PILULA_SYMBOL);
            }else {
                Lcd_Chr(i + 1, j + 1, ' ');
            }
        }
    }
}

void print_world() {
    int i;
    int j;
    char string[10];

    for(i = 0; i < 4; i++) 
    {
        for(j = 0; j < 20; j++)
        {
                // int num = (int)strtol((int)mapa[i][j], NULL, 16);
            sprintf(string, "%X", (int)mapa[i][j]);
            UART1_Write_Text(string);
                UART1_Write_Text(" ");
        }
        Pula_Linha();
    }
        sprintf(string, "%X", (int)input);
    UART1_Write_Text(string);
        Pula_Linha();
}

const char character_pacman[] = {31,30,28,24,24,28,30,31};
const char character_wall[] = {31,31,31,31,31,31,31,31};
const char character_ghost[] = {31,31,21,31,17,21,31,21};
void custom_char() 
{
    char i;
    LCD_Cmd(64); //entra na
    for (i = 0; i<=7; i++) LCD_Chr_Cp(character_pacman[i]); //grava 8 bytes na cgram ENDER 0 a 7  cgram
    for (i = 0; i<=7; i++) LCD_Chr_Cp(character_wall[i]); //grava 8 bytes na cgram ENDER 8 a 15 cgram
    for (i = 0; i<=7; i++) LCD_Chr_Cp(character_ghost[i]); //grava 8 bytes na cgram ENDER 8 a 15 cgram
    LCD_Cmd(_LCD_RETURN_HOME); //sai da cgram
}

void start_game_screen() 
{
    Lcd_Out(2, 1, "PRESSIONE =");
    Lcd_Out(3, 1, "PARA INICIAR");

    while (Le_Teclado() != '=');

    Lcd_Cmd(_LCD_CLEAR);
}

void game_over_screen() 
{
    Lcd_Out(2, 1, "GAME OVER");
    Lcd_Out(3, 1, "PONTUACAO: ");
    Lcd_Out(3, 15, pontuacao());
}

char command;
short drawInfoLabel = 1;
char HORA_TXT[20];
void main()
{
        INTCON = 0xD0;
    UART1_Init(19200);
    I2C1_Init(100000);// i2c para acessar ID = D0h  = RTC

    ADCON1 = 0B00001110;
    TRISB = 0B00001111;
    TRISA = 0B00100001;
    
    Lcd_Init();
    Lcd_Cmd(_LCD_CURSOR_OFF);
    custom_char();

    start_game_screen();

// input = MASCARA_VIVO;

    draw_world();
    
    while(1)
    {
        command = Le_Teclado();

        // pra simular um game over
        if(command == '+')
                break;

        if(command != 255)
        {
            UART1_Write(command);
            switch(command) {
                case '6':
                    UART1_Write_Text(" - direita"); Pula_Linha();
                    input = 0B01000000 | DIREITA;
                    break;
                case '4':
                    UART1_Write_Text(" - esquerda"); Pula_Linha();
                    input = 0B01000000 | ESQUERDA;
                    break;
                case '8':
                    UART1_Write_Text(" - cima"); Pula_Linha();
                    input = 0B01000000 | CIMA;
                    break;
                case '2':
                    UART1_Write_Text(" - baixo"); Pula_Linha();
                    input = 0B01000000 | BAIXO;
                    break;
                case '9':
                    UART1_Write_Text(" - pause"); Pula_Linha();
                    input = MASCARA_PAUSE;
                    break;
                case '7':
                    UART1_Write_Text(" - reset"); Pula_Linha();
                    input = MASCARA_VIVO;
                    Lcd_Cmd(_LCD_CLEAR);
                    break;
                case '1':
                    UART1_Write_Text(" - add fantasma"); Pula_Linha();
                    input = 0B00100000;
                    break;
                case '3':
                    UART1_Write_Text(" - add cumida"); Pula_Linha();
                    input = 0B00010000;
                    break;
                case '5':
                    print_world();
                    
                    break;
            }
        }
        draw_world();
    }

    game_over_screen();
}
