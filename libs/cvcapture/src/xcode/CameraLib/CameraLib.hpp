/*
 *  CameraLib.hpp
 *  CameraLib
 *
 *  Created by François Jouen on 16/01/2016.
 *  Copyright © 2016 François Jouen. All rights reserved.
 *
 */

#include <opencv2/opencv.hpp>

using namespace cv;

#ifndef CameraLib_
#define CameraLib_

/* The classes below are exported */
#pragma GCC visibility push(default)

class CameraLib
{
	public:
		void HelloWorld(const char *);
};


#pragma GCC visibility pop
#endif

extern "C"
{
    VideoCapture cam;
    Mat frame;
    IplImage image;
    bool openCamera(int index);
    void releaseCamera();
    double getCameraProperty(int propId);
    bool setCameraProperty(int propId, double value);
    IplImage* readCamera();
    bool grabFrame();
    IplImage* retrieveFrame(int flag);
    bool openFile(String fileName);
}
