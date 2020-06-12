#include "controller.c"
#include "__T6963C.h"

// T6963C module connections
char T6963C_dataPort at PORTD; // DATA port

sbit T6963C_ctrlwr at RC2_bit;               // WR write signal
sbit T6963C_ctrlrd at RC1_bit;               // RD read signal
sbit T6963C_ctrlcd at RC0_bit;               // CD command/data signal
sbit T6963C_ctrlrst at RC5_bit;              // RST reset signal
sbit T6963C_ctrlwr_Direction at TRISC2_bit;  // WR write signal
sbit T6963C_ctrlrd_Direction at TRISC1_bit;  // RD read signal
sbit T6963C_ctrlcd_Direction at TRISC0_bit;  // CD command/data signal
sbit T6963C_ctrlrst_Direction at TRISC5_bit; // RST reset signal

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

/*
 * bitmap pictures stored in ROM
 */
// const code char mC[];
// const code char einstein[];

int Opcao;

unsigned char const pacman_right_icon[] = {
    0x00, 0x00, 0x03, 0xE0, 0x0F, 0xF8, 0x1F, 0xFC, 0x1F, 0xFC, 0x3F, 0xF0, 0x3F, 0x80, 0x3E, 0x00,
    0x3F, 0x80, 0x3F, 0xF0, 0x1F, 0xFC, 0x1F, 0xFC, 0x0F, 0xF8, 0x03, 0xE0, 0x00, 0x00, 0x00, 0x00
};

unsigned char const pacman_down_icon[] = {
    0x00,0x00,0x00,0x00,0x07,0xC0,0x1F,0xF0,0x3F,0xF8,0x3F,0xF8,0x7F,0xFC,0x7F,0xFC,
    0x7E,0xFC,0x7E,0xFC,0x7C,0x7C,0x3C,0x78,0x3C,0x78,0x18,0x30,0x18,0x30,0x00,0x00
};

unsigned char const pacman_left_icon[] = {
    0x00,0x00,0x07,0xC0,0x1F,0xF0,0x3F,0xF8,0x3F,0xF8,0x0F,0xFC,0x01,0xFC,0x00,0x7C,
    0x01,0xFC,0x0F,0xFC,0x3F,0xF8,0x3F,0xF8,0x1F,0xF0,0x07,0xC0,0x00,0x00,0x00,0x00
};

unsigned char const pacman_up_icon[] = {
    0x00,0x00,0x00,0x00,0x0C,0x18,0x1C,0x1C,0x1E,0x3C,0x3E,0x3E,0x3E,0x3E,0x3F,0x7E,
    0x3F,0x7E,0x3F,0xFE,0x1F,0xFC,0x1F,0xFC,0x0F,0xF8,0x03,0xE0,0x00,0x00,0x00,0x00
};

unsigned char const ghost_icon[] = {
    0x00, 0x00, 0x03, 0xC0, 0x0F, 0xF0, 0x1F, 0xF8, 0x39, 0xCC, 0x30, 0x84, 0x33, 0x9C, 0x73, 0x9E,
    0x79, 0xCE, 0x7F, 0xFE, 0x7F, 0xFE, 0x7F, 0xFE, 0x7F, 0xFE, 0x6E, 0x76, 0x46, 0x62, 0x00, 0x00
};

unsigned char const empty_icon[] = {
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};

unsigned char const wall_icon[] = {
    0x7F,0xFE,0x61,0x86,0x7F,0xFE,0x4C,0x32,0x7F,0xFE,0x61,0x86,0x7F,0xFE,0x4C,0x32,
    0x7F,0xFE,0x61,0x86,0x7F,0xFE,0x4C,0x32,0x7F,0xFE,0x61,0x86,0x7F,0xFE,0x00,0x00
};

unsigned char const food_icon[] = {
    0x00,0x00,0x00,0x00,0x00,0x18,0x00,0x38,0x00,0xD0,0x03,0x10,0x02,0x10,0x0F,0x10,
    0x1F,0xA0,0x1F,0x78,0x16,0xFC,0x1A,0xFC,0x0E,0xBC,0x00,0xDC,0x00,0x78,0x00,0x00
};

