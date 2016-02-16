Red/System [
	Title:		"OpenCV Tests: Camera Edges"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../../libs/core/core.reds             ; OpenCV core functions
#include %../../../libs/imgproc/types_c.reds       ; image processing types and structures
#include %../../../libs/imgproc/imgproc.reds       ; OpenCV image  processing
#include %../../../libs/highgui/highgui.reds       ; highgui functions
#include %../../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
#include %../../../libs/videoio/videoio.reds       ; to play with camera


; Code pointer
trackEvent: func [[cdecl] pos [integer!] /local v param1] [ 
        v: (pos // 2) ; param must be odd !!!
        image: cvQueryFrame capture     ; get the frame
        if v = 1  [either pos <= 7 [neighbourhoodSize: pos] [neighbourhoodSize: 7]] ; odd and <= 7
        cvLaplace as int-ptr! image as int-ptr! laplace neighbourhoodSize
       	cvShowImage windowName as int-ptr! laplace   ; show frame   
]

cvStartWindowThread ; separate window thread
windowName: "Edge Detection: ESC for quit"
tbarname: "Edges"
neighbourhoodSize: 1
; for the trackbar  we need a pointer to get back value
p: declare pointer! [integer!]  ; for trackbar position

cvNamedWindow windowName CV_WINDOW_AUTOSIZE ; create window to show movie
capture: cvCreateCameraCapture CV_CAP_ANY;
image: cvRetrieveFrame capture ; get the first image
; set image to 640x480 
cvSetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH 640.00
cvSetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT 480.00

; for threshold
laplace: cvCreateImage 640 480 IPL_DEPTH_32F image/nChannels
cvCreateTrackbar tbarname windowName p 7 :trackEvent 
trackEvent 0

key:  27; 
foo: 0
; repeat until q keypress
while [foo <> key] [
    trackEvent neighbourhoodSize
    foo: cvWaitKey 1
]

cvWaitKey 0
