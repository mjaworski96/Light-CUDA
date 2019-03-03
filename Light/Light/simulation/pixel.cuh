#pragma once
#include "../graphic/color.cuh"
#include "../simulation/point.cuh"

struct Pixel
{
	Point2D point;
	Color color;
	Pixel(Point2D point, Color color)
	{
		this->point = point;
		this->color = color;
	}
	Pixel()
	{
	}
};