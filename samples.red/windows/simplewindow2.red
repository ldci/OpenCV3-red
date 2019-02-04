Red [
	Title:		"Creating  Window"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; variables
	windowsName: "OpenCV Window [Any Key to close Window]"
	cvimage: declare CvArr!
	&cvimage: 0
]

;#include %../../libs/red/cvroutines.red



; red routines are interface between red/system and red code. Great!
makeWindow: routine [] [
	cvimage: as int-ptr! cvCreateImage 640 480 IPL_DEPTH_8U 3
	&cvimage: as integer! cvimage
	cvSet cvimage 255.0 0.0 127.0 0.0 null
	cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
	cvShowImage windowsName cvimage
	cvResizeWindow windowsName 640 480
	cvMoveWindow windowsName 200 200
	cvWaitKey 0
	cvDestroyAllWindows
]
; just a simple red code :)
makeWindow
