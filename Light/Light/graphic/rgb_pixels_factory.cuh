#pragma once
#include "pixels_factory.cuh"
#include <ctime>

class RgbPixelsFactory : public PixelsFactory
{
private:
	int random(int max);
	unsigned char randomChar();
public:
	virtual Pixel * generate(int count, int maxX, int maxY) override;
};