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
]

; red routines are interface between red/system and red code. Great!
makeWindow: routine [] [
	cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
	cvResizeWindow windowsName 640 480
	cvMoveWindow windowsName 200 200
	cvWaitKey 0
	cvDestroyAllWindows
]
; just a simple red code :)
makeWindow
