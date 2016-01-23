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
	; OpenCV functions we need
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures`
	#include %../../libs/core/core.reds             ; OpenCV core functions
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/videoio/videoio.reds       ; to play with camera
	#include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
	#include %../../libs/imgproc/imgproc.reds	; image processing functions
	
	capture: declare CvArr!
	iplimage: declare IplImage!
        prevImage: declare IplImage! ; to use with cvcloneImage requiring IplImage!
        currImage: declare IplImage! ; to use with cvcloneImage requiring IplImage!
        nextImage: declare IplImage! ; to use with cvcloneImage requiring IplImage!
	d1: declare CvArr!
        d2: declare CvArr!
	r1: declare CvArr!
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
		d1: as byte-ptr! cvCreateImage 640 480 8 1
		d2: as byte-ptr! cvCreateImage 640 480 8 1
		r1: as byte-ptr! cvCreateImage 640 480 8 1
		prevImage: cvCreateImage 640 480 8 1
		currImage: cvCreateImage 640 480 8 1
		nextImage: cvCreateImage 640 480 8 1
		iplimage: cvQueryFrame capture
		cvCvtColor as byte-ptr! iplimage as byte-ptr! prevImage CV_RGB2GRAY
		cvCvtColor as byte-ptr! iplimage as byte-ptr! currImage CV_RGB2GRAY
		cvCvtColor as byte-ptr! iplimage as byte-ptr! nextImage CV_RGB2GRAY
	return 0]
	[return 1]
]

motion: routine [return: [integer!]] [
	cvAbsdiff as byte-ptr! prevImage as byte-ptr! currImage d1
	cvAbsdiff as byte-ptr! currImage as byte-ptr! nextImage d2
	cvAnd d1 d2 r1 null
	cvThreshold r1 r1 35.0 255.0 CV_THRESH_BINARY
	cvShowImage wName r1
	pixelMotion: cvCountNonZero r1
	print  ["mouvement " pixelMotion lf]
	prevImage: cvcloneImage currImage
        currImage: cvcloneImage nextImage
	iplimage: cvQueryFrame capture
	cvCvtColor as byte-ptr! iplimage as byte-ptr! nextImage CV_RGB2GRAY
	return cvWaitKey 1
]


freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage d1
	releaseImage d2
	releaseImage r1
	releaseImage as byte-ptr! prevImage
	releaseImage as byte-ptr! currImage
	releaseImage as byte-ptr! nextImage
	releaseImage as byte-ptr! iplimage
	releaseCapture capture
]


createCam 0

rep: 0
until [
	rep: motion ; read images from camera until esc key is pressed
rep = escape
]

freeOpenCV