short Le_Teclado()
{
    PORTD = 0B00010000; // VOCE SELECIONOU LA
    if (PORTA.RA5 == 1)
    {
        while (PORTA.RA5 == 1)
            ;
        return '7';
    }
    if (PORTB.RB1 == 1)
    {
        while (PORTB.RB1 == 1)
            ;
        return '8';
    }
    if (PORTB.RB2 == 1)
    {
        while (PORTB.RB2 == 1)
            ;
        return '9';
    }
    if (PORTB.RB3 == 1)
    {
        while (PORTB.RB3 == 1)
            ;
        return '%';
    }

    PORTD = 0B00100000; // VOCE SELECIONOU LB
    if (PORTA.RA5 == 1)
    {
        while (PORTA.RA5 == 1)
            ;
        return '4';
    }
    if (PORTB.RB1 == 1)
    {
        while (PORTB.RB1 == 1)
            ;
        return '5';
    }
    if (PORTB.RB2 == 1)
    {
        while (PORTB.RB2 == 1)
            ;
        return '6';
    }
    if (PORTB.RB3 == 1)
    {
        while (PORTB.RB3 == 1)
            ;
        return '*';
    }

    PORTD = 0B01000000; // VOCE SELECIONOU LC
    if (PORTA.RA5 == 1)
    {
        while (PORTA.RA5 == 1)
            ;
        return '1';
    }
    if (PORTB.RB1 == 1)
    {
        while (PORTB.RB1 == 1)
            ;
        return '2';
    }
    if (PORTB.RB2 == 1)
    {
        while (PORTB.RB2 == 1)
            ;
        return '3';
    }
    if (PORTB.RB3 == 1)
    {
        while (PORTB.RB3 == 1)
            ;
        return '-';
    }

    PORTD = 0B10000000; // VOCE SELECIONOU LD
    if (PORTA.RA5 == 1)
    {
        while (PORTA.RA5 == 1)
            ;
        return 'C';
    }
    if (PORTB.RB1 == 1)
    {
        while (PORTB.RB1 == 1)
            ;
        return '0';
    }
    if (PORTB.RB2 == 1)
    {
        while (PORTB.RB2 == 1)
            ;
        return '=';
    }
    if (PORTB.RB3 == 1)
    {
        while (PORTB.RB3 == 1)
            ;
        return '+';
    }

    return 255;
}

void InitTimer2_Int0()
{
    T2CON = 0x3C;
    TMR2IE_bit = 1;
    PR2 = 249;
    INTCON = 0xD0; //INTCON = 1100 0000 (HABILITA TMR2 INTERRUPT E INT0 INTERRUPT)
}

void Pula_Linha(void)
{
    UART1_WRITE(13);
    UART1_WRITE(10);
}

void Move_Delay() // Function used for text moving
{
    Delay_ms(100); // You can change the moving speed here
}

void Alert()
{
    int i;
    for (i = 0; i < 1; i++) // Move text to the right 4 times
    {
        Lcd_Cmd(_LCD_SHIFT_RIGHT);
        Move_Delay();
    }
    for (i = 0; i < 1; i++) // Move text to the left 4 times
    {
        Lcd_Cmd(_LCD_SHIFT_LEFT);
        Move_Delay();
    }
}

void Write_EEPROM(int END, int DADO)
{
    I2C1_Start();  // issue I2C start signal
    I2C1_Wr(0xA0); // send byte via I2C  (device address + W)
    I2C1_Wr(END);  // send byte (address of EEPROM location)
    I2C1_Wr(DADO); // send data (data to be written)
    I2C1_Stop();   // issue I2C stop signal
    delay_ms(10);
}

int Read_EEPROM(int END)
{
    int Dado;
    I2C1_Start();          // issue I2C start signal
    I2C1_Wr(0xA0);         // send byte via I2C  (device address + W)
    I2C1_Wr(END);          // send byte (data address)
    I2C1_Repeated_Start(); // issue I2C signal repeated start
    I2C1_Wr(0xA1);         // send byte (device address + R)
    Dado = I2C1_Rd(0u);    // Read the data (NO acknowledge)
    I2C1_Stop();           // issue I2C stop signal
    return (Dado);
}

void Write_RTC(int END, int DADO)
{
    I2C1_Start();  // issue I2C start signal
    I2C1_Wr(0xD0); // send byte via I2C  (device address + W)
    I2C1_Wr(END);  // send byte (address of EEPROM location)
    I2C1_Wr(DADO); // send data (data to be written)
    I2C1_Stop();   // issue I2C stop signal
}

int Read_RTC(int END)
{
    int Dado;
    I2C1_Start();          // issue I2C start signal
    I2C1_Wr(0xD0);         // send byte via I2C  (device address + W)
    I2C1_Wr(END);          // send byte (data address)
    I2C1_Repeated_Start(); // issue I2C signal repeated start
    I2C1_Wr(0xD1);         // send byte (device address + R)
    Dado = I2C1_Rd(0u);    // Read the data (NO acknowledge)
    I2C1_Stop();           // issue I2C stop signal
    return (Dado);
}

// bcd para binario
void Transform_Time(char *sec, char *min, char *hr)
{
    *sec = ((*sec & 0xF0) >> 4) * 10 + (*sec & 0x0F);
    *min = ((*min & 0xF0) >> 4) * 10 + (*min & 0x0F);
    *hr = ((*hr & 0xF0) >> 4) * 10 + (*hr & 0x0F);
}

