#include "opencv2/video/tracking.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/video/background_segm.hpp"
#include <string>
#include <iostream>

const std::string VideoFileName = "..\\..\\DataSrc\\StandUp1.AVI";
const std::string ResultFilePath = "..\\..\\DataRes";

using namespace cv;

int main(int argc, char **argv)
{
	VideoCapture cap;
	Mat frame, gbmForeground;
	BackgroundSubtractorMOG2 bgSubtractor;
	
	cap.open(VideoFileName);
	cap >> frame;

	namedWindow("Result");
	for(int index=0; ;index++)
	{
		std::string resFileName;
		std::stringstream resFileNameSS;
		if(frame.empty())
		{
			break;
		}

		if(index == 0)
		{
			bgSubtractor(frame, gbmForeground, 0.02);
			threshold(gbmForeground, gbmForeground, 128, 255, THRESH_BINARY);
			cap>>frame;
			continue;
		}

		bgSubtractor(frame, gbmForeground, 0.01);
		threshold(gbmForeground, gbmForeground, 128, 255, THRESH_BINARY);
		resFileNameSS<<ResultFilePath<<"\\"<<index<<".bmp";
		resFileNameSS>>resFileName;
		imwrite(resFileName, gbmForeground);
		imshow("Result", gbmForeground);
		waitKey(10);
		cap >> frame;
	}
}