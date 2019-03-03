#include "image.cuh"
#include <opencv2/highgui/highgui.hpp>
#include <string.h>

Image::Image(int rows, int cols)
{
	image = Mat(rows, cols, CV_8UC3, Scalar(0, 0, 0));
}

Image::Image(char * filename)
{
	image = imread(filename, IMREAD_UNCHANGED);
}

int Image::getRows()
{
	return image.rows;
}

int Image::getCols()
{
	return image.cols;
}

int Image::getSize()
{
	return getRows() * getCols();
}

Color* Image::getPixels()
{
	Color* pixels = new Color[getSize()];
	for (int i = 0; i < getRows(); i++)
	{
		for (int j = 0; j < getCols(); j++)
		{
			pixels[i * getCols() + j] = convert(image.ptr(i, j));
		}
	}
	return pixels;
}

void Image::replacePixels(Color* pixels)
{
	for (int i = 0; i < getRows(); i++)
	{
		for (int j = 0; j < getCols(); j++)
		{
			convert(image.ptr(i, j), pixels[i * getCols() + j]);
		}
	}
}

void Image::save(char* filename)
{
	imwrite(filename, image);
}

bool Image::isLoaded()
{
	return !image.empty();
}


Color Image::convert(unsigned char * pixel)
{
	return Color(pixel[2], pixel[1], pixel[0]);
}
void Image::convert(unsigned char* pixel, Color color)
{
	pixel[0] = color.blue;
	pixel[1] = color.green;
	pixel[2] = color.red;
}
