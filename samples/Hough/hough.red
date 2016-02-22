Red [
	Title:		"OpenCV Tests: Gaussian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/imgproc/types_c.reds       ; image processing types and structures
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
	#include %../../libs/imgproc/imgproc.reds       ; OpenCV image  processing
	#include %../../libs/core/core.reds             ; OpenCV core functions

	; according to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/hough.jpg"]
		Windows [picture: "c:\Users\palm\Pictures\hough.jpg"]
		Linux	[picture: "/home/fjouen/Images/hough.jpg"]
	]
	
	; you can play with these variables to modifiy image processing
	rho: 1.0
	theta: PI / 180.0
	param1: 50.0
	param2: 10.0
	thresh: 50
	min_theta: 0.0
	max_theta: PI
	; end of variables you can play with

	size: declare CvSize!
	line: declare byte-ptr!
	pt1: declare CvPoint!
	pt2: declare CvPoint!
	ptr: declare int-ptr!
	srcWnd: "Source"
	dstWnd: "Hough Transform"
	src: declare CvArr!
	dst: declare CvArr!
	colorSrc: declare CvArr!
	colorDst: declare CvArr!
	storage: declare CvMemStorage!
	lines: declare CvSeq!
	line: declare byte-ptr!
]

process: routine [/local tmp c][
	tmp: cvLoadImage picture CV_LOAD_IMAGE_GRAYSCALE
	src: as int-ptr! tmp
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
	colorSrc: as int-ptr! tmp
	size/width: tmp/width
	size/height: tmp/height
	dst: as int-ptr! cvCreateImage size/width size/height IPL_DEPTH_8U 1
	colorDst: as int-ptr! cvCreateImage size/width size/height IPL_DEPTH_8U 3
	; create windows and show source
	cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE 
	cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
	cvMoveWindow dstWnd 500 300
	cvShowImage srcWnd colorSrc
	; Hough transform
	storage: cvCreateMemStorage 0
	cvCanny src dst 50.0 100.0 3
	cvCvtColor dst colorDst CV_GRAY2BGR
	lines: cvHoughLines2 dst as byte-ptr! storage CV_HOUGH_PROBABILISTIC rho theta thresh param1 param2 min_theta max_theta
	c: 0
	until [
		line: cvGetSeqElem lines c ; line is a byte-ptr!
		 ptr: as int-ptr! line ; we cast to an int-ptr! since we have 4 integers to get here
		pt1/x: ptr/1
		pt1/y: ptr/2
		pt2/x: ptr/3
		pt2/y: ptr/4
		cvLine colorDst pt1/x pt1/y pt2/x pt2/y 0.0 0.0 255.0 0.0 2 CV_AA 0
		c: c + 1
		c = lines/total
	]
	; show result
	cvShowImage  dstWnd colorDst
	cvWaitKey 0 
]

; free memory used by OpenCV
freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage src
	releaseImage  colorSrc
	releaseImage  dst
	releaseImage  colorDst
]

; Main
process
freeOpenCV
quit