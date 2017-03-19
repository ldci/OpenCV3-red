Red/System [
	Title:		"OpenCV Tests: Sort Test"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/include.reds ; all OpenCV  functions


windowsName: picture;  ; filename as title
;create opencv window
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
;load and show color image
tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
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