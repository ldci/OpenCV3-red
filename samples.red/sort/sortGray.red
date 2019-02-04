Red [
	Title:		"OpenCV Tests: Sort Gray"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	windowsName: picture;  ; filename as title
	tmp: declare IplImage!
	src: declare CvArr!
	gray: declare CvArr!
	dst: declare CvArr!
]


; sort  by column
sort: routine [] [
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
	src: as int-ptr! tmp
	dst: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1
	gray: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1
	cvCvtColor src gray CV_BGR2GRAY
	cvSort gray dst null CV_SORT_EVERY_COLUMN
	cvShowImage windowsName src
	cvShowImage "Sorted" dst
	cvMoveWindow "Sorted" 550 100
	cvWaitKey 0	
]


; free memory used by OpenCV
freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage src
	releaseImage dst
	releaseImage gray
	tmp: null
]

sort
freeOpenCV