void Le_Entrada_Cmd(char slot[], int showInput, int row, int column)
{
    char _char;

    for (i = 0; i < sizeof(slot); i++)
    {
        slot[i] = 0;
    }

    i = 0;
    while ((_char = Le_Teclado()) != '=')
    {
        if (_char != 255)
        {
            if (_char == '*')
            {
                if (i > 0)
                {
                    i--;
                }
                slot[i] = 0;
                if (showInput)
                {
                    Lcd_Out(row, column + i, " ");
                }
            }
            else
            {
                slot[i] = _char;
                i++;
                if (showInput)
                {
                    Lcd_Out(row, column, slot);
                }
            }
        }
    }
}

void Le_Entrada(char slot[])
{
    Le_Entrada_Cmd(slot, 0, 0, 0);
}

void Le_Entrada_Cp(char slot[], int row, int column)
{
    Le_Entrada_Cmd(slot, 1, row, column);
}

short PACMAN_SYMBOL = 0;
short WALL_SYMBOL = 1;
short GHOST_SYMBOL = 2;
char PILULA_SYMBOL = 3;
void draw_world()
{
    int i;
    int j;
    for (i = 0; i < X_MAX; i++)
    {
        for (j = 0; j < Y_MAX; j++)
        {
            if (_is_fantasma(mapa[i][j]))
            {
                Lcd_Chr(i + 1, j + 1, GHOST_SYMBOL);
            }
            else if (_is_parede(mapa[i][j]))
            {
                Lcd_Chr(i + 1, j + 1, WALL_SYMBOL);
            }
            else if (_is_pacman(mapa[i][j]))
            {
                Lcd_Chr(i + 1, j + 1, PACMAN_SYMBOL);
            }
            else if (_is_pilula(mapa[i][j]))
            {
                Lcd_Chr(i + 1, j + 1, PILULA_SYMBOL);
            }
            else
            {
                Lcd_Chr(i + 1, j + 1, ' ');
            }
        }
    }
}

void print_display(unsigned char x, unsigned char y, const char *pic)
{
    int offset = 16;
    T6963C_sprite(offset*x, offset*y, pic, 16, 16);
}

void draw_display()
{
    int i;
    int j;
    for (i = 0; i < X_MAX; i++)
    {
        for (j = 0; j < Y_MAX; j++)
        {
            if (_is_fantasma(mapa[i][j]))
            {
                print_display(j, i, ghost_icon);
            }
            else if (_is_parede(mapa[i][j]))
            {
                print_display(j, i, wall_icon);
            }
            else if (_is_pacman(mapa[i][j]))
            {
                if(mapa[i][j] == DIREITA)
                    print_display(j, i, pacman_right_icon);
                else if(mapa[i][j] == BAIXO)
                    print_display(j, i, pacman_down_icon);
                else if(mapa[i][j] == CIMA)
                    print_display(j, i, pacman_up_icon);
                else if(mapa[i][j] == ESQUERDA)
                    print_display(j, i, pacman_left_icon);

            }
            else if (_is_pilula(mapa[i][j]))
            {
                print_display(j, i, food_icon);
            }
            else
            {
                print_display(j, i, empty_icon);
            }
        }
    }
}

