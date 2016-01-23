Red [
	Title:		"Window with Trackbar"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	; OpenCV functions we need
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures`
	#include %../../libs/core/core.reds             ; OpenCV core functions
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	
	; global variables
	p: declare pointer! [integer!]  ; for trackbar position
	windowsName: "OpenCV Window [Any Key to close Window]"
	
	; function pointer called by TrackBar callback
	
	trackEvent: func [[cdecl] pos [integer!]][
		cvGetTrackbarPos "Track" windowsName
		print ["Trackbar position is : " pos lf]
	] 
]

; red routines are interface between red/system and red code. Great!
makeWindow: routine [] [
	cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
	; for trackbar events 
	cvCreateTrackbar "Track" windowsName p 49 :trackEvent ; function as parameter
	cvSetTrackBarPos "Track" windowsName 0
	cvResizeWindow windowsName 640 480
	cvMoveWindow windowsName 200 200
	cvWaitKey 0
	cvDestroyAllWindows
]
; just a simple red code :)
makeWindow