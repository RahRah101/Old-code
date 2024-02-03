import dsfml.graphics;
import std.stdio;
import Cpu;

/***********************************
 * The monochrome chip8 screen
 */
class Screen : Drawable, Transformable
{
  /***********************************
   * Constructor
   */
   mixin NormalTransformable;

  this()
  {
    m_vertices = new VertexArray(PrimitiveType.Quads, screenSize_l * screenSize_L * 4);

    for (uint i = 0; i < screenSize_l; ++i){
        for (uint j = 0; j < screenSize_L; ++j){
            uint quad = (i + j * screenSize_l) * 4;

            /**
              * Bugs: Corner are not correctly defined
              */
            m_vertices[quad + 0].position = Vector2f(i * pixelSize, j * pixelSize);
            m_vertices[quad + 1].position = Vector2f((i + 1) * pixelSize, j * pixelSize);
            m_vertices[quad + 2].position = Vector2f((i + 1) * pixelSize, (j + 1) * pixelSize);
            m_vertices[quad + 3].position = Vector2f(i * pixelSize, (j + 1) * pixelSize);

            // define Color
            m_vertices[quad + 0].color = Color.Black;
            m_vertices[quad + 1].color = Color.Black;
            m_vertices[quad + 2].color = Color.Black;
            m_vertices[quad + 3].color = Color.Black;
          }
        }
  }

  /***********************************
   * To draw the graphics on the screen
   */

  override void draw(RenderTarget target, RenderStates states = RenderStates.Default)
  {
      states.transform *= getTransform();
      states.texture = m_texture;
      target.draw(m_vertices, states);
  }

  /***********************************
   * update the screen whit cpu info
   */

void updateScreen(ref CPU cpu, ubyte b1,ubyte b2, ubyte b3)
{
  ubyte x=0,y=0,k=0,code=0,j=0,offset=0;
  cpu.V[ 0xF ]=0;

   for(k=0;k<b1;k++)
   {
          code = cpu.memory[cpu.I+k];//on récupère le codage de la ligne à dessiner

          y = (cpu.V[ b2 ] + k ) % screenSize_L;//on calcule l'ordonnée de la ligne à dessiner, on ne doit pas dépasser L

          for(j=0,offset=7;j<8;j++,offset--)
           {
              x = ( cpu.V[ b3 ] + j ) % screenSize_l; //on calcule l'abscisse, on ne doit pas dépasser l

                      if(((code)&(0x1<<offset))!=0)//on récupère le bit correspondant
                      {   //si c'est blanc
                      const uint quad = (x + y * screenSize_l) * 4;
                          if( m_vertices[quad + 0].color== Color.White )//le pixel était blanc
                          {
                            m_vertices[quad + 0].color = Color.Black;
                            m_vertices[quad + 1].color = Color.Black;
                            m_vertices[quad + 2].color = Color.Black;
                            m_vertices[quad + 3].color = Color.Black;

                              cpu.V[0xF]=1; //il y a donc collusion

                          }
                          else
                          {
                            m_vertices[quad + 0].color = Color.White;
                            m_vertices[quad + 1].color = Color.White;
                            m_vertices[quad + 2].color = Color.White;
                            m_vertices[quad + 3].color = Color.White;
                          }


                      }

          }
      }
}
  /***********************************
   * Test the screen
   */

  void test()
  {
    for (uint i = 0; i < screenSize_l; ++i)
    {
        for (uint j = 0; j < screenSize_L; ++j){
          uint quad = (i + j * screenSize_l) * 4;

            if(i % (j + 1) == 0)
            {
              m_vertices[quad + 0].color = Color.Black;
              m_vertices[quad + 1].color = Color.Black;
              m_vertices[quad + 2].color = Color.Black;
              m_vertices[quad + 3].color = Color.Black;
            }
            else
              m_vertices[quad + 0].color = Color.White;
              m_vertices[quad + 1].color = Color.White;
              m_vertices[quad + 2].color = Color.White;
              m_vertices[quad + 3].color = Color.White;

            }
          }
  }


  /***********************************
   * Set all vertex of the VertexArray to Black
   */

  void clear()
  {
    for (uint i = 0; i < screenSize_l; ++i){
        for (uint j = 0; j < screenSize_L; ++j)
        {
            uint quad = (i + j * screenSize_l) * 4;
            // define Color
            m_vertices[quad + 0].color = Color.Black;
            m_vertices[quad + 1].color = Color.Black;
            m_vertices[quad + 2].color = Color.Black;
            m_vertices[quad + 3].color = Color.Black;
        }
      }
  }

  /***********************************
   * Define the size of a pixel
   */
  static const ubyte pixelSize = 8;

  /***********************************
   * Define the width of the screen
   */
  static const ubyte screenSize_l = 64;

  /***********************************
   * Define the height of the screen
   */
  static const ubyte screenSize_L = 32;

  /***********************************
   * A array of vertice, use it for the monochrome pixel
   * of the Chip8
   */
  VertexArray m_vertices;
  /***********************************
    *
    *
    */
  Texture m_texture;
}
