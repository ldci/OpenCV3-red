Red [
	Title:		"OpenCV Tests: Sort"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions

	; global variables that can be used by routines
	tmp: declare IplImage!
	src: declare CvArr!
	dst: declare CvArr!
	r: declare CvArr!
	g: declare CvArr!
	b: declare CvArr!
	dst1: declare CvArr!
	dst2: declare CvArr!
	dst3: declare CvArr!
	windowsName: picture;  ; filename as title
]
; sort each rgg channel by column
sort: routine [] [
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
	src: as int-ptr! tmp
	dst: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 3
	r: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	g: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	b: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	dst1: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	dst2: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	dst3: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	cvSplit src r g b null
	cvSort  r dst1 null CV_SORT_EVERY_COLUMN
	cvSort  g dst2 null CV_SORT_EVERY_COLUMN
	cvSort  b dst3 null CV_SORT_EVERY_COLUMN
	cvMerge dst1 dst2 dst3 null dst
	cvShowImage windowsName src
	;cvShowImage "r" dst1
	;cvShowImage "g" dst2
	;cvShowImage "b" dst3
	cvShowImage "Sorted" dst
	cvMoveWindow "Sorted" 550 100
	cvWaitKey 0	
]


; free memory used by OpenCV
freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage src
	releaseImage dst
	releaseImage r
	releaseImage g
	releaseImage b
	releaseImage dst1
	releaseImage dst2
	releaseImage dst3
	tmp: null
]

sort
freeOpenCV