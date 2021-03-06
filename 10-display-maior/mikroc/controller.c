/* Variáveis globais */

/*
 *  Matrix de bytes para simbolização dos estados de cada espaço do tabuleiro
 *
 *  Os dois bits a direita (menos significativos) definem o que é:
 *      00 -> pacman
 *      01 -> fantasma
 *      10 -> espaço / item
 *      11 -> pilula com fantasma
 *  Os dois bytes seguintes definem o estado
 *      00 -> espaço em branco  / movendo para a direita
 *      01 -> Parede            / movendo para a esquerda
 *      10 -> Pilula normal     / movendo para cima
 *      11 ->                   / movendo para baixo
 *
 *
 *  o caso 11 se refere à situação de um fantasma passando por cima de uma pilula
 *
 *  Existe o caso especial do valo 1110, que é utilizado como nulo.
 *
 *
 *  De forma que:
 *      0000 -> pacman indo para a direita
 *      0001 -> fantasma indo para a direita
 *      0010 -> espaço em branco
 *      0011 -> fantasma com pilula indo para a direita
 *      0100 -> pacman indo para a esquerda
 *      0101 -> fantasma indo para a esquerda
 *      0110 -> parede
 *      0111 -> fantasma com pilula indo para a esquerda
 *      1000 -> pacman indo para cima
 *      1001 -> fantasma indo para cima
 *      1010 -> pilula
 *      1011 -> fantasma com pilula indo para a cima
 *      1100 -> pacman indo para baixo
 *      1101 -> fantasma indo para baixo
 *      1110 -> null
 *      1111 -> fantasma com pilula indo para a baixo
 *
 *  Os quatro bits mais significativos são uma cópia da matriz
 *  Ela vai ser utilizada como buffer, pra realizar todas as operações em uma cópia, e depois faz o shift para a direita.
 */

#define X_MAX 8
#define Y_MAX 15

// #define X_MAX 4
// #define Y_MAX 20

// unsigned short mapa[X_MAX][Y_MAX];
unsigned short mapa[X_MAX][Y_MAX];
// 128 X 240

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
 *      11 -> N/a
 *
 * Os outros significam a pontuação.
 *
 */
unsigned short estado;

/*
 * Variável verificada para aplicação de mudanças.
 *
 * o primeiro bit estar aceso faz com que o jogo troque entre pausado e correndo.
 *
 * o segundo bit indica se é desejado reiniciar o jogo.
 * 
 * os bits 3 e 4 (da direita para a esquerda) indicam a direção para qual mudar:
 *   00 -> direita
 *   01 -> esquerda
 *   10 -> cima
 *   11 -> baixo
 *
 * o quinto bit menos significante é lido como adicionar uma comida em uma
 * posição pseudo aleatória
 *
 * o sexto bit é lido como adicionar um fantasma em uma posição pseudo aleatória
 *
 * o setimo bit é o validador, precisa ser preenchido com 1 na hora de mudar de direção.
 */
unsigned short input;

//i, j posição considerada
//i_, j_, posição para o movimento
int i;
int j;
int i_;
int j_;

int k;

int ramdom;

unsigned short dire;

/* Constantes */

unsigned short DIREITA  = 0B00000000;
unsigned short ESQUERDA = 0B00000100;
unsigned short BAIXO    = 0B00001000;
unsigned short CIMA     = 0B00001100;

unsigned short NLL      = 0B00001110;
unsigned short PILULA   = 0B00001010;
unsigned short BRANCO   = 0B00000010; 
unsigned short PAREDE   = 0B00000110; 

unsigned short MASCARA_VALOR = 0B00001111;
unsigned short MASCARA_MOVIMENTO = 0B00001100;
unsigned short MASCARA_TIPO = 0B00000011;
unsigned short MASCARA_PAUSE = 0B00000001;
unsigned short MASCARA_VIVO = 0B00000010;

unsigned short tipo(unsigned short obj)
{
    return obj & MASCARA_TIPO;
}

unsigned short valor(unsigned short obj)
{
    return obj & MASCARA_VALOR;
}

unsigned short buffer_value(unsigned short obj)
{
    return obj >> 4;
}

unsigned short do_buffer(unsigned short obj)
{
    return obj << 4;
}

unsigned short add_pilula(unsigned short obj)
{
    return obj | 0b00000010;
}

