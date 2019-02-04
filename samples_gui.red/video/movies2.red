Red [
	Title:   "OpenCV Video VID"
	Author:  "Francois Jouen"
	File: 	 %movies2.red
	Needs:	 'View
]

#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	src:  declare CvArr!
	img:  declare CvArr!
	img2: declare CvArr!
]

; routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red


isActive: false
current: 1.0
movie: none
fileName: copy ""
nFrames: 0.0
wsz: 0 hsz: 0


; routines calling OpenCV functions
loadSrc: routine [name [string!] return: [integer!] /local fName isLoaded] [
	isLoaded: 0
	;fName: as c-string! string/rs-head as red-string! #get 'fileName ; better
	fName: as c-string! string/rs-head name
	src: cvCreateFileCapture fName
	if src <> null [
		isLoaded: as integer! src
		img2: as int-ptr! cvCreateImage 640 480 IPL_DEPTH_8U 3
	]
	isLoaded
]

getWidth: routine [return: [float!]][
	cvGetCaptureProperty src CV_CAP_PROP_FRAME_WIDTH
]

getHeight: routine [return: [float!]][
	cvGetCaptureProperty src CV_CAP_PROP_FRAME_HEIGHT
]

getNbFrames: routine [return: [float!]][
	cvGetCaptureProperty src CV_CAP_PROP_FRAME_COUNT
]

getFPS: routine [return: [float!]][
	cvGetCaptureProperty src CV_CAP_PROP_FPS
]

getTime: routine [return: [float!]][
	cvGetCaptureProperty src CV_CAP_PROP_POS_MSEC
]

; only for camera
setMovieSize: routine [][
	cvSetCaptureProperty src CV_CAP_PROP_FRAME_WIDTH 640.0
	cvSetCaptureProperty src CV_CAP_PROP_FRAME_HEIGHT 480.0
]

getFrame: routine [pos [float!] return: [integer!]] [
	cvSetCaptureProperty src CV_CAP_PROP_POS_FRAMES pos
	;the returned image should not be released or modified by user.
	img: as int-ptr! cvQueryFrame src
	cvResize img img2 CV_INTER_LINEAR
	cvFlip img2 img2 -1
	as integer! img2
]


; Red functions calling routines
loadImage: does [
	recycle/off
	clear fileName
	isActive: false
	canvas/image: black
	tmp: request-file
	if not none? tmp [	
		fileName: to string! to-file tmp
		movie: loadSrc fileName
		if movie = 0 [Alert "Unsupported video file"]
		if movie > 0 [
			win/text: fileName
			wsz: to integer! getWidth	
			m1/text: form wsz
			hsz: to integer! getHeight 
			m2/text: form hsz
			nFrames: getNbFrames
			m3/text: form to integer! nFrames
			m4/text: form to integer! getFPS
			sb/text: ""
			current: 1.0
			wsz: 640
			hsz: 480
			canvas/image: make image! as-pair wsz hsz
			updateRedImage getFrame current canvas/image
			isActive: true
			recycle
			memo/text: form stats/show
		]
		sl/data: 0%
	]
	recycle/on
]

getImage: function [pos [float!]] [
	if isActive [
		recycle/off
		updateRedImage getFrame pos canvas/image
		memo/text: form stats/show
		sb/text: form getTime / 1000
		sb2/text: form to integer! pos
		recycle/on
	]
]

updateSlider: does [sl/data: to-percent current / (nFrames - 1.0)]

view win: layout [
	title "Movies"
	button "Load Movie" 	[loadImage]
	text 50 "Height" m1: field 50
	text 50 "Width" m2: field 50
	text 50 "Frames" m3: field 50
	text 50 "FPS" m4: field 50
	button 50 "Quit" 			[Quit]
	return
	canvas: base 640x480 rate 0:0:0.01 on-time [
		either current <= nFrames [
			getImage current current: current + 1.0 updateSlider
		] 
		[face/rate: none current: 1.0]
		
		
	]
	return
	sl: slider 640		[current: 1.0 + to-float to-integer sl/data * nframes 
							if current <= nFrames [getImage current]
						]
	return
	button "<<" 	[current: 1.0 getImage current sl/data: 0%]
	button "< "		[if current > 0.0 [current: current - 1.0 getImage current updateSlider]]
	button "> "		[if current < nFrames [current: current + 1.0 getImage current  updateSlider]]
	button ">>"		[current: nFrames  getImage current sl/data: 100%]
	button "Start"	[recycle canvas/rate: 0:0:0.01]	
	button "Stop"	[canvas/rate: none]
	sb: field 80
	sb2: field 80
	return
	text 100 "Used Memory" memo: field 530
	
	do [canvas/rate: none]
]