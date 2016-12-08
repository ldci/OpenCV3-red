Red/System [
	Title:		"OpenCV Tests: Laplacian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../../libs/include.reds ; all OpenCV  functions

srcWnd: "Using cvTrackbar: ESC to close"
dstWnd: "Gauusian Blur"
tBar: "Filter"
p: declare pointer! [integer!]  ; for trackbar position

; apply a gaussian blur according to the position of the trackbar (gaussian kernel= param1 * 3.0)
trackEvent: func [[importMode] pos [integer!] /local v param1] [ 
    v: (pos // 2) ; param1 must be odd !!!
    if v = 1  [param1: pos cvSmooth as int-ptr! src  as int-ptr! dst CV_GAUSSIAN param1 3 0.0 0.0 ]
    cvShowImage dstWnd as int-ptr! dst
]

src: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
dst: cvCloneImage src

;create windows for output images
cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE
cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
cvMoveWindow srcWnd 30 100
cvMoveWindow dstWnd 630 100

;associate trackbar
cvCreateTrackbar tBar srcWnd p 100 :trackEvent 

;show images
cvShowImage srcWnd as int-ptr! src
cvShowImage dstWnd as int-ptr! dst

cvWaitKey 0 ; until a key is pressed

; release window and images
releaseImage  as int-ptr! src
releaseImage as int-ptr! dst
cvDestroyAllWindows

    