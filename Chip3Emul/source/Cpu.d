static public const ushort opcodeNbr = 35;

struct JUMP
{
    ushort[opcodeNbr] mask;
    ushort[opcodeNbr] id;
}

class CPU
{
    this()
    {
        jumpnbr = 0;
        pc = debutAdress;
        game_counter = 0;
        sound_counter = 0;
        I = 0;

        foreach (i; memory)
        {
            i = 0;
        }
        foreach (i; V)
        {
            i = 0;
        }
        foreach (i; jump)
        {
            i = 0;
        }
    }

    void deduct()
    {
        if (game_counter > 0)
            game_counter--;

        if (sound_counter > 0)
            sound_counter--;
    }

    void initializeJump()
    {
        jp.mask[0] = 0x0000;
        jp.id[0] = 0x0FFF; /* 0NNN */
        jp.mask[1] = 0xFFFF;
        jp.id[1] = 0x00E0; /* 00E0 */
        jp.mask[2] = 0xFFFF;
        jp.id[2] = 0x00EE; /* 00EE */
        jp.mask[3] = 0xF000;
        jp.id[3] = 0x1000; /* 1NNN */
        jp.mask[4] = 0xF000;
        jp.id[4] = 0x2000; /* 2NNN */
        jp.mask[5] = 0xF000;
        jp.id[5] = 0x3000; /* 3XNN */
        jp.mask[6] = 0xF000;
        jp.id[6] = 0x4000; /* 4XNN */
        jp.mask[7] = 0xF00F;
        jp.id[7] = 0x5000; /* 5XY0 */
        jp.mask[8] = 0xF000;
        jp.id[8] = 0x6000; /* 6XNN */
        jp.mask[9] = 0xF000;
        jp.id[9] = 0x7000; /* 7XNN */
        jp.mask[10] = 0xF00F;
        jp.id[10] = 0x8000; /* 8XY0 */
        jp.mask[11] = 0xF00F;
        jp.id[11] = 0x8001; /* 8XY1 */
        jp.mask[12] = 0xF00F;
        jp.id[12] = 0x8002; /* 8XY2 */
        jp.mask[13] = 0xF00F;
        jp.id[13] = 0x8003; /* BXY3 */
        jp.mask[14] = 0xF00F;
        jp.id[14] = 0x8004; /* 8XY4 */
        jp.mask[15] = 0xF00F;
        jp.id[15] = 0x8005; /* 8XY5 */
        jp.mask[16] = 0xF00F;
        jp.id[16] = 0x8006; /* 8XY6 */
        jp.mask[17] = 0xF00F;
        jp.id[17] = 0x8007; /* 8XY7 */
        jp.mask[18] = 0xF00F;
        jp.id[18] = 0x800E; /* 8XYE */
        jp.mask[19] = 0xF00F;
        jp.id[19] = 0x9000; /* 9XY0 */
        jp.mask[20] = 0xF000;
        jp.id[20] = 0xA000; /* ANNN */
        jp.mask[21] = 0xF000;
        jp.id[21] = 0xB000; /* BNNN */
        jp.mask[22] = 0xF000;
        jp.id[22] = 0xC000; /* CXNN */
        jp.mask[23] = 0xF000;
        jp.id[23] = 0xD000; /* DXYN */
        jp.mask[24] = 0xF0FF;
        jp.id[24] = 0xE09E; /* EX9E */
        jp.mask[25] = 0xF0FF;
        jp.id[25] = 0xE0A1; /* EXA1 */
        jp.mask[26] = 0xF0FF;
        jp.id[26] = 0xF007; /* FX07 */
        jp.mask[27] = 0xF0FF;
        jp.id[27] = 0xF00A; /* FX0A */
        jp.mask[28] = 0xF0FF;
        jp.id[28] = 0xF015; /* FX15 */
        jp.mask[29] = 0xF0FF;
        jp.id[29] = 0xF018; /* FX18 */
        jp.mask[30] = 0xF0FF;
        jp.id[30] = 0xF01E; /* FX1E */
        jp.mask[31] = 0xF0FF;
        jp.id[31] = 0xF029; /* FX29 */
        jp.mask[32] = 0xF0FF;
        jp.id[32] = 0xF033; /* FX33 */
        jp.mask[33] = 0xF0FF;
        jp.id[33] = 0xF055; /* FX55 */
        jp.mask[34] = 0xF0FF;
        jp.id[34] = 0xF065; /* FX65 */
    }

    ushort recoverOpcode()
    {
        return (memory[pc] << 8) + memory[pc + 1];
    }

