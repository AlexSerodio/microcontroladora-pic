/* Variáveis globais */

/*
    Matrix de bytes para simbolização dos estados de cada espaço do tabuleiro

    Os dois bits a direita (menos significativos) definem o que é:
        00 -> pacman
        01 -> fantasma
        10 -> espaço / item
        11 -> pilula com fantasma
    Os dois bytes seguintes definem o estado
        00 -> espaço em branco  / movendo para a direita
        01 -> Parede            / movendo para a esquerda
        10 -> Pilula normal     / movendo para cima
        11 ->                   / movendo para baixo


    o caso 11 se refere à situação de um fantasma passando por cima de uma pilula


    De forma que:
        0000 -> pacman indo para a direita
        0001 -> fantasma indo para a direita
        0010 -> espaço em branco
        0011 -> fantasma com pilula indo para a direita
        0100 -> pacman indo para a esquerda
        0101 -> fantasma indo para a esquerda
        0110 -> parede
        0111 -> fantasma com pilula indo para a esquerda
        1000 -> pacman indo para cima
        1001 -> fantasma indo para cima
        1010 -> pilula
        1011 -> fantasma com pilula indo para a cima
        1100 -> pacman indo para baixo
        1101 -> fantasma indo para baixo
        1110 -> N/A
        1111 -> fantasma com pilula indo para a baixo

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
 *      10 -> pacman morto
 *      11 -> jogo finalizado
 *
 * Os outros significam a pontuação.
 *
 */
unsigned short estado;

//i, j posição considerada
//i_, j_, posição para o movimento
int i;
int j;
int i_;
int j_;

int pi;
int pj;

unsigned short dire;

/* Constantes */

unsigned short DIREITA  = 0B00000000;
unsigned short ESQUERDA = 0B00000100;
unsigned short BAIXO    = 0B00001000;
unsigned short CIMA     = 0B00001100;

unsigned short MASCARA_MOVIMENTO = 0B00001100;
unsigned short MASCARA_TIPO = 0B00000011;

unsigned short MASCARA_PAUSE = 0B00000001;
unsigned short MASCARA_VIVO = 0B00000010;

unsigned short tipo(unsigned short obj)
{
    return obj & MASCARA_TIPO;
}

unsigned short direcao(unsigned short obj)
{
    return obj & MASCARA_MOVIMENTO;
}

unsigned short pontuacao()
{
    return estado >> 2;
}

void set_pontuacao(unsigned short pto)
{
    estado = (pto << 2) | (estado & (MASCARA_PAUSE | MASCARA_VIVO));
}

unsigned short pausado()
{
    return estado & MASCARA_PAUSE;
}

unsigned short morto()
{
    return estado & MASCARA_VIVO;
}

bool is_fantasma(unsigned short obj)
{
    return obj & 0B00000001 == 0B00000001;
}

bool is_pacman(unsigned short obj)
{
    return tipo(obj) == 0B00000000;
}

bool is_parede(unsigned short obj)
{
    return tipo(obj) == 0B00000110
}

bool is_vazio(unsigned short obj)
{
    return tipo(obj) == 0B00000010
}

bool is_pilula(unsigned short obj)
{
    return tipo(obj) == 0B00001010
}

bool has_pilula(unsigned short obj)
{
    return obj & 0B00000011 == 0B00000011;
}

bool is_direcao_oposta(unsigned short obj, unsigned short other)
{
    if ((obj & 0b00001000) !=  (other 0b00001000))
    {
        return 1;
    }

    return (obj & 0b000001000) != (other & 0b000001000);
}

/*
 * Move os valores do buffer de trabalho (bits mais significativos)
 * e limpa o buffer de trabalho
 *
 * Isso é feito com o shift para a direita
 */
