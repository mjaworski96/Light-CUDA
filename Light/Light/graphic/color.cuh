#pragma once

struct Color
{
	unsigned char red;
	unsigned char green;
	unsigned char blue;
public:
	Color(unsigned char red, unsigned char green, unsigned char blue)
	{
		this->red = red;
		this->green = green;
		this->blue = blue;
	}
	Color(unsigned char grey) : Color(grey, grey, grey)
	{
	}
	Color() : Color(0, 0, 0)
	{
	}
	unsigned char getLightness()
	{
		return 0.3 * red + 0.6 * green + 0.1 * blue;
	}
};