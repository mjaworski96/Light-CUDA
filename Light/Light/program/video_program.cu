#include "video_program.cuh"

#include <iostream>

#include "../kernel.cuh"
#include "../graphic/video.cuh"
#include "../graphic/pixels_factory.cuh"
#include "../graphic/rgb_pixels_factory.cuh"

void VideoProgram::movePixels(MovablePixel * pixels, int count, double step)
{
	for (int i = 0; i < count; i++)
	{
		pixels[i].move(step);
	}
}

MovablePixel * VideoProgram::createMovablePixels(Pixel * pixels, int count, int maxX, int maxY, int maxSpeed)
{
	MovablePixel* movable = new MovablePixel[count];

	for (int i = 0; i < count; i++)
	{
		movable[i].init(&pixels[i], maxX, maxY, maxSpeed);
	}

	return movable;
}

void VideoProgram::simulate(MovablePixel* pixels, int count, double step, double gravityConstans)
{
	for (int i = 0; i < count; i++)
	{
		unsigned char lightness1 = pixels[i].pixel->color.getLightness();
		if (lightness1 == 0)
		{
			continue;
		}
		for (int j = i + 1; j < count; j++)
		{
			unsigned char lightness2 = pixels[j].pixel->color.getLightness();
			if (lightness2 == 0)
			{
				continue;
			}
			double dx = pixels[j].pixel->point.x - pixels[i].pixel->point.x;
			double dy = pixels[j].pixel->point.y - pixels[i].pixel->point.y;
			double distanceSquare = dx * dx + dy * dy;
			if (distanceSquare > 0)
			{
				Point2D move(dx, dy);
				pixels[i].vector = pixels[i].vector + (move * (step * gravityConstans * lightness2 * lightness2 / distanceSquare));
				pixels[j].vector = pixels[j].vector + (move * (-step * gravityConstans * lightness1 * lightness1 / distanceSquare));
			}
		}
	}
}


int VideoProgram::main(int argc, char * argv[])
{
	if (argc != 10)
	{
		std::cout << "Invalid parameters count" << std::endl;
		usage();
		return -1;
	}
	srand(time(NULL));
	int cols = atoi(argv[2]);
	int rows = atoi(argv[3]);
	int time = atoi(argv[4]);;
	int fps = atoi(argv[5]);;
	int maxSpeed = atoi(argv[6]);
	int count = atoi(argv[7]);
	double gravity = atof(argv[8]);
	Video video(argv[9], fps, cols, rows);



	double step = 1.0 / fps;
	int framesCount = fps * time;

	PixelsFactory* factory = new RgbPixelsFactory();
	Image image(rows, cols);
	int size = image.getSize();

	int blockSize = 256;
	int numBlocks = ceil((size + blockSize - 1) / (1.0 * blockSize));


	Pixel* inputPixels = factory->generate(count, cols, rows);
	MovablePixel* movable = createMovablePixels(inputPixels, count, cols, rows, maxSpeed);
	Color* deviceResult;
	Pixel* deviceInputPixels;


	for (int i = 0; i < framesCount; i++)
	{
		std::cout << "Frame: " << i + 1 << "/" << framesCount << " " << (i + 1) * 100 / framesCount << "%" << std::endl;

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
		delete[] result;

		video.addFrame(image);
		simulate(movable, count, step, gravity);
		movePixels(movable, count, step);

		cudaFree(deviceInputPixels);
		cudaFree(deviceResult);
	}

	video.finish();
	delete[] movable;
	delete[] inputPixels;
	return 0;
}

void VideoProgram::usage()
{
	std::cout << "program -v [cols] [rows] [time] [fps] [maxSpeed] [input pixels count] [gravity] [video]" << std::endl;
}
