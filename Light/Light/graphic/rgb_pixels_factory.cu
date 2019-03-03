#include "rgb_pixels_factory.cuh"

int RgbPixelsFactory::random(int max)
{
	return rand() % max;
}
unsigned char RgbPixelsFactory::randomChar()
{
	return random(256);
}

Pixel * RgbPixelsFactory::generate(int count, int maxX, int maxY)
{
	Pixel* pixels = new Pixel[count];

	for (int i = 0; i < count; i++)
	{
		pixels[i].color.red = randomChar();
		pixels[i].color.green = randomChar();
		pixels[i].color.blue = randomChar();
		pixels[i].point.x = random(maxX);
		pixels[i].point.y = random(maxY);
	}
	

	return pixels;
}