   /***********************************
    *Recuperer l'action effectuer par un opCode
    *
    */
    ubyte recoverAction(ushort opCode)
    {
        ubyte action;
        ushort result;
        for (action = 0; action < opcodeNbr; action++)
        {
            result = (jp.mask[action] & opCode); /* On récupère les bits concernés par le test, l'identifiant de l'opcode */

            if (result == jp.id[action]) /* On a trouvé l'action à effectuer */
                break; /* Plus la peine de continuer la boucle car la condition n'est vraie qu'une seule fois*/
        }
        return action;
    }
    /***********************************
     *interpreter
     */
    void interpreteOpcode(ushort opCode, ref Screen screen)
    {
        ubyte b4;
        b4 = recoverAction(opCode);
        b3=(opCode&(0x0F00))>>8;  //on prend les 4 bits représentant X
        b2=(opCode&(0x00F0))>>4;  //idem pour Y
        b1=(opCode&(0x000F));     //les 4 bits de poids faible
        switch (b4)
        {
        default: // valid: ends with 'throw'
            throw new Exception("unknow opCode");
        case 0:
            {
                //Cet opcode n'est pas implémenté
                break;
            }

        case 1:
            {
                //00E0 : efface l'écran
                break;
            }

        case 2:
            {
                //00EE : revient du saut
                break;
            }

        case 3:
            {
                //1NNN : effectue un saut à l'adresse 1NNN
                break;
            }

        case 4:
            {
                //2NNN : appelle le sous-programme en NNN, mais on revient ensuite
                break;
            }
        case 5:
            {
                //3XNN saute l'instruction suivante si VX est égal à NN.
                break;
            }
        case 6:
            { //4XNN saute l'instruction suivante si VX et NN ne sont pas égaux.

                break;
            }
        case 7:
            {
                //5XY0 saute l'instruction suivante si VX et VY sont égaux.

                break;
            }

        case 8:
            {
                //6XNN définit VX à NN.

                break;
            }
        case 9:
            {
                //7XNN ajoute NN à VX.

                break;
            }
        case 10:
            {
                //8XY0 définit VX à la valeur de VY.

                break;
            }
        case 11:
            {
                //8XY1 définit VX à VX OR VY.

                break;
            }
        case 12:
            {
                //8XY2 définit VX à VX AND VY.

                break;
            }
        case 13:
            {
                //8XY3 définit VX à VX XOR VY.

                break;
            }
        case 14:
            {
                //8XY4 ajoute VY à VX. VF est mis à 1 quand il y a un dépassement de mémoire (carry), et à 0 quand il n'y en pas.

                break;
            }
        case 15:
            {
                //8XY5 VY est soustraite de VX. VF est mis à 0 quand il y a un emprunt, et à 1 quand il n'y a en pas.

                break;
            }
        case 16:
            {

                //8XY6 décale (shift) VX à droite de 1 bit. VF est fixé à la valeur du bit de poids faible de VX avant le décalage.

                break;
            }
        case 17:
            {
                //8XY7 VX = VY - VX. VF est mis à 0 quand il y a un emprunt et à 1 quand il n'y en a pas.
                break;
            }
        case 18:
            {
                //8XYE décale (shift) VX à gauche de 1 bit. VF est fixé à la valeur du bit de poids fort de VX avant le décalage.

                break;
            }

        case 19:
            {

                //9XY0 saute l'instruction suivante si VX et VY ne sont pas égaux.

                break;
            }
        case 20:
            {
                //ANNN affecte NNN à I.

                break;
            }
        case 21:
            {
                //BNNN passe à l'adresse NNN + V0.

                break;

            }
        case 22:
            {

                //CXNN définit VX à un nombre aléatoire inférieur à NN.

                break;

            }

        case 23:
            {
                //DXYN dessine un sprite aux coordonnées (VX, VY).

                dessinerEcran(b1, b2, b3);
                

                break;

            }
        case 24:
            {
                //EX9E saute l'instruction suivante si la clé stockée dans VX est pressée.

                break;
            }
        case 25:
            {
                //EXA1 saute l'instruction suivante si la clé stockée dans VX n'est pas pressée.

                break;
            }

        case 26:
            {
                //FX07 définit VX à la valeur de la temporisation.

                break;
            }
        case 27:
            {
                //FX0A attend l'appui sur une touche et la stocke ensuite dans VX.

                break;
            }

        case 28:
            {
                //FX15 définit la temporisation à VX.

                break;
            }
        case 29:
            {
                //FX18 définit la minuterie sonore à VX.

                break;
            }
        case 30:
            {
                //FX1E ajoute à VX I. VF est mis à 1 quand il y a overflow (I+VX>0xFFF), et à 0 si tel n'est pas le cas.

                break;
            }

        case 31:
            //FX29 définit I à l'emplacement du caractère stocké dans VX. Les caractères 0-F (en hexadécimal) sont représentés par une police 4x5.
            break;

        case 32:
             //FX33 stocke dans la mémoire le code décimal représentant VX (dans I, I+1, I+2).
             break;

        case 33:
          //FX55 stocke V0 à VX en mémoire à partir de l'adresse I.
          break;
        case 34:
              //FX65 remplit V0 à VX avec les valeurs de la mémoire à partir de l'adresse I.

              break;
        }
        pc += 2;
    }

    ubyte[4096] memory; //La memoire d'une chip8 est d'un peux pres 4096 octet
    ubyte[16] V;
    ushort I;
    ushort[16] jump; //Pour gerer les sauts dans la memoire
    ubyte jumpnbr;
    ubyte game_counter;
    ubyte sound_counter;
    ushort pc;
    static const ushort debutAdress = 512;
    JUMP jp;
}
