Red [
	Title:   "OpenCV Canny Red VID "
	Author:  "Francois Jouen"
	File: 	 %canny.red
	Needs:	 'View
]

; import required OpenCV libraries
#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	src: declare CvArr!	; pointer to Source image
	dst: declare CvArr!	; pointer to Destination image
	gray: declare CvArr!	; for grayscale image
	edges: declare CvArr!	; for edges detection
	&src: 0			; address of image as integer
	&dst: 0			; address of image as integer
]





; global red variables to be passed as parameters to routines or red functions
fileName: ""
thresh: 0
rimg: make image! reduce [512x512 black]
img1: 0
img2: 0
wsz: 0
hsz: 0
lineRequired: false
isFile: false

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

; red/S routines we need

makeCanny: routine [ t [integer!] /local tt][
	either t > 0 [tt: as float! t] [tt: 0.0]
	cvSmooth src dst CV_BLUR 3 3 0.0 0.0
	cvNot gray edges
	cvCanny gray edges tt tt * 3.0 3
	cvZero dst
	cvCopy src dst edges
]

; img1 source
loadSrc: routine [ name [string!] return: [integer!] /local fName isLoaded] [
	isLoaded: 0
	fName: as c-string! string/rs-head name;
	src: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR ;  force a 8-bit color conversion
	if src <> null [
		&src: as integer! src
		isLoaded: as integer! src
		cvFlip src src -1
	]
	isLoaded
]



; img2 destination color (cedges)
createDst: routine [return: [integer!]] [
	gray: as int-ptr! cvCreateImage getIWidth &src getIHeight &src IPL_DEPTH_8U 1
	cvCvtColor src gray CV_RGB2GRAY
	edges: as int-ptr! cvCreateImage getIWidth &src getIHeight &src IPL_DEPTH_8U 1
	dst: as int-ptr! cvCreateImage getIWidth &src getIHeight &src IPL_DEPTH_8U 3
	&dst: as integer! dst   
	&dst
]



getSrcOffset: routine [return: [logic!]/local sz][
	sz: (getIChannels &src) * (getIWidth &src) * (getIHeight &src)
	either (sz = getIImageSize &src) [false] [true]
]



getLine: routine [ img [integer!] ln [integer!] return: [binary!] /local step idx laddr] [
	step: getIStep img				; line size
	idx: (getIWStep img) * ln			; line index
	laddr: (getIImageData img) + idx				; line address
	getBinaryValue laddr step			; binary values	
]

getImageData: routine [img [integer!] return: [binary!] /local tmp] [
	tmp: as int-ptr! img
	getBinaryValue getIImageData img getIImageSize img
]

; release all image pointers
freeOpenCV: routine [] [
	releaseImage src
	releaseImage gray
	releaseImage edges
	releaseImage dst
]

; Red Functions calling routines

makeImage: function [ im w h return: [image!]] [		 
	rgb: getImageData im
	make image! reduce [as-pair w h reverse rgb]
]


makeImagebyLine: function [im w h return: [image!]] [
	y: 0
	rgb: copy #{}
	until [
		append rgb getLine im y
		y: y + 1
		y = h
	]
	make image! reduce [as-pair w h reverse rgb]	
]


loadImage: does [
	thresh: 0
	sl1/data: thresh
	canvas/image/rgb: black
	canvas/size: 0x0
	isFile: false
	tmp: request-file 
	if not none? tmp [
		isFile: true
		fileName: to string! to-local-file tmp	
		img1: loadSrc fileName
		img2: createDst
		if img1 <> 0 [
			win/text: fileName
			wsz: getIWidth img1
			hsz: getIHeight img1
			win/size/x: wsz + 20
			win/size/y: hsz + 80	
			canvas/size/x: wsz
			canvas/size/y: hsz
			canvas/image/size: canvas/size
			lineRequired: getSrcOffset
			either lineRequired [canvas/image: makeImagebyLine img1 wsz hsz] 
				[canvas/image: makeImage img1 wsz hsz]
			
		]
	]
	
]



; for Red GUI 

btnLoad: make face! [
	type: 'button text: "Load" offset: 10x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][loadImage]
	]
]


btnQuit: make face! [
	type: 'button text: "Close" offset: 80x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][ freeOpenCV quit]
	]
]


canvas: make face! [
	type: 'base offset: 10x70 size: 512x512
	image: rimg
]

text1: make face! [
	type: 'text offset: 10x40 size: 50x20 text: "Threshold"
]

text2: make face! [
	type: 'field offset: 490x40 size: 30x20 text: "0"
]

sl1: make face! [
	type: 'slider offset: 60x40 size: 420x20
	actors: object [
		on-change: func [face [object!] event [event! none!]][
			thresh: to integer! round face/data * 255
			text2/text: form to integer! round face/data * 255
			if isFile [
				makeCanny thresh
				either lineRequired [canvas/image: makeImagebyLine img2 wsz hsz] 
				[canvas/image: makeImage img2 wsz hsz]
				if thresh = 0 [
				either lineRequired [canvas/image: makeImagebyLine img1 wsz hsz] 
				[canvas/image: makeImage img1 wsz hsz]
				]
			]
		]
	]
]


; Make interface

win: make face! [
	type: 'window text: "Red View" size: 532x610
	pane:  []
]

append win/pane btnLoad
append win/pane btnQuit
append win/pane canvas
append win/pane sl1
append win/pane text1
append win/pane text2

view win