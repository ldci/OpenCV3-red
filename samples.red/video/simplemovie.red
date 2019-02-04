Red [
	Title:		"OpenCV Movie Test with objects"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
	Needs:	 	'View
]

; we use some Red/System code to access opencv as external lib

#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	capture: declare CvCapture!
	&capture: declare double-int-ptr!
	iplimage: declare IplImage!
	pos: 0.0
	windowsName: "Movie"
	count: 0.0
	nbFrames: 0.0
]

; create red routines calling Red/System code


getNbFrames: routine [return: [float!]][
	cvGetCaptureProperty capture CV_CAP_PROP_FRAME_COUNT
]

createMovie: routine [name [string!] return: [integer!]] [
  	capture: cvCreateFileCapture as c-string! string/rs-head name
  	either (capture <> null) [
  		cvNamedWindow windowsName CV_WINDOW_NORMAL
  		;cvResizeWindow windowsName 640 480
  		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH 640.0
		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT 480.0
		nbFrames: cvGetCaptureProperty capture CV_CAP_PROP_FRAME_COUNT
  		&capture/ptr: capture
		return 0]
		[return 1]
]


render: routine [pos [float!]][
	cvSetCaptureProperty capture CV_CAP_PROP_POS_FRAMES pos
	iplimage: cvQueryFrame capture
	if iplimage <> null [
		cvShowImage windowsName as int-ptr! iplimage
	]
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
    open: 		func [device] [createMovie device]
  	read: 		func [count] [render count]
   	release: 	func [] [freeOpenCV]
]

;*********************** Main Program *******************************
mov: request-file
videoCapture/open to-string mov 
count: 0.0
nbf: getNbFrames
while [count < nbf] [
	videoCapture/read count
	count: count + 1.0
	recycle
	print [count stats]
]
print "Exit"
wait 2
videoCapture/release














