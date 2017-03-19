Red [
	Title:   "OpenCV Video VID"
	Author:  "Francois Jouen"
	File: 	 %movies.red
	Needs:	 'View
]

#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	#include %../../libs/capture/c++cam.reds
	src: declare CvArr!
	img: declare CvArr!
]

; routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

margins: 10x10
isActive: false
current: 1.0
movie: none
fileName: ""
nFrames: 0.0
wsz: 0 hsz: 0


; routines calling OpenCV functions
loadSrc: routine [name [string!] return: [integer!] /local fName ] [
	fName: as c-string! string/rs-head name;
	src: cvCreateFileCapture fName
	as integer! src
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

setMovieSize: routine [][
	cvSetCaptureProperty src CV_CAP_PROP_FRAME_WIDTH 640.0
	cvSetCaptureProperty src CV_CAP_PROP_FRAME_HEIGHT 480.0
]

getFrame: routine [pos [float!] return: [integer!] /local ret] [
	cvSetCaptureProperty src CV_CAP_PROP_POS_FRAMES pos
	;ret: cvGrabFrame src
	;img: as int-ptr! cvRetrieveFrame src
	img: as int-ptr! cvQueryFrame src
	cvFlip img img -1
	as integer! img
]



; Red functions calling routines
loadImage: does [
	canvas/image: black
	tmp: request-file
	if not none? tmp [	
		fileName: to string! to-local-file tmp
		win/text: fileName
		isActive: true
		movie: loadSrc fileName
		wsz: to integer! getWidth	
		m1/text: form wsz
		hsz: to integer! getHeight 
		m2/text: form hsz
		nFrames: getNbFrames
		m3/text: form to integer! nFrames
		m4/text: form to integer! getFPS
		sb/text: ""
		either hsz > 480 [win/size/y: hsz + 110 ] [win/size/y: 530]
		either wsz > 640 [win/size/x: wsz + 30] [win/size/x: 670]
			
		canvas/size/x: wsz
		canvas/size/y: hsz
		canvas/offset/x:( win/size/x / 2) - (wsz / 2)
		canvas/offset/y:( win/size/y / 2) - (hsz / 2)
		b1/offset/y: win/size/y - 35
		b2/offset/y: win/size/y - 35
		b3/offset/y: win/size/y - 35
		b4/offset/y: win/size/y - 35
		b5/offset/y: win/size/y - 35
		b6/offset/y: win/size/y - 35
		sb/offset/y: win/size/y - 35
		sb2/offset/y: win/size/y - 35
		current: 1.0
		canvas/image: makeRedImage getFrame 1.0 wsz hsz
	]
]

getImage: function [pos [float!]] [
	imgm: getFrame pos
	;either pos = 1.0 [canvas/image: makeRedImage imgm wsz hsz]
	;				 [updateRedImage imgm canvas/image]
	
	canvas/image: makeRedImage imgm wsz hsz
	sb/text: form getTime / 1000; to integer! pos
	sb2/text: form to integer! pos
]

view win: layout [
	title "Movies"
	button "Load Movie" 	[loadImage]
	text 50 "Height" m1: field 50
	text 50 "Width" m2: field 50
	text 50 "Frames" m3: field 50
	text 50 "FPS" m4: field 50
	button 80 "Quit" 			[Quit]
	return
	canvas: base 640x480 rate 0:0:0.04 on-time [
		if current >= nFrames [face/rate: none]
		getImage current
		current: current + 1.0
	]
	return
	b1: button "<<" 	[current: 1.0 getImage current]
	b2: button "< "		[if current > 0.0 [current: current - 1.0 getImage current]]
	b3: button "Start"	[if isActive [canvas/rate: 0:0:0.01]]	
	b4: button "Stop"	[canvas/rate: none]
	b5: button "> "		[if current < nFrames [current: current + 1.0 getImage current]]
	b6: button ">>"		[current: nFrames - 1.0  getImage current]
	sb: field 80
	sb2: field 80
	do [canvas/rate: none]
]