Red/System [
	Title:		"OpenCV Tests: Laplacian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../../libs/imgproc/types_c.reds       ; image processing types and structures
#include %../../../libs/highgui/highgui.reds       ; highgui functions
#include %../../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
#include %../../../libs/imgproc/imgproc.reds       ; OpenCV image  processing
#include %../../../libs/core/core.reds             ; OpenCV core functions

; according to OS 
#switch OS [
    MacOSX  [image: "/Users/fjouen/Pictures/baboon.jpg"]
    Windows [image: "c:\Users\palm\Pictures\baboon.jpg"]
    Linux   [image: "/home/fjouen/Images/baboon.jpg"]
]

srcWnd: "Source"
dstWnd: "Laplacian"
kernel: 3 ; up to 31 but always ODD !!!
src: cvLoadImage image CV_LOAD_IMAGE_ANYCOLOR

dst: cvCloneImage src

cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE 
cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE

cvMoveWindow dstWnd 620 100
; OK for OSX and Windows but not for Linux!!!
cvLaplace as int-ptr! src  as int-ptr! dst kernel

cvShowImage srcWnd  as int-ptr! src
cvShowImage  dstWnd  as int-ptr! dst

cvWaitKey 0 ; until a key is pressed
    
; release window and images

releaseImage  as int-ptr! src
releaseImage  as int-ptr! dst
cvDestroyAllWindows 
