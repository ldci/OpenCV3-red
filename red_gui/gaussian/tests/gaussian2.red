Red [
	Title:   "OpenCV gaussian Red VID "
	Author:  "Francois Jouen"
	File: 	 %gaussian.red
	Needs:	 'View
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           	; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          	; basic OpenCV types and structures
	#include %../../libs/imgproc/types_c.reds       	; image processing types and structures
	#include %../../libs/highgui/cvHighgui.reds       	; highgui functions
	#include %../../libs/imgcodecs/cvImgcodecs.reds   	; basic image functions
	#include %../../libs/imgproc/cvImgproc.reds       	; OpenCV image  processing
	#include %../../libs/core/cvCore.reds             	; OpenCV core functions
	
	; define variables that can be used inside for routines
	src: declare CvArr!	; pointer to Source image
	dst: declare CvArr!	; pointer to Destination image
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

makeGaussianBlur: routine [ t [integer!]][
	cvSmooth src dst CV_GAUSSIAN t 3 0.0 0.0
]

cvLoadSrc: routine [ name [string!] return: [integer!] /local fName isLoaded] [
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

cvLoadDst: routine [ name [string!] return: [integer!] /local fName isLoaded] [
	isLoaded: 0
	fName: as c-string! string/rs-head name;
	dst: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR 
	if src <> null [
		&dst: as integer! dst
		isLoaded: as integer! dst  
		cvFlip dst dst -1
	]
	isLoaded
]



getSrcOffset: routine [return: [logic!]/local sz][
	sz: src/3 * src/11 * src/12
	either (sz = src/17) [false] [true]
]

getSrcLine: routine [ln [integer!] return: [binary!] /local step idx laddr] [
	step: getStep &src				; line size
	idx: (getIWStep &src) * ln			; line index
	laddr: src/18 + idx				; line address
	getBinaryValue laddr step			; binary values	
]

getDstLine: routine [ln [integer!] return: [binary!] /local step idx laddr] [
	step: getStep &dst				; line size
	idx: (getIWStep &dst) * ln			; line index
	laddr: dst/18 + idx				; line address
	getBinaryValue laddr step			; binary values	
]



getSrcData: routine [return: [binary!]] [
	getBinaryValue src/18 src/17
]

getDstData: routine [return: [binary!]] [
	getBinaryValue dst/18 dst/17
]


makeSrcImage: function [w h return: [image!]] [		 
	rgb: getSrcData
	make image! reduce [as-pair w h reverse rgb]
]

makeDstImage: function [w h return: [image!]] [		 
	rgb: getDstData				 
	make image! reduce [as-pair w h reverse rgb]
]


makeSrcImagebyLine: function [w h return: [image!]] [
	y: 0
	rgb: copy #{}
	until [
		append rgb getSrcLine y
		y: y + 1
		y = h
	]
	make image! reduce [as-pair w h reverse rgb]	
]

makeDstImagebyLine: function [w h return: [image!]] [
	y: 0
	rgb: copy #{}
	until [
		append rgb getDstLine y
		y: y + 1
		y = h
	]
	make image! reduce [as-pair w h reverse rgb]	
]


; Red Functions
loadImage: does [
	thresh: 0
	canvas/image/rgb: black
	canvas/size: 0x0
	sl1/data: 0
	tmp: request-file
	isFile: false
	if not none? tmp [		
		fileName: to string! to-local-file tmp	
		img1: cvLoadSrc fileName
		img2: cvLoadDst fileName
		if img1 <> 0 [
			isFile: true
			win/text: fileName
			wsz: getIWidth img1
			hsz: getIHeight img1
			win/size/x: wsz + 20
			win/size/y: hsz + 80	
			canvas/size/x: wsz
			canvas/size/y: hsz
			canvas/image/size: canvas/size
			lineRequired: getSrcOffset
			either lineRequired [canvas/image: makeSrcImageByLine wsz hsz] 
				[canvas/image: makeSrcImage wsz hsz]
			
		]
	]
]

; for Red Gui Interface

btnLoad: make face! [
	type: 'button text: "Load" offset: 10x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][loadImage]
	]
]


btnQuit: make face! [
	type: 'button text: "Close" offset: 80x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][quit]
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
			if odd? thresh [param1: to integer! round face/data * 255]
			text2/text: form to integer! round face/data * 255
			if isFile [
				makeGaussianBlur param1
				either lineRequired [canvas/image: makeDstImageByLine wsz hsz] 
				[canvas/image: makeDStImage wsz hsz]
				if thresh = 0 [
				either lineRequired [canvas/image: makeSrcImageByLine wsz hsz] 
				[canvas/image: makeSrcImage wsz hsz]
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