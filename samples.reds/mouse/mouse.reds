Red/System [
	Title:		"OpenCV Tests: Mouse Events"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../libs/include.reds ; all OpenCV  functions


; this is pointer  to the function  called by mouse callback
mouseEvent: func [
	[cdecl]
            event 	[integer!]
            x	        [integer!]
            y	        [integer!]
            flags	[integer!]
            param	[pointer! [byte!]]
	] [
        print ["Mouse Position xy : " x " " y lf]
]

cvStartWindowThread  ; own's window thread 
windowsName: picture;  ; filename as title
;create opencv window
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
; set callback for mouse events
cvSetMouseCallBack windowsName :mouseEvent null
;load and show color image
img: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
print ["image is " img/width "x" img/height newline]
cvShowImage windowsName as int-ptr! img
cvMoveWindow windowsName 200 200
cvWaitKey 0
cvDestroyAllWindows