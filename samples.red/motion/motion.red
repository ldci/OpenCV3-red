Red [
	Title:		"OpenCV Camera Test: Motion"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]
{ Based on
Collins, R., Lipton, A., Kanade, T., Fijiyoshi, H., Duggins, D., Tsin, Y., Tolliver, D., Enomoto,
N., Hasegawa, O., Burt, P., Wixson, L.: A system for video surveillance and monitoring. Tech.
rep., Carnegie Mellon University, Pittsburg, PA (2000)}


#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	
	; global variables that can be used by routines
	capture: declare CvArr!
	iplimage: declare IplImage!
    prevImage: declare IplImage! ; to use with cvcloneImage requiring IplImage!
	currImage: declare IplImage! ; to use with cvcloneImage requiring IplImage!
	nextImage: declare IplImage! ; to use with cvcloneImage requiring IplImage!
	d1: declare CvArr!
	d2: declare CvArr!
	d3: declare CvArr!
	wName: "Webcam Movement Detection [Esc to Quit]"
	pixelMotion: 0
]

createCam: routine [device [integer!] return: [integer!]] [
	capture: cvCreateCameraCapture device
	either (capture <> null) [
		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH 640.00
		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT 480.00
		cvSetCaptureProperty capture CV_CAP_PROP_FPS 25.00
		cvNamedWindow wName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
		cvMoveWindow wName  300 300
		d1: as int-ptr! cvCreateImage 640 480 8 1
		d2: as int-ptr! cvCreateImage 640 480 8 1
		d3: as int-ptr! cvCreateImage 640 480 8 1
		prevImage: cvCreateImage 640 480 8 1
		currImage: cvCreateImage 640 480 8 1
		nextImage: cvCreateImage 640 480 8 1
		iplimage: cvQueryFrame capture
		cvCvtColor as int-ptr! iplimage as int-ptr! prevImage CV_RGB2GRAY
		cvCvtColor as int-ptr! iplimage as int-ptr! currImage CV_RGB2GRAY
		cvCvtColor as int-ptr! iplimage as int-ptr! nextImage CV_RGB2GRAY
		return 0][return 1]
]

motion: routine [return: [integer!]] [
	cvAbsdiff as int-ptr! prevImage as int-ptr! currImage d1
	cvAbsdiff as int-ptr! currImage as int-ptr! nextImage d2
	cvAnd d1 d2 d3 null
	cvThreshold d3 d3 35.0 255.0 CV_THRESH_BINARY
	cvShowImage wName d3
	pixelMotion: cvCountNonZero d3
	print  ["mouvement " pixelMotion lf]
	cvCopy as int-ptr! currImage as int-ptr! prevImage null
	cvCopy as int-ptr! nextImage as int-ptr! currImage null
	;prevImage: cvcloneImage currImage
    ;currImage: cvcloneImage nextImage
	iplimage: cvQueryFrame capture
	cvCvtColor as int-ptr! iplimage as int-ptr! nextImage CV_RGB2GRAY
	return cvWaitKey 1
]


freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage d1
	releaseImage d2
	releaseImage d3
	releaseImage as int-ptr! prevImage
	releaseImage as int-ptr! currImage
	releaseImage as int-ptr! nextImage
	releaseImage as int-ptr! iplimage
	releaseCapture capture
]


createCam 0

rep: 0
until [
	rep: motion ; read images from camera until esc key is pressed
rep = escape
]

freeOpenCV