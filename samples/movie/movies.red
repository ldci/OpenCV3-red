Red [
	Title:		"OpenCV Movies Test"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; we use some Red/System code to access opencv as external lib

#system [
	; OpenCV functions we need
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures`
	#include %../../libs/core/core.reds             ; OpenCV core functions
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/videoio/videoio.reds       ; to play with camera
	capture: declare CvCapture!
	iplimage: declare IplImage!
	foo: 0
	cpt: 0.0
	nbFrames: 0.0
	 ;according to OS 
	#switch OS [
		;MacOSX  [movie: "/Users/fjouen/Movies/test.mov"]
		MacOSX  [movie: "/Users/fjouen/Movies/skate.mp4"]
		Windows [movie: "c:\Users\palm\Videos\skate.mp4"]
		Linux  	[movie: "/home/fjouen/Movies/skate.mp4"]
	]
]

; very simple program

render: routine [] [
	capture: cvCaptureFromFile movie
	nbFrames: cvGetCaptureProperty capture CV_CAP_PROP_FRAME_COUNT
	print [movie lf]
	print ["Width:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH lf]
	print ["Height:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT lf]
	print ["N of Frames:  " nbFrames lf]
	print ["FPS:  " cvGetCaptureProperty capture CV_CAP_PROP_FPS lf]

	cvNamedWindow movie CV_WINDOW_AUTOSIZE ; create window to show the movie
	cvMoveWindow movie  300 300
	foo: 0
	while [cpt < nbFrames] [
		iplimage: cvQueryFrame capture ; get frame
		print ["Frame: " cpt lf]
		cvShowImage movie  as byte-ptr! iplimage ; show frame
		foo: cvWaitKey 42 ; wait for 42 ms  (1/FPS * 1000)
		cpt: cpt + 1.0
	]

	print ["Done. Please wait" lf]
	cvWaitKey 2000
	cvDestroyAllWindows
	releaseImage as byte-ptr! iplimage
	releaseCapture capture
]	

render
