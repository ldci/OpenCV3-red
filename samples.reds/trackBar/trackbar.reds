Red/System [
	Title:		"OpenCV Tests: Creating  Window"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2015 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../libs/include.reds ; all OpenCV  functions


windowsName: "OpenCV Window [ESC to close Window]"
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
cvResizeWindow windowsName 640 480

; function pointer called by TrackBar callback 
trackEvent: func [[cdecl] pos [integer!]][cvGetTrackbarPos "Track" windowsName print ["Trackbar position is : " pos lf]] 

p: declare pointer! [integer!]  ; for trackbar position
; for trackbar events 
cvCreateTrackbar "Track" windowsName p 50 :trackEvent ; function as parameter
cvSetTrackBarPos "Track" windowsName 0

cvMoveWindow windowsName 200 200
cvWaitKey 0
cvDestroyAllWindows