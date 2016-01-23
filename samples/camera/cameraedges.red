Red [
	Title:		"OpenCV Camera Edges"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; OpenCV Functions import
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/core/core.reds             ; OpenCV core functions
	#include %../../libs/imgproc/types_c.reds       ; image processing types 	and structures
	#include %../../libs/imgproc/imgproc.reds       ; OpenCV image  processing
	#include %../../libs/highgui/highgui.reds       ; highgui functions	
	#include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
	#include %../../libs/videoio/videoio.reds       ; to play with camera
	; global variables
	capture: declare CvArr!
	&capture: declare dbptr!
	iplmage: declare IplImage!
	&iplmage: declare dbptr! ; we need a double pointer
	laplace: declare IplImage!
	&laplace: declare dbptr! ;
	neighbourhoodSize: 0
	p: declare pointer! [integer!]
	windowName: "Edge Detection: ESC for quit"
	tbarname: "Edges"

	; Code pointer associated to trackbar
	trackEvent: func [[cdecl] pos [integer!] /local v param1] [ 
		v: (pos // 2) ; param must be odd !!!
		iplmage: cvQueryFrame capture     ; get the frame
		if v = 1  [either pos <= 7 [neighbourhoodSize: pos] [neighbourhoodSize: 7]] ; odd and <= 7
		cvLaplace as byte-ptr! iplmage as byte-ptr! laplace neighbourhoodSize
		cvShowImage windowName as byte-ptr! laplace   ; show frame   
	]
	; for image depth
	depth: IPL_DEPTH_32F; for laplacian
]


; use webcam with OpenCV imported functions with red routine

createCam: routine [device [integer!] return: [integer!]] [
	cvStartWindowThread ; separate window thread
	neighbourhoodSize: 1
	; for the trackbar  we need a pointer to get back value
	p: declare pointer! [integer!]  ; for trackbar position
	capture: cvCreateCameraCapture device
	&capture/ptr: capture
	iplmage: cvRetrieveFrame capture ; get the first image
	; for threshold
	laplace: cvCreateImage 640 480 depth iplmage/nChannels 
	either (capture <> null) [
		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH 640.00
		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT 480.00
		cvSetCaptureProperty capture CV_CAP_PROP_FPS 25.00
		cvNamedWindow windowName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
		&capture/ptr: capture
		cvCreateTrackbar tbarname windowName p 7 :trackEvent 
		;trackEvent 0
		return 0] [return 1]
]

; render webcam 
render: routine [return: [integer!]] [
	trackEvent neighbourhoodSize
	return cvWaitKey 1
]

; free memory used by OpenCV
freeOpenCV: routine [return: [integer!]] [
	cvDestroyAllWindows
	&iplmage: declare dbptr! ; we need a double pointer
	&iplmage/ptr: as byte-ptr! iplmage
	cvReleaseImage &iplmage
	cvReleaseCapture &capture
	return 0
]


;**************main program *********************************
createCam 0 ; use first webcam
rep: 0
until [
	rep: does [render] ; read and process images from camera until esc key is pressed
	rep = escape
]
freeOpenCV ; free OpenCV pointers



