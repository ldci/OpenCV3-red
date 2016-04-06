/*
 *  CameraLib.cpp
 *  CameraLib
 *
 *  Created by François Jouen on 16/01/2016.
 *  Copyright © 2016 François Jouen. All rights reserved.
 *
 */

#include <iostream>
#include "CameraLib.hpp"
#include "CameraLibPriv.hpp"

void CameraLib::HelloWorld(const char * s)
{
	 CameraLibPriv *theObj = new CameraLibPriv;
	 theObj->HelloWorldPriv(s);
	 delete theObj;
};

void CameraLibPriv::HelloWorldPriv(const char * s) 
{
	std::cout << s << std::endl;
};

extern "C"
{
bool openCamera(int index)
{
    return cam.open(index);
}

void releaseCamera()
{
    cam.release();
    frame.release();
}

bool setCameraProperty(int propId, double value)
{
    return cam.set(propId,value);
}

double getCameraProperty(int propId)
{
    return cam.get(propId);
}

IplImage* readCamera()
{
    cam.read(frame);
    image=frame;
    return &image;
}

bool grabFrame()
{
    return cam.grab();
}

IplImage* retrieveFrame(int flag)
{
    cam.retrieve(frame,flag);
    image=frame;
    return &image;
}

bool openFile(String fileName)
{
    return cam.open(fileName);
}

}
