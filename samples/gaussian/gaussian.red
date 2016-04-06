Red [
	Title:		"OpenCV Tests: Gaussian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/imgproc/types_c.reds       ; image processing types and structures
	#include %../../libs/highgui/cvhighgui.reds       ; highgui functions
	#include %../../libs/imgcodecs/cvimgcodecs.reds   ; basic image functions
	#include %../../libs/imgproc/cvimgproc.reds       ; OpenCV image  processing
	#include %../../libs/core/cvcore.reds             ; OpenCV core functions

	; according to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/baboon.jpg"]
		Windows [picture: "c:\Users\palm\Pictures\baboon.jpg"]
		Linux	[picture: "/home/fjouen/Images/baboon.jpg"]
	]
	
	src: declare CvArr!
	dst: declare CvArr!
	srcWnd: "Use cvTrackbar: ESC to close"
	dstWnd: "Gaussian Blur"
	tBar: "Filter"
	p: declare pointer! [integer!]  ; for trackbar position
        
        ; function pointer called by TrackBar callback
	trackEvent: func [[cdecl] pos [integer!] /local v param1][
		v: (pos // 2) ; param1 must be odd !!!
		if v = 1  [param1: pos cvSmooth src dst CV_GAUSSIAN param1 3 0.0 0.0 ]
		cvShowImage dstWnd dst
	] 
]

gaussian: routine [/local tmp] [
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
	dst: as int-ptr! cvCloneImage tmp
	src: as int-ptr! tmp
	tmp: null
	;create windows for output images
	cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE
	cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
	;associate trackbar
	cvCreateTrackbar tBar srcWnd p 100 :trackEvent
	cvMoveWindow srcWnd 30 100
	cvMoveWindow dstWnd 630 100
	;show images
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

;*************************** Main Program*********************

gaussian
freeOpenCV
quit