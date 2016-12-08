Red/System [
	Title:		"OpenCV Tests: Fourier Test"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/include.reds ; all OpenCV  functions



windowsName: picture;  ; filename as title
;create opencv window
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
;load and show color image
tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
src: as int-ptr! tmp
cvShowImage windowsName src

; we need grayscale images
gray: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1
img32: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_32F 1
; we need a matrix for Direct Fourier Transform
dst: as int-ptr! cvCreateMat tmp/width tmp/height CV_32FC1 

; src -> grayscale
cvCvtColor src gray CV_BGR2GRAY
; a 32-bit image
cvConvertScale gray img32 0.00392156862745 0.0
;Direct Fourier Transform
cvDFT img32 dst null CV_DXT_FORWARD 0 
; show result
cvShowImage "Fourier Transform" dst
cvMoveWindow "Fourier Transform" 550 100
cvWaitKey 0
cvDestroyAllWindows
releaseImage src
releaseImage gray
releaseImage img32
releaseMat dst