void print_world()
{
    int i;
    int j;
    char string[10];

    for (i = 0; i < X_MAX; i++)
    {
        for (j = 0; j < Y_MAX; j++)
        {
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

const char character_pacman[] = {31, 30, 28, 24, 24, 28, 30, 31};
const char character_wall[] = {31, 31, 31, 31, 31, 31, 31, 31};
const char character_ghost[] = {31, 21, 31, 17, 21, 31, 21, 21};
const char character_food[] = {0, 14, 14, 31, 31, 14, 14, 0};
void custom_char()
{
    char i;
    LCD_Cmd(64); //entra na
    for (i = 0; i <= 7; i++)
        LCD_Chr_Cp(character_pacman[i]);
    for (i = 0; i <= 7; i++)
        LCD_Chr_Cp(character_wall[i]);
    for (i = 0; i <= 7; i++)
        LCD_Chr_Cp(character_ghost[i]);
    for (i = 0; i <= 7; i++)
        LCD_Chr_Cp(character_food[i]);
    LCD_Cmd(_LCD_RETURN_HOME); //sai da cgram
}

void reset_displayzao()
{
    for (i = 0; i < X_MAX; i++)
    {
        for (j = 0; j < Y_MAX; j++)
        {
            print_display(j, i, empty_icon);
        }
    }
}

void reset_game()
{
    int i;
    int j;

    Sound_Play(130, 200);
    Sound_Play(146, 200);
    Sound_Play(164, 200);
    Sound_Play(174, 200);
    Sound_Play(196, 200);

    input = MASCARA_VIVO;
    // Lcd_Cmd(_LCD_CLEAR);
    
    reset_displayzao();
}

const int DO1 = 65;
const int RE_1 = 73;
const int MI1 = 82;
const int FA1 = 87;
const int SOL1 = 98;
const int LA1 = 110;
const int SI1 = 123;
const int DO2 = 131;

int FAZ_TICK = 1;
int ADD_COMIDA = 0;

void start_game_screen()
{
    Sound_Play(174, 200);
    Sound_Play(196, 200);

    // Lcd_Out(2, 6, "PRESSIONE =");
    // Lcd_Out(3, 5, "PARA INICIAR");

    T6963C_write_text("PRESSIONE = PARA INICIAR", 2, 7, T6963C_ROM_MODE_XOR);

    while (Le_Teclado() != '=')
        reset();

    T6963C_write_text("                        ", 2, 7, T6963C_ROM_MODE_XOR);
    reset_game();
}

void game_over_screen()
{
    char string[10];
    sprintf(string, "%X", (int)pontuacao());

    reset_displayzao();

    // Lcd_Cmd(_LCD_CLEAR);
    // Lcd_Out(2, 6, "GAME OVER");
    // Lcd_Out(3, 5, "PONTUACAO: ");
    // Lcd_Out(3, 16, string);
    T6963C_write_text("GAME OVER", 10, 7, T6963C_ROM_MODE_XOR);
    T6963C_write_text("PONTOS: ", 10, 8, T6963C_ROM_MODE_XOR);
    T6963C_write_text(string, 18, 8, T6963C_ROM_MODE_XOR);
    Sound_Play(196, 200);
    Sound_Play(174, 200);
    Sound_Play(164, 200);
    Sound_Play(146, 200);
    Sound_Play(130, 200);
}

void main()
{
    char command;

    INTCON = 0xD0;
    UART1_Init(19200);
    I2C1_Init(100000); // i2c para acessar ID = D0h  = RTC

    //   ADCON1=0x0E;
    ADCON1 = 0B00001110;
    TRISA3_bit = 1; // Set RA3 as input
    TRISA4_bit = 1; // Set RA4 as input

    TRISB = 0B00001111;
    TRISA = 0B00100001;

    // Initialize T6369C -> 15 x 8
    T6963C_init(240, 128, 8);

    /*
  * Enable both graphics and text display at the same time
  */
    T6963C_graphics(1);
    T6963C_text(1);

    //   Lcd_Init();
    //   Lcd_Cmd(_LCD_CURSOR_OFF);
    //   custom_char();

      Sound_Init(&PORTC, 5);

    start_game_screen();

    // draw_world();
    draw_display();

    while (!morto())
    {
        if (FAZ_TICK) {
            tick();
            draw_display();
        }

        if (ADD_COMIDA)
        {
            add_pilula_mapa();
            ADD_COMIDA = 0;
        }

        // draw_world();
        // draw_display();

        command = Le_Teclado();

        if (command != 255)
        {
            UART1_Write(command);
            switch (command)
            {
            case '6':
                input = 0B01000000 | DIREITA;
                UART1_Write_Text(" - andou direita");
                Pula_Linha();
                break;
            case '4':
                input = 0B01000000 | ESQUERDA;
                UART1_Write_Text(" - andou esquerda");
                Pula_Linha();
                break;
            case '8':
                input = 0B01000000 | CIMA;
                UART1_Write_Text(" - andou cima");
                Pula_Linha();
                break;
            case '2':
                input = 0B01000000 | BAIXO;
                UART1_Write_Text(" - andou baixo");
                Pula_Linha();
                break;
            case '9':
                input = MASCARA_PAUSE;
                UART1_Write_Text(" - jogo pausado");
                Pula_Linha();
                break;
            case '7':
                reset_game();
                UART1_Write_Text(" - jogo reiniciado");
                Pula_Linha();
                break;
            case '1':
                input = 0B00100000;
                UART1_Write_Text(" - adicionado fantasma");
                Pula_Linha();
                break;
            case '3':
                input = 0B00010000;
                UART1_Write_Text(" - adicionado pilula");
                Pula_Linha();
                break;
            case '5':
                print_world();
                break;
            }
        }
    }

      game_over_screen();
}

int cnt = 0;
void interrupt()
{
    if (int0if_bit)
    {
        FAZ_TICK = !FAZ_TICK;
        int0if_bit = 0;
        cnt++;
        if (cnt == 10)
        {
            ADD_COMIDA = 1;
            cnt = 0;
        }
    }
}
