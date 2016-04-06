Red [
	Title:		"OpenCV Tests: HSV"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/highgui/cvHighgui.reds       ; highgui functions
	#include %../../libs/imgproc/types_c.reds       ; image processing types and structures
	#include %../../libs/imgcodecs/cvImgcodecs.reds   ; basic image functions
	#include %../../libs/imgproc/cvImgproc.reds	    ; image processing functions
	#include %../../libs/core/cvCore.reds             ; OpenCV core functions

	; according to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/baboon.jpg"]
		Windows [picture: "c:\Users\palm\Pictures\baboon.jpg"]
		Linux  [picture: "/home/fjouen/Images/baboon.jpg"]
	]
	delay: 1000
	wName1: "Original Image"
	wName2: "HSV "
	wName3: "Extracted Mask"
	src: declare CvArr!
	hsv: declare CvArr!
	mask: declare CvArr!
]

loadImage: routine [/local v tmp] [
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR ; to get structure values
	src: as int-ptr! tmp
	; creates HSV image
	hsv: as int-ptr!  cvCloneImage tmp
	
	; conversion BGR to HSV 
	cvCvtColor src hsv CV_BGR2HSV
	; creates mask: same size as original but with  only 1 channel
	mask: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1;
	tmp: null
	cvZero mask
	v: cvScalar 255.0 255.0 255.0 0.0
	cvAddS mask v/v0 v/v1 v/v2 v/v3 mask null ; mask is white (test for cvAddS)
	; extract values > 127.00 in H channel and between 0 and 127 in S and V channels
	; you can play with value
	cvInRangeS hsv 127.0 0.0 0.0 0.0  255.0 127.0 127.0 0.0 mask
	cvNamedWindow wName1 CV_WINDOW_AUTOSIZE 
	cvNamedWindow wName2 CV_WINDOW_AUTOSIZE
	cvNamedWindow wName3 CV_WINDOW_AUTOSIZE
	cvShowImage wName1 src 
	cvShowImage wName2 hsv 
	cvShowImage wName3 mask 
	cvMoveWindow wName1  100 100
	cvMoveWindow wName2  140 200
	cvMoveWindow wName3  180 300
	cvWaitKey 0
]

freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage src
	releaseImage hsv
	releaseImage mask
]


loadImage
freeOpenCV
quit