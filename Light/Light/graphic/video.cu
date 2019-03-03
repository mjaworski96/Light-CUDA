#include "video.cuh"
#include <opencv2/core/core.hpp>


Video::Video(char * filename, int fps, int width, int height)
{
	video.open(filename, VideoWriter::fourcc('M', 'J', 'P', 'G'), fps, Size(width, height));
}

void Video::addFrame(Image image)
{
	video.write(image.image);
}

void Video::finish()
{
	video.release();
}
