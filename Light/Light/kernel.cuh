#pragma once
#include "simulation/pixel.cuh"
unsigned char normalizeColor(int sum);
__global__
void generateImage(Pixel* pixels, int pixelsCount,
	Color* result, int cols, int rows, int size);