Red [
	Title:		"OpenCV Tests: Sort Gray"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/imgproc/types_c.reds       ; image processing types and structures
	#include %../../libs/highgui/cvHighgui.reds       ; highgui functions
	#include %../../libs/imgcodecs/cvImgcodecs.reds   ; basic image functions
	#include %../../libs/imgproc/cvImgproc.reds       ; OpenCV image  processing
	#include %../../libs/core/cvCore.reds             ; OpenCV core functions

; according to OS 
	#switch OS [
	    MacOSX  [image: "/Users/fjouen/Pictures/lena.tiff"]
	    Windows [image: "c:\Users\palm\Pictures\lena.tiff"]
	    Linux  [image: "/home/fjouen/Images/lena.tiff"]
	]
	windowsName: image;  ; filename as title
	tmp: declare IplImage!
	src: declare CvArr!
	gray: declare CvArr!
	dst: declare CvArr!
	
]


; sort  by column
sort: routine [] [
	tmp: cvLoadImage image CV_LOAD_IMAGE_ANYCOLOR
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