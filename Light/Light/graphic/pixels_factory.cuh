#pragma once
#include "../simulation/pixel.cuh"

class PixelsFactory {
public:
	virtual Pixel* generate(int count, int maxX, int maxY) = 0;
};