void swap_buffer()
{
    for (i = 0; i < sizeof(mapa); i++)
    {
        for (j = 0; i < sizeof(mapa[i]); i++)
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
    for (i = 0; i < sizeof(mapa); i++)
    {
        for (j = 0; i < sizeof(mapa[i]); i++)
        {
            mapa[i][j] = (mapa[i][j] << 4) | mapa[i][j];
        }
    }
}

void calc_direcao()
{
    //i, j posição considerada
    //i_, j_, posição para o movimento
    i_ = i;
    j_ = j;

    dire = direcao(mapa[i][j]);

    if (dire == DIREITA)
    {
        j_++;
        if (j_ >= sizeof(mapa[i]))
        {
            j_ = 0;
        }
    }
    else if (dire == ESQUERDA)
    {
        j_--;
        if (j_ < 0)
        {
            j_ = sizeof(mapa[i])-1;
        }
    }
    else if (dire == BAIXO)
    {
        i_++;
        if (i_ >= sizeof(mapa))
        {
            i_ = 0;
        }
    }
    else
    {
        i_--;
        if (i_ < 0)
        {
            i_ = sizeof(mapa)-1;
        }
    }
}

void tick_fantasma()
{

    calc_direcao();

    if (is_pacman(mapa[i_, j_]))
    {
        //TODO you lose
    }
    else if (is_parede(mapa[i_, j_]))
    {
        if (dire == DIREITA)
        {
            mapa[i, j] = (mapa[i, j] & 0b11110011) | BAIXO;
        }
        else if (dire == ESQUERDA)
        {
            mapa[i, j] = (mapa[i, j] & 0b11110011) | CIMA;
        }
        else if (dire == BAIXO)
        {
            mapa[i, j] = (mapa[i, j] & 0b11110011) | ESQUERDA;
        }
        else
        {
            mapa[i, j] = (mapa[i, j] & 0b11110011) | DIREITA;
        }
        tick_fantasma();
    }
    else if (is_pilula(mapa[i_, j_]))
    {
        if (has_pilula(mapa[i, j]))
        {
            mapa[i_, j_] = (mapa[i_, j_] & 0B00001111) | (mapa[i, j] << 4);
            mapa[i, j] = (mapa[i, j] & 0B00001111) | (mapa[i_, j_] << 4);
        }
        else
        {
            mapa[i_, j_] = (mapa[i_, j_] & 0B00001111) | ((dire | 0b00000011) << 4);
            mapa[i, j] = (mapa[i, j] & 0B00001111) | 0b00100000;
        }
    }
    else if (is_vazio(mapa[i_, j_]))
    {
        if (has_pilula(mapa[i, j]))
        {
            mapa[i_, j_] = (mapa[i_, j_] & 0B00001111) | ((dire | 0b00000001) << 4);
            mapa[i, j] = (mapa[i, j] & 0B00001111) | 0b10100000;
        }
        else
        {
            mapa[i_, j_] = (mapa[i_, j_] & 0B00001111) | (mapa[i, j] << 4);
            mapa[i, j] = (mapa[i, j] & 0B00001111) | (mapa[i_, j_] << 4);
        }
    }
    else if (is_fantasma(mapa[i_, m_]))
    {
        if (is_direcao_oposta(dire, direcao(mapa[i_, j_])))
        {
            mapa[i_, j_] = (mapa[i_, j_] & 0B00001111) | (mapa[i, j] << 4);
            mapa[i, j] = (mapa[i, j] & 0B00001111) | (mapa[i_, j_] << 4);
        }
        else
        {
            mapa[i_, j_] = (mapa[i_, j_] & 0B00001111) | (mapa[i, j] << 4);
            mapa[i, j] = (mapa[i, j] & 0B00001111) | (0b00100000);
        }
    }
}

void tick_pacman()

    calc_direcao();


        if (is_fantasma(mapa[i_, j_]))
        {
            if (is_direcao_oposta(mapa[i, j], mapa[i_, j_]))
            {
                //TODO you lose
                return;
            }
        }

        mapa[i_, j_] = (mapa[i_, j_] & 0B00001111) | (mapa[i, j] << 4);
        mapa[i, j] = (mapa[i, j] & 0B00001111) | 0b00100000;

        if (has_pilula(mapa[i_, j_]) || is_pilula(mapa[i_, j_]))
        {
            set_pontuacao(pontuacao() + 1);
        }

        return;

}


void tick()
{

    preset();
    for (i = 0; i < sizeof(mapa); i++)
    {
        for (j = 0; i < sizeof(mapa[i]); i++)
        {
            if (is_pacman(mapa[i, j]))
            {
                tick_pacman();
            }
        }
    }
    swap();

    preset();
    for (i = 0; i < sizeof(mapa); i++)
    {
        for (j = 0; i < sizeof(mapa[i]); i++)
        {
            if (is_fantasma(mapa[i, j]))
            {
                tick_fantasma();
            }
        }
    }
    swap();

}

