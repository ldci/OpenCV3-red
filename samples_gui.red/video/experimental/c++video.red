Red [
	Title:   "OpenCV Video VID"
	Author:  "Francois Jouen"
	File: 	 %c++video.red
	Needs:	 'View
]

#system [
	#include %../../../libs/include.reds ; all OpenCV  functions
	#include %../../../libs/capture/c++cam.reds
	img: 0	; Source image
]


; routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

margins: 10x10
imgCam: 0
cam: 0
isActive: false
firstImg: 0

activateCam: routine [camNbr [integer!]return: [integer!] /local r] [
	r: openCamera camNbr 
	setCameraProperty  CV_CAP_PROP_FRAME_WIDTH 640.00
	setCameraProperty  CV_CAP_PROP_FRAME_HEIGHT 480.00
	setCameraProperty  CV_CAP_PROP_FPS 25.00
	r
]

closeCam: routine [][releaseCamera]

renderCam: routine [return: [integer!]/local src] [
	img: readCamera
	src: as int-ptr! img
	cvFlip src src -1
	as integer! src
]

view win: layout [
	title "c++ Camera"
	text 60 "Camera" 
	button "Activate Cam" 	[activateCam cam isActive: true alert "Camera activated"]
	button "Start Cam" 		[if isActive [t0: now/time canvas/rate: 0:0:0.02] firstImg: 1]; 1/25 fps in ms	
	button "Stop Cam"		[canvas/image: black canvas/rate: none ]
	num: field 100
	ftime: field 100
	button 50 "Quit" 		[closeCam Quit]
	return
	pad 5x0
	canvas: base 640x480 black rate 0:0:0.04 on-time [
		t1: now/time
		imgCam: renderCam
		recycle/off
		either firstImg = 1 [canvas/image: makeRedImage imgCam 640 480] 
							[updateRedImage imgCam canvas/image]
		recycle/on
		ftime/text: form t1 - t0
		num/text: form firstImg
		firstImg: firstImg + 1
	]
	do [canvas/rate: none]
]