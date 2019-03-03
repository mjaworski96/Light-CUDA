#pragma once
#include "program.cuh"
#include "../simulation/movable_pixel.cuh"
#include "../simulation/pixel.cuh"

class VideoProgram : public Program
{
private:
	void simulate(MovablePixel* pixels, int count, double step, double gravityConstans);
	void movePixels(MovablePixel* pixels, int count, double step);
	MovablePixel* createMovablePixels(Pixel* pixels, int count, int maxX, int maxY, int maxSpeed);
public:
	virtual int main(int argc, char *argv[]) override;
	virtual void usage() override;
};

