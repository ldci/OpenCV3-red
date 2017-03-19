Red [
	Title:		"OpenCV Tests: Gaussian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	
	; global variables that can be used by routines
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