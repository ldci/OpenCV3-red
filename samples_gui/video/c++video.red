Red [
	Title:   "OpenCV Video VID"
	Author:  "Francois Jouen"
	File: 	 %c++video.red
	Needs:	 'View
]

#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	#include %../../libs/capture/c++cam.reds
	img: 0	; Source image
]


; routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

margins: 10x10
imgCam: 0
cam: 0
isActive: false

activateCam: routine [camNbr [integer!]return: [integer!]] [
	setCameraProperty  CV_CAP_PROP_FRAME_WIDTH 640.00
	setCameraProperty  CV_CAP_PROP_FRAME_HEIGHT 480.00
	setCameraProperty  CV_CAP_PROP_FPS 25.00
	openCamera camNbr 
]

closeCam: routine [][releaseCamera]

renderCam: routine [return: [integer!]/local src] [
	img: readCamera
	src: as int-ptr! img
	cvFlip src src -1
	return as integer! src
]

view win: layout [
	title "Video"
	text "Camera" 
	wcam: drop-down 40
			data ["0" "1" "2"] 
			on-change [cam: to integer! face/selected - 1 activateCam cam isActive: true]
	button "Start Cam" 	[if isActive [canvas/rate: 0:0:0.04]]; 1/25 fps in ms	
	button "Stop Cam"	[canvas/image: black canvas/rate: none]
	button "Quit" 		[closeCam Quit]
	return
	canvas: base 640x480 rate 0:0:0.04 on-time [
		imgCam: renderCam
		canvas/image: makeRedImage imgCam 640 480
		]
	return
	do [ canvas/rate: none wcam/selected: 1]
]