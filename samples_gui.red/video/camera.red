Red [
	Title:   "OpenCV Video VID"
	Author:  "Francois Jouen"
	File: 	 %camera.red
	Needs:	 'View
]

#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	capture: declare CvCapture! ; for the camera
]


; routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

margins: 10x10
imgCam: 0
firstImg: 0
isActive: false

activateCam: routine [return: [integer!]] [
	capture: cvCreateCameraCapture CV_CAP_ANY ; 0 default camera
	cvSetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH 640.00
	cvSetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT 480.00
	cvSetCaptureProperty capture CV_CAP_PROP_FPS 25.00
	as integer! capture
]


renderCam: routine [return: [integer!]/local src] [
    ;The returned image should not be released or modified by user.
	src: as int-ptr! cvQueryFrame capture
	cvFlip src src -1
	as integer! src
]


view win: layout [
	title "OpenCV Camera"
	text 60 "Camera" 
	button "Activate Cam" 	[if activateCam <> 0 [
	 							alert "Camera activated"
	 							isActive: true
	 							memo/text: form stats/show]
	 						]
	button "Start Cam" 		[firstImg: 1 if isActive [t0: now/time canvas/rate: 0:0:0.04]]	
	button "Stop Cam"		[canvas/image: black canvas/rate: none firstImg: 0]
	num: field 100
	ftime: field 100
	button 50 "Quit" 		[ recycle/on Quit]
	return
	pad 5x0
	canvas: base 640x480 black rate 0:0:0.04 on-time [
		t1: now/time
		imgCam: renderCam
		recycle
		either firstImg = 1 [canvas/image: makeRedImage imgCam 640 480] 
							[updateRedImage imgCam canvas/image]
		ftime/text: form t1 - t0
		num/text: form firstImg
		firstImg: firstImg + 1
		memo/text: form stats/show
	]
	return
	pad 5x0 text 100 "Used Memory" memo: field 530 
	do [canvas/rate: none memo/text: form stats/show recycle/off]
]