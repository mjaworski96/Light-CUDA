#pragma once
#include "color.cuh"
#include <opencv2/core/core.hpp>

using namespace cv;

class Image {
	friend class Video;
private:
	Mat image;
	Color convert(unsigned char* pixel);
	void convert(unsigned char* pixel, Color color);
public:
	Image(int rows, int cols);
	Image(char* filename);
	bool isLoaded();
	int getRows();
	int getCols();
	int getSize();
	Color* getPixels();
	void replacePixels(Color* pixels);
	void save(char* filename);
};
