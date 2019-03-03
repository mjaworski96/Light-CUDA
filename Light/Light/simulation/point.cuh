#pragma once
struct Point2D
{
	int x;
	int y;
	Point2D(int x, int y)
	{
		this->x = x;
		this->y = y;
	}
	Point2D() : Point2D(0, 0)
	{
	}
	Point2D operator+(Point2D& p)
	{
		return Point2D(x + p.x, y + p.y);
	}
	Point2D operator*(double a)
	{
		return Point2D(a * x, a * y);
	}
};