#include <iostream>
#include <string>
#include "program/program.cuh"
#include "program/image_program.cuh"
#include "program/video_program.cuh"

using namespace std;

void usage() 
{
	ImageProgram().usage();
	VideoProgram().usage();
}

int main(int argc, char *argv[])
{

	if (argc < 2)
	{
		cout << "This program should be run with parameters (-h for more information)" << endl;
		return - 1;
	}
	else
	{
		string mode = argv[1];
		if (mode == "-i")
			return ImageProgram().main(argc, argv);
		else if (mode == "-v")
			return VideoProgram().main(argc, argv);
		else if (mode == "-h")
			usage();
		else 
		{
			cout << "Invalid parameter: " << mode << endl << "Usage:" << endl;
			usage();
		}
	}
    return 0;
}