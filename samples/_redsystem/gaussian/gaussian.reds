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

; accoding to OS 
#switch OS [
    MacOSX  [image: "/Users/fjouen/Pictures/baboon.jpg"]
    Windows [image: "c:\Users\palm\Pictures\baboon.jpg"]
]

srcWnd: "Using cvTrackbar: ESC to close"
dstWnd: "Gauusian Blur"
tBar: "Filter"
p: declare pointer! [integer!]  ; for trackbar position

; apply a gaussian blur according to the position of the trackbar (gaussian kernel= param1 * 3.0)
trackEvent: func [[importMode] pos [integer!] /local v param1] [ 
    v: (pos // 2) ; param1 must be odd !!!
    if v = 1  [param1: pos cvSmooth as byte-ptr! src  as byte-ptr! dst CV_GAUSSIAN param1 3 0.0 0.0 ]
    cvShowImage dstWnd as byte-ptr! dst
]

src: cvLoadImage image CV_LOAD_IMAGE_ANYCOLOR
dst: cvCloneImage src

;create windows for output images
cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE
cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
cvMoveWindow srcWnd 30 100
cvMoveWindow dstWnd 630 100

;associate trackbar
cvCreateTrackbar tBar srcWnd p 100 :trackEvent 

;show images
cvShowImage srcWnd as byte-ptr! src
cvShowImage dstWnd as byte-ptr! dst

cvWaitKey 0 ; until a key is pressed

; release window and images
&src: declare double-byte-ptr!
&src/ptr: as byte-ptr! src
&dst: declare double-byte-ptr!
&dst/ptr:  as byte-ptr! dst
cvReleaseImage  &src
cvReleaseImage  &dst
cvDestroyAllWindows

    