// 2016-2017
import Screen;
//import Cpu;
import dsfml.graphics;
import std.stdio;

void main()
{
	Screen Chip8screen = new Screen();
	Chip8screen.test();

	// create the window
	auto window = new RenderWindow(VideoMode(800, 600), "My window");

	// run the program as long as the window is open
	while (window.isOpen())
	{
			// check all the window's events that were triggered since the last iteration of the loop
			Event event;
			while (window.pollEvent(event))
			{
					// "close requested" event: we close the window
					if (event.type == Event.EventType.Closed)
							window.close();
			}

			// clear the window with black color
			window.clear(Color.Black);

			// draw everything here...
			window.draw(Chip8screen);

			// end the current frame
			window.display();
	}
}
