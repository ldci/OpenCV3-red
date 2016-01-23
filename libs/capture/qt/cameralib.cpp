#include "cameralib.h"

CameraLib::CameraLib()
{
}

CAMERALIBSHARED_EXPORT bool openCamera(int index)
{
    return cam.open(index);
}


CAMERALIBSHARED_EXPORT void releaseCamera()
{
    cam.release();
}

CAMERALIBSHARED_EXPORT bool setCameraProperty(int propId, double value)
{
    return cam.set(propId,value);
}

CAMERALIBSHARED_EXPORT double getCameraProperty(int propId)
{
    return cam.get(propId);
}

CAMERALIBSHARED_EXPORT bool readCamera(OutputArray image)
{
    return cam.read(image);
}

CAMERALIBSHARED_EXPORT bool grabFrame()
{
    return cam.grab();
}

CAMERALIBSHARED_EXPORT bool retrieveFrame(OutputArray image,int flag)
{
    return cam.retrieve(image,flag);
}

CAMERALIBSHARED_EXPORT bool openFile(String fileName)
{
    return cam.open(fileName);
}

CAMERALIBSHARED_EXPORT bool openFileApi(String fileName, int apiPreference)
{
    return cam.open(fileName,apiPreference);
}

