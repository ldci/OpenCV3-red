Red [
	Title:		"OpenCV Tests: Laplacian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	
	; global variables that can be used by routines
	kernel: 11 ; up to 31 but always ODD !!!
	srcWnd: "Source"
	dstWnd: "Laplacian"
	src: declare CvArr!
	dst: declare CvArr!
]


laplacian: routine [/local tmp] [
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
	dst: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_32F 3
	src: as int-ptr! tmp
	tmp: null
	cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE 
	cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
	cvMoveWindow dstWnd 620 100
	cvLaplace src dst kernel 
	cvShowImage srcWnd src
	cvShowImage dstWnd dst
	cvWaitKey 0 ; until a key is pressed
]

; free memory used by OpenCV
freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage src
	releaseImage dst
]

;*********************************** Main program ***********************
laplacian
freeOpenCV
quit
