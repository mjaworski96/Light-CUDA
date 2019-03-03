#pragma once
#include "pixel.cuh"
#include "point.cuh"

struct MovablePixel 
{
	Pixel* pixel;
	Point2D vector;
	int maxX;
	int maxY;
	void init(Pixel* pixel, int maxX, int maxY, int maxSpeed) 
	{
		this->pixel = pixel;
		this->maxX = maxX;
		this->maxY = maxY;

		vector.x = randomSpeed(maxSpeed);
		vector.y = randomSpeed(maxSpeed);
	}
	int randomSpeed(int maxSpeed) 
	{
		if (maxSpeed == 0)
			return 0;
		return rand() % (2 * maxSpeed) - maxSpeed;
	}
	void move(double step)
	{
		pixel->point.x = changePosition(pixel->point.x, step, vector.x, maxX);
		pixel->point.y = changePosition(pixel->point.y, step, vector.y, maxY);
	}
	int changePosition(int startPositon, double step, int& move, int maxValue) 
	{
		int endPostion = startPositon;

		endPostion += (step * move);
		if (endPostion < 0)
		{
			endPostion = -endPostion;
			move = -move;
		}
		if (endPostion > maxValue)
		{
			endPostion = maxValue - (endPostion - maxValue);
			move = -move;
		}

		return endPostion;
	}
};