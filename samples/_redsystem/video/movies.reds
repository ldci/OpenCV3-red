Red/System [
	Title:		"OpenCV Tests: Camera"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/include.reds ; all OpenCV  functions
; we use  default camera 
cvStartWindowThread ; separate window thread
print [movie lf]




capture: cvCreateFileCapture movie 


cvNamedWindow movie CV_WINDOW_AUTOSIZE
; some infomation about our movie
print ["Width:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH lf]
print ["Height:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT lf]
print ["N of Frames:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_COUNT lf]
print ["FPS:  " cvGetCaptureProperty capture CV_CAP_PROP_FPS lf] 

;get first image

image: cvRetrieveFrame capture ; get the first image
pimage: as int-ptr! image

key:  27
foo: 0

; repeat until esc keypress
while [foo <> key] [
    image: cvQueryFrame capture
    ;cvGrabFrame capture
    ;image: cvRetrieveFrame capture
    pimage: as int-ptr! image
    cvShowImage movie pimage
    foo: cvWaitKey 40
]

print ["Done. Any key to quit" lf]
cvWaitKey 0
cvDestroyAllWindows


 