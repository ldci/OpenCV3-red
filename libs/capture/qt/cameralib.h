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
    bool openCamera(int index);
    void releaseCamera();
    double getCameraProperty(int propId);
    bool setCameraProperty(int propId, double value);
    bool readCamera(OutputArray image);
    bool grabFrame();
    bool retrieveFrame(OutputArray image,int flag);
    bool openFile(String fileName);
    bool openFileApi(String fileName, int apiPreference);
}


#endif // CAMERALIB_H
