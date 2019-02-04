Red [
	Title:		"OpenCV Camera Test with objects"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; we use some Red/System code to access opencv as external lib

#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	capture: declare CvCapture!
	&capture: declare double-int-ptr!
	iplimage: declare IplImage!
	count: 0
	windowsName: "Default Camera"
]

; create red routines calling Red/System code

; use webcam
createCam: routine [device [integer!] return: [integer!]] [
	capture: cvCreateCameraCapture device
	either (capture <> null) [
		cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH 640.00
		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT 480.00
		cvSetCaptureProperty capture CV_CAP_PROP_FPS 25.00
		&capture/ptr: capture
		return 0] 
		[return 1]
]


; render webcam 
render: routine [return: [integer!]] [
	count: count + 1
	print [count " : " ]
	iplimage: cvQueryFrame capture
	if iplimage = null [print "error" lf]
	cvShowImage windowsName as int-ptr! iplimage
	return cvWaitKey 1
]

; free memory used by OpenCV
freeOpenCV: routine [return: [integer!]] [
	cvDestroyAllWindows
	releaseImage as int-ptr! iplimage
	&capture/ptr: null
	cvReleaseCapture &capture
	return 0
]


; now create an object with 3 methods that call red/S routines
videoCapture: object [
	open: 		func [device] [createCam device]
   	read: 		func [] [render]
   	release: 	func [] [freeOpenCV]
]

;*********************** Main Program *******************************
cam: 0 ; access to default camera
videoCapture/open cam  
rep: 0
until [
	rep: videoCapture/read ; read images from camera until esc key is pressed
	print stats
	recycle
rep = escape
]

videoCapture/release










