Red/System [
	Title:		"OpenCV Tests: Mouse Events"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/red/types_r.reds          ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds         ; basic OpenCV types and structures
#include %../../../libs/imgproc/types_c.reds      ; image processing types and structures
#include %../../../libs/highgui/highgui.reds      ; highgui functions
#include %../../../libs/imgcodecs/imgcodecs.reds  ; basic image functions

; accoding to OS 
#switch OS [
    MacOSX  [image: "/Users/fjouen/Pictures/lena.tiff"]
    Windows [image: "c:\Users\palm\Pictures\lena.tiff"]
]


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
windowsName: image;  ; filename as title
;create opencv window
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
; set callback for mouse events
cvSetMouseCallBack windowsName :mouseEvent null
;load and show color image
img: cvLoadImage image CV_LOAD_IMAGE_ANYCOLOR
print ["image is " img/width "x" img/height newline]
cvShowImage windowsName as byte-ptr! img
cvMoveWindow windowsName 200 200
cvWaitKey 0
cvDestroyAllWindows