/* Variáveis globais */

/*
    Matrix de bytes para simbolização dos estados de cada espaço do tabuleiro

    Os dois bits a direita (menos significativos) definem o que é:
        00 -> espaço/item
        01 -> fantasma
        10 -> pacman
        11 -> pacman com power pill
    Os dois bytes seguintes definem o estado
        00 -> espaço em branco  / movendo para a direita
        01 -> Parede            / movendo para a esquerda
        10 -> Pilula normal     / movendo para cima
        11 -> Power pill        / movendo para baixo

    De forma que:
        0000 -> espaço em branco
        0001 -> fantasma indo para a direita
        0010 -> pacman indo para a direita
        0011 -> pacman com power pill indo para a direita
        0100 -> parede
        0101 -> fantasma indo para a esquerda
        0110 -> pacman indo para a esquerda
        0111 -> pacman com power pill indo para a esquerda
        1000 -> pilula
        1001 -> Fantasma indo para cima
        1010 -> Pacman indo para cima
        1011 -> Pacman com power pill indo para cima
        1100 -> power pill
        1101 -> fantasma indo para baixo
        1110 -> pacman indo para baixo
        1111 -> pacman com power pill indo para baixo

    Os quatro bits mais significativos são uma cópia da matriz
    Ela vai ser utilizada como buffer, pra realizar todas as operações em uma cópia, e depois faz o shift para a direita.
 */
unsigned short mapa[4][20];

/*
 * Byte para simbolizar o estado do jogo.
 * 
 *
 * O byte menos significativo significa executando ou pausado.
 * O segundo byte menos sigificativo é se o Pacman vivo ou morto.
 *
 * Isso é:
 *      00 -> jogo correndo normal
 *      01 -> jogo pausado
 *      10 -> pacman morto fantasmas andando
 *      11 -> pacman morto jogo parado
 *
 * Os outros significam a pontuação.
 *
 */
unsigned short estado;

/* Constantes */

unsigned short DIREITA = 0B0000000;
unsigned short ESQUERDA = 0B00000100;
unsigned short CIMA = 0B00001100;
unsigned short BAIXO = 0B00001000;

unsigned short MASCARA_MOVIMENTO = 0B00001100;
unsigned short MASCARA_TIPO = 0B00000011;

unsigned short MASCARA_PAUSE = 0B00000001;
unsigned short MASCARA_VIVO = 0B00000010;


void tick()
{
    preset()
    for (int i = 0; i < sizeof(mapa); i++)
    {
        for (int j = 0; i < sizeof(mapa[i]); i++)
        {
            sub_tick(i, j);
        }
    }
    swap();
}

unsigned short tipo(unsigned short obj)
{
    return obj & MASCARA_TIPO;
}

unsigned short direcao(unsigned short obj)
{
    return obj & MASCARA_MOVIMENTO;
}

unsigned short pausado()
{
    return estado & MASCARA_PAUSE;
}

unsigned short morto()
{
    return estado & MASCARA_VIVO;
}

void sub_tick(int i, int j)
{

    if (tipo(mapa[i][j]) == 0)
    {
        //Parede ou item
        return;
    }

    //i, j posição considerada
    //m, n, posição para o movimento
    int m = i;
    int n = j;

    unsigned short dire = direcao(mapa[i][j]);

    if (dire == DIREITA)
    {
        n++;
        if (n >= sizeof(mapa[i]))
        {
            n = 0;
        }
    }
    else if (dire == ESQUERDA)
    {
        n--;
        if (n < 0)
        {
            n = sizeof(mapa[i])-1;
        }
    }
    else if (dire == BAIXO)
    {
        m++;
        if (m >= sizeof(mapa))
        {
            m = 0;
        }
    }
    else
    {
        m--;
        if (m < 0)
        {
            m = sizeof(mapa)-1;
        }
    }


}

/*
 * Move os valores do buffer de trabalho (bits mais significativos)
 * e limpa o buffer de trabalho
 *
 * Isso é feito com o shift para a direita
 */
void swap()
{
    for (int i = 0; i < sizeof(mapa); i++)
    {
        for (int j = 0; i < sizeof(mapa[i]); i++)
        {
            mapa[i][j] = mapa[i][j] >> 4;
        }
    }
}

/*
 * Realiza uma cópia do estado para o buffer de trabalho
 */
void preset()
{
    for (int i = 0; i < sizeof(mapa); i++)
    {
        for (int j = 0; i < sizeof(mapa[i]); i++)
        {
            mapa[i][j] = (mapa[i][j] << 4) | mapa[i][j];
        }
    }
}
