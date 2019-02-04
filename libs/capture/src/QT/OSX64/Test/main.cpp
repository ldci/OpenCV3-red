//#include <QCoreApplication>
#include <opencv2/opencv.hpp>
#include "cameralib.h"

using namespace std;
int main()
{

    bool rep;
    std::cout << "Hello Camera world!" << std::endl;
    cvNamedWindow("Default Camera",0);
    cvResizeWindow("Default Camera",640,480);
    rep= openCamera(0);
    cout << "camera status : " << rep << std::endl;
    cout << "camera size : " << getCameraProperty(CV_CAP_PROP_FRAME_WIDTH) << std::endl;
    cout << "camera size : " << getCameraProperty(CV_CAP_PROP_FRAME_HEIGHT) << std::endl;
    // set camera size
    setCameraProperty(CV_CAP_PROP_FRAME_WIDTH, 640.00);
    setCameraProperty(CV_CAP_PROP_FRAME_HEIGHT, 480.00);
    cout << "camera size is now : " << getCameraProperty(CV_CAP_PROP_FRAME_WIDTH) << std::endl;
    cout << "camera size is now : " << getCameraProperty(CV_CAP_PROP_FRAME_HEIGHT) << std::endl;

    // we need an IplImage since wedon't use imshow!

    IplImage *image = readCamera();
    cout << "test : " << &image->ID << std::endl;
    cout << "read image nSize : " << image->nSize << std::endl; // waiting for 144
    cout << "image width : " << image->width << std::endl;
    cout << "image height : " << image->height << std::endl;
    cout << "image channels : " << image->nChannels << std::endl;
    cout << "image depth : " << image->depth << std::endl;
    //cvShowImage requires a pointer
    cvShowImage("Default Camera",image);

    // read several images
    for (;;)
    {
        image = readCamera();
        cvShowImage("Default Camera",image);
        if (cvWaitKey(40) >=0 ) break;
    }

    releaseCamera();
}
