Red [
	Title:		"OpenCV Movies Test"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; we use some Red/System code to access opencv as external lib

#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	
	; global variables that can be used by routines
	capture: declare CvCapture!
	iplimage: declare IplImage!
	foo: 0
	cpt: 0
	nbFrames: 0
]

; very simple program

render: routine [] [
	capture: cvCaptureFromFile movie
	nbFrames: as integer! cvGetCaptureProperty capture CV_CAP_PROP_FRAME_COUNT
	print [movie lf]
	print ["Width:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH lf]
	print ["Height:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT lf]
	print ["N of Frames:  " nbFrames lf]
	print ["FPS:  " cvGetCaptureProperty capture CV_CAP_PROP_FPS lf]
	cvNamedWindow movie CV_WINDOW_AUTOSIZE ; create window to show the movie
	cvMoveWindow movie  300 300
	cvWaitKey 1000
	foo: 0
	while [cpt < (nbFrames - 2)] [
		iplimage: cvQueryFrame capture ; get frame
		print ["Frame: " cpt lf]
		cvShowImage movie  as int-ptr! iplimage ; show frame
		foo: cvWaitKey 42 ; wait for 42 ms  (1/FPS * 1000)
		cpt: cpt + 1
	]
	print ["Done. Please wait" lf]
	cvWaitKey 2000
	cvDestroyAllWindows
	; releaseImage as int-ptr! iplimage
	releaseCapture capture
]	

render
