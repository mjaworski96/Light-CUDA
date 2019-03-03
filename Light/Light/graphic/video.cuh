#pragma once
#include "image.cuh"
#include <opencv2/highgui/highgui.hpp> 

class Video
{
private:
	VideoWriter video;
public:
	Video(char * filename, int fps, int width, int height);
	void addFrame(Image image);
	void finish();
};
