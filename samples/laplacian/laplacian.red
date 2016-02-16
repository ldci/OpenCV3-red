Red [
	Title:		"OpenCV Tests: Laplacian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
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
	
	; accoding to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/baboon.jpg"]
		Windows [picture: "c:\Users\palm\Pictures\baboon.jpg"]
		Linux	[picture: "/home/fjouen/Images/baboon.jpg"]
	]
	depth: IPL_DEPTH_32F
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

;*********************************** Mein program ***********************
laplacian
freeOpenCV
quit
