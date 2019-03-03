#pragma once
#include "program.cuh"

class ImageProgram : public Program
{
public:
	virtual int main(int argc, char *argv[]) override;
	virtual void usage() override;
};
