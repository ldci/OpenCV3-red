#ifndef CAMERALIB_H
#define CAMERALIB_H

#include "cameralib_global.h"
#include <opencv2/opencv.hpp>

using namespace cv;



class CAMERALIBSHARED_EXPORT CameraLib
{

public:
    CameraLib();
};

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
    bool openFileApi(String fileName, int apiPreference);
}


#endif // CAMERALIB_H