unsigned short pop_pilula(unsigned short obj)
{
    return obj & 0b11111101;
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

unsigned short is_fantasma(unsigned short obj)
{
    if ((obj & 0B00000001) == 0B00000001)
    {
        return 1;
    }
    return 0;
}

unsigned short is_pacman(unsigned short obj)
{
    if (tipo(obj) == 0B00000000)
    {
        return 1;
    }
    return 0;
}

unsigned short is_parede(unsigned short obj)
{
    if (valor(obj) == 0B00000110)
    {
        return 1;
    }
    return 0;
}

unsigned short is_pilula(unsigned short obj)
{
    if (valor(obj) == 0B00001010)
    {
        return 1;
    }
    return 0;
}

unsigned short is_vazio(unsigned short obj)
{
    if (valor(obj) == 0B00000010)
    {
        return 1;
    }
    return 0;
}

unsigned short is_null(unsigned short obj)
{
    if (valor(obj) == 0B00001110)
    {
        return 1;
    }
    return 0;
}

unsigned short has_pilula(unsigned short obj)
{
    if ((obj & 0B00000011) == 0B00000011)
    {
        return 1;
    }
    return 0;
}

unsigned short is_direcao_oposta(unsigned short obj, unsigned short other)
{
    if ((obj & 0b00001000) !=  (other & 0b00001000))
    {
        return 0;
    }

    if ((obj & 0b000001000) != (other & 0b000001000))
    {
        return 1;
    }
    return 0;
}

/*
 * Move os valores do buffer de trabalho (bits mais significativos)
 * e limpa o buffer de trabalho
 *
 * Isso é feito com o shift para a direita
 */
void swap_buffer()
{
    for (i = 0; i < X_MAX; i++)
    {
        for (j = 0; j < Y_MAX; j++)
        {
            if (buffer_value(mapa[i][j]) != NLL)
            {
                mapa[i][j] = buffer_value(mapa[i][j]);
            }
            else
            {
                mapa[i][j] = valor(mapa[i][j]);
            }
        }
    }
}

/*
 * Realiza uma cópia do estado para o buffer de trabalho
 */
void preset()
{
    for (i = 0; i < X_MAX; i++)
    {
        for (j = 0; j < Y_MAX; j++)
        {
            mapa[i][j] = do_buffer(NLL) | mapa[i][j];
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
        if (j_ >= Y_MAX)
        {
            j_ = 0;
        }
    }
    else if (dire == ESQUERDA)
    {
        j_--;
        if (j_ < 0)
        {
            j_ = Y_MAX-1;
        }
    }
    else if (dire == BAIXO)
    {
        i_++;
        if (i_ >= X_MAX)
        {
            i_ = 0;
        }
    }
    else
    {
        i_--;
        if (i_ < 0)
        {
            i_ = X_MAX-1;
        }
    }
}

void muda_direcao()
{
    if (dire == DIREITA)
    {
        mapa[i][j] = (mapa[i][j] & 0b11110011) | BAIXO;
    }
    else if (dire == ESQUERDA)
    {
        mapa[i][j] = (mapa[i][j] & 0b11110011) | CIMA;
    }
    else if (dire == BAIXO)
    {
        mapa[i][j] = (mapa[i][j] & 0b11110011) | ESQUERDA;
    }
    else
    {
        mapa[i][j] = (mapa[i][j] & 0b11110011) | DIREITA;
    }
}

void tick_fantasma()
{

    for (k = 0; k < 5; k++) {
        calc_direcao();
        if (is_parede(mapa[i_][j_]) || is_fantasma(buffer_value(mapa[i_][j_])))
        {
            muda_direcao();
            continue;
        }
        break;
    }
    if (is_parede(mapa[i_][j_]) || is_fantasma(buffer_value(mapa[i_][j_])))
    {
        return;
    }
    if (is_pacman(buffer_value(mapa[i_][j_])))
    {
        estado = estado | MASCARA_VIVO;
    }
    else if (is_fantasma(mapa[i_][j_]))
    {
        if (is_direcao_oposta(dire, direcao(mapa[i_][j_])))
        {
            if (!has_pilula(mapa[i][j]) & has_pilula(mapa[i_][j_]))
            {
                mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(add_pilula(mapa[i][j]));
            }
            else if (has_pilula(mapa[i][j]) & !has_pilula(mapa[i_][j_]))
            {
                mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(pop_pilula(mapa[i][j]));
            }
            else
            {
                mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(mapa[i][j]);
            }
        }
        else
        {

            if (has_pilula(mapa[i_][j_]))
            {
                mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(add_pilula(mapa[i][j]));
            }
            else
            {
                mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(pop_pilula(mapa[i][j]));
            }

            if (buffer_value(mapa[i][j]) == NLL)
            {
                if (has_pilula(mapa[i][j]))
                {
                    mapa[i][j] = valor(mapa[i][j]) | do_buffer(PILULA);
                }
                else
                {
                    mapa[i][j] = valor(mapa[i][j]) | do_buffer(BRANCO);
                }
            }
        }
    }
    else if (is_pilula(mapa[i_][j_]))
    {
        if (has_pilula(mapa[i][j]))
        {
            mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(mapa[i][j]);
            if (buffer_value(mapa[i][j]) == NLL)
            {
                mapa[i][j] = valor(mapa[i][j]) | do_buffer(mapa[i_][j_]);
            }
        }
        else
        {
            mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(add_pilula(mapa[i][j]));
            if (buffer_value(mapa[i][j]) == NLL)
            {
                mapa[i][j] = valor(mapa[i][j]) | do_buffer(BRANCO);
            }
        }
    }
    else if (is_vazio(mapa[i_][j_]))
    {
        if (has_pilula(mapa[i][j]))
        {
            mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(pop_pilula(mapa[i][j]));
            if (buffer_value(mapa[i][j]) == NLL)
            {
                mapa[i][j] = valor(mapa[i][j]) | do_buffer(PILULA);
            }
            
        }
        else
        {
            mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(mapa[i][j]);
            if (buffer_value(mapa[i][j]) == NLL)
            {
                mapa[i][j] = valor(mapa[i][j]) | do_buffer(BRANCO);
            }
        }
    }
}

void tick_pacman()
{
    if ((input) > 0)
    {
        //muda a direção se input for não nill
        mapa[i][j] = (mapa[i][j] & 0B11110011) | direcao(input);
        input = 0b00000000;
    }

    calc_direcao();

    if (is_fantasma(buffer_value(mapa[i_][j_])))
    {
        estado = estado | MASCARA_VIVO;
        return;
    }

    if (is_fantasma(mapa[i_][j_]))
    {
        if (is_direcao_oposta(mapa[i][j], mapa[i_][j_]))
        {
            estado = estado | MASCARA_VIVO;
            return;
        }
    }
    else if (is_parede(mapa[i_][j_]))
    {
        mapa[i][j] = valor(mapa[i][j]) | do_buffer(mapa[i][j]);
    }
    else
    {
        mapa[i_][j_] = valor(mapa[i_][j_]) | do_buffer(mapa[i][j]);
        mapa[i][j] = valor(mapa[i][j]) | do_buffer(BRANCO);

        if (has_pilula(mapa[i_][j_]) || is_pilula(mapa[i_][j_]))
        {
            set_pontuacao(pontuacao() + 1);
        }
    }
}

void add_pilula_mapa()
{
    while (1)
    {
        i = rand() % X_MAX;
        j = rand() % Y_MAX;
        if (is_vazio(mapa[i][j]))
        {
            mapa[i][j] = PILULA;
            break;
        }
        else if (is_fantasma(mapa[i][j]) && !has_pilula(mapa[i][j]))
        {
            mapa[i][j] = add_pilula(mapa[i][j]);
            break;
        }
    }
}

void add_fantasma()
{
    while (1)
    {
        i = rand() % X_MAX;
        j = rand() % Y_MAX;
        if (is_vazio(mapa[i][j]))
        {
            mapa[i][j] = 0B00000001;
            break;
        }
    }

}

void reset()
{
    for (i = 0; i < X_MAX; i++)
    {
        for (j = 0; j < Y_MAX; j++)
        {
            if ((!((j+i)%6) || j%4==i%3) && (j % 2 == 0))
            {
               mapa[i][j] = PAREDE;
            }
            else
            {
                mapa[i][j] = BRANCO;
            }
        }
    }
    add_pilula_mapa();
    add_pilula_mapa();
    add_fantasma();
    mapa[0][0] = 0b00000000;
    estado = 0b00000000;
}


void tick()
{

    if ((input & MASCARA_PAUSE) > 0)
    {
        estado = estado ^ MASCARA_PAUSE;
        input = 0b00000000;
    }

    if ((input & MASCARA_VIVO) > 0)
    {
        reset();
        input = 0b00000000;
        return;
    }

    if ((!valor(input)) && buffer_value(input) > 0)
    {
        if ((buffer_value(input) & MASCARA_PAUSE) > 0)
        {
            add_pilula_mapa();
            input = 0b00000000;
            return;
        }
        if ((buffer_value(input) & MASCARA_VIVO) > 0)
        {
            add_fantasma();
            input = 0b00000000;
            return;
        }
    }

    if (pausado() || morto())
    {
        return;
    }

    preset();
    for (i = 0; i < X_MAX; i++)
    {
        for (j = 0; j < Y_MAX; j++)
        {
            if (is_pacman(mapa[i][j]))
            {
                tick_pacman();
            }
            if (is_fantasma(mapa[i][j]))
            {
                tick_fantasma();
            }
        }
    }
    swap_buffer();
}


unsigned short _tipo(unsigned short obj)
{
    return obj & MASCARA_TIPO;
}

unsigned short _is_fantasma(unsigned short obj)
{
    if ((obj & 0B00000001) == 0B00000001)
    {
        return 1;
    }
    return 0;
}

unsigned short _is_pacman(unsigned short obj)
{
    if (_tipo(obj) == 0B00000000)
    {
        return 1;
    }
    return 0;
}

unsigned short _valor(unsigned short obj)
{
    return obj & MASCARA_VALOR;
}

unsigned short _is_parede(unsigned short obj)
{
    if (_valor(obj) == 0B00000110)
    {
        return 1;
    }
    return 0;
}

unsigned short _is_pilula(unsigned short obj)
{
    if (_valor(obj) == 0B00001010)
    {
        return 1;
    }
    return 0;
}
