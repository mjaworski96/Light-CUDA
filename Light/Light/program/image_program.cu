#include "image_program.cuh"

#include <iostream>

#include "../kernel.cuh"
#include "../graphic/image.cuh"
#include "../graphic/pixels_factory.cuh"
#include "../graphic/rgb_pixels_factory.cuh"

int ImageProgram::main(int argc, char * argv[])
{
	if (argc != 6)
	{
		std::cout << "Invalid parameters count" << std::endl;
		usage();
		return -2;
	}
	srand(time(NULL));
	int cols = atoi(argv[2]);
	int rows = atoi(argv[3]);
	int count = atoi(argv[4]);;

	PixelsFactory* factory = new RgbPixelsFactory();
	Image image(rows, cols);
	int size = image.getSize();

	int blockSize = 256;
	int numBlocks = ceil((size + blockSize - 1) / (1.0 * blockSize));

	Pixel* inputPixels = factory->generate(count, cols, rows);
	Color* deviceResult;
	Pixel* deviceInputPixels;

	cudaMallocManaged(&deviceResult, size * sizeof(Color));
	cudaMallocManaged(&deviceInputPixels, count * sizeof(Pixel));
	cudaMemcpy(deviceInputPixels, inputPixels, count * sizeof(Pixel), cudaMemcpyHostToDevice);

	generateImage << < numBlocks, blockSize >> >
		(deviceInputPixels, count,
			deviceResult, cols, rows, size);
	cudaDeviceSynchronize();
	Color* result = new Color[size];
	cudaMemcpy(result, deviceResult, size * sizeof(Color), cudaMemcpyDeviceToHost);
	image.replacePixels(result);
	image.save(argv[5]);


	cudaFree(deviceInputPixels);
	cudaFree(deviceResult);

	delete[] result;
	delete[] inputPixels;
	return 0;
}

void ImageProgram::usage()
{
	std::cout << "program -i [cols] [rows] [count] [image] " << std::endl;
}
