#include "kernel.cuh"


__device__
unsigned char normalizeColor(int sum)
{
	if (sum > 255) return 255;
	return (unsigned char)sum;
}
__global__
void generateImage(Pixel* pixels, int pixelsCount,
	Color* result, int cols, int rows, int size)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;
	int stride = blockDim.x * gridDim.x;
	for (int i = index; i < size; i += stride)
	{
		int currentRow = index / cols;
		int currentCol = index % cols;
		int red = 0, green = 0, blue = 0;
		for (int j = 0; j < pixelsCount; j++)
		{
			double rowDist = currentRow - pixels[j].point.y;
			double colDist = currentCol - pixels[j].point.x;
			double distance = rowDist * rowDist + colDist * colDist + 1;
			// abs(rowDist) + abs(colDist) + 1;
			red += pixels[j].color.red * pixels[j].color.red / distance;
			green += pixels[j].color.green * pixels[j].color.green / distance;
			blue += pixels[j].color.blue * pixels[j].color.blue / distance;
		}
		result[i].red = normalizeColor(red);
		result[i].green = normalizeColor(green);
		result[i].blue = normalizeColor(blue);
	}
}