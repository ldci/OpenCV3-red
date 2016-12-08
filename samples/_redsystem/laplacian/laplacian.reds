Red/System [
	Title:		"OpenCV Tests: Laplacian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../../libs/include.reds ; all OpenCV  functions

srcWnd: "Source"
dstWnd: "Laplacian"
kernel: 3 ; up to 31 but always ODD !!!
src: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR

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
