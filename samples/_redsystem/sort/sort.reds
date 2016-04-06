Red/System [
	Title:		"OpenCV Tests: Sort Test"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/red/types_r.reds          ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds         ; basic OpenCV types and structures
#include %../../../libs/core/cvCore.reds      	  ; core functions
#include %../../../libs/imgproc/types_c.reds      ; image processing types and structures
#include %../../../libs/highgui/cvHighgui.reds      ; highgui functions
#include %../../../libs/imgcodecs/cvImgcodecs.reds  ; basic image functions

; accoding to OS 
#switch OS [
    MacOSX  [image: "/Users/francoisjouen/Pictures/baboon.jpg"]
    Windows [image: "c:\Users\palm\Pictures\baboon.jpg"]
    Linux   [image: "/home/fjouen/Images/baboon.jpg"]
    
]


windowsName: image;  ; filename as title
;create opencv window
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
;load and show color image
tmp: cvLoadImage image CV_LOAD_IMAGE_ANYCOLOR
src: as int-ptr! tmp
dst: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 4
r: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
g: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
b: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1

cvSplit src r g b null
dst1: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
dst2: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
dst3: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
cvSort  r dst1 null 1
cvSort  g dst2 null 1
cvSort  b dst3 null 1
cvMerge dst1 dst2 dst3 null dst

cvShowImage windowsName src
;cvShowImage "r" dst1
;cvShowImage "g" dst2
;cvShowImage "b" dst3

cvShowImage "Sorted" dst
cvMoveWindow "Sorted" 550 100
cvWaitKey 0
cvDestroyAllWindows
releaseImage src
releaseImage dst
releaseImage r
releaseImage g
releaseImage b
releaseImage dst1
releaseImage dst2
releaseImage dst3