Red/System [
	Title:		"OpenCV Tests: Fourier Test"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/red/types_r.reds          ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds         ; basic OpenCV types and structures
#include %../../../libs/core/core.reds      	  ; core functions
#include %../../../libs/imgproc/types_c.reds      ; image processing types and structures
#include %../../../libs/highgui/highgui.reds      ; highgui functions
#include %../../../libs/imgproc/imgproc.reds      ; basic image functions
#include %../../../libs/imgcodecs/imgcodecs.reds  ; basic image functions

; according to OS 
#switch OS [
    MacOSX  [image: "/Users/fjouen/Pictures/baboon.jpg"]
    Windows [image: "c:\Users\palm\Pictures\lena.tiff"]
]



windowsName: image;  ; filename as title
;create opencv window
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
;load and show color image
tmp: cvLoadImage image CV_LOAD_IMAGE_ANYCOLOR
src: as byte-ptr! tmp
cvShowImage windowsName src

; we need grayscale images
gray: as byte-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1
img32: as byte-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_32F 1
; we need a matrix for Direct Fourier Transform
dst: as byte-ptr! cvCreateMat tmp/width tmp/height CV_32FC1 

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
