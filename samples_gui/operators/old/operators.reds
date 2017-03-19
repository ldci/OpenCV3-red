Red [
	Title:   "OpenCV Image Operators Red VID "
	Author:  "Francois Jouen"
	File: 	 %operators.red
	Needs:	 'View
]


; import required OpenCV libraries
#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	
	; variables that can be used inside routines
	dst: declare CvArr!
	clone: declare CvArr!
	sum: declare CvArr!
	src: declare CvArr! 				; pointer to OpenCV Image
	&src: 0						; address of pointer as integer!
	&clone: 0
	&sum: 0
	&dst: 0
	wName: "OpenCV Source"
	isFile: false

]


; global red variables to be passed as parameters to routines or red functions
fileName: ""
isFile: false
lineRequired: false
img1: 0
; for interface
rimg: make image! reduce [512x512 black]
wsz: 0
hsz: 0


; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

; red/s routines we need
original: routine [] [
	cvCopy clone dst null
]

addImages: routine [][
	cvZero sum
	cvAdd src src sum null
	cvCopy sum dst null
	
]

subImages: routine [][
	cvZero sum
	cvSub src src sum null
	cvCopy sum dst null
]

addScalar: routine [/local v][
	v: cvScalar 255.0 0.0 0.0 0.0
	cvAddS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
]

subScalar: routine [/local v][
	v: cvScalar 0.0 0.0 255.0 0.0
	cvSubS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
]

subRScalar: routine [/local v][
	v: cvScalar 0.0 255.0 0.0 0.0
	cvSubRS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
]

multiplication: routine [][
	cvMul  src src sum 0.25
	cvCopy sum dst null
]

; better with 1-channel image!
division: routine [][
	cvDiv src src sum 0.10
	cvCopy sum dst null
]

scaleAdd: routine [] [
	cvScaleAdd src 1.0 0.0 0.0 0.0 src sum
	cvCopy sum dst null
]

AXPY: routine [] [
	cvAXPY src 1.0 1.0 1.0 0.0 src sum
	cvCopy sum dst null
]

addWeighted: routine [] [
	cvAddWeighted src 0.3  src 0.3 0.3 sum
	cvCopy sum dst null
]

andOperator: routine [] [
	cvAnd src clone sum null
	cvCopy sum dst null
]

andSOperator: routine [/local v] [
	v: cvScalar 127.0 127.0 127.0 0.0
	cvAndS src  v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
]

orOperator: routine [] [
	cvOr src sum sum null
	cvCopy sum dst null
]

orSOperator: routine [/local v] [
	v: cvScalar 0.0 255.0 0.0 0.0
	cvOrS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
]

xorOperator: routine [] [
	cvXor sum src sum null
	cvCopy sum dst null
]

xorSOperator: routine [/local v] [
	v: cvScalar 0.0 255.0 0.0 0.0
	cvXorS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
]

notOperator: routine [][
	cvNot src sum
	cvCopy sum dst null
]


loadImg: routine [ name [string!] return: [integer!] /local fName isLoaded] [
	isLoaded: 0
	isFile: false
	fName: as c-string! string/rs-head name;
	src: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR 
	clone: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR 
	dst: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR 
	sum:  as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR
	cvZero sum
	&src: as integer! src
	&sum: as integer! sum
	&clone: as integer! clone
	&dst: as integer! dst
	if src <> null [
		isLoaded: as integer! src  
		isFile: true
		;cvShowImage wName src
		cvFlip src src -1
		cvFlip dst dst -1
		cvFlip clone clone -1
	]
	
	isLoaded
]



getImageOffset: routine [return: [logic!]/local sz][
	sz: (getIChannels &dst) * (getIWidth &dst) * (getIHeight &dst)
	either (sz = getIImageSize &dst) [false] [true]
]


;Get data at line n  according to line number parameter
getOCVLine: routine [ln [integer!] return: [binary!] /local step idx laddr] [
	step: getStep &dst				; line size
	idx: (getIWStep &dst) * ln			; line index
	laddr: (getIImageData &dst) + idx				; line address
	getBinaryValue laddr step			; binary values	
]

getOCVData: routine [ return: [binary!]] [
	getBinaryValue getIImageData &dst getIImageSize &dst
]

; red functions
makeRedImagebyPtr: function [w h return: [image!]] [		 
	rgb: getOCVData				 
	make image! reduce [as-pair w h reverse rgb]
]

makeRedImagebyLine: function [w h return: [image!]] [
	y: 0
	rgb: copy #{}
	until [
		append rgb getOCVLine y
		y: y + 1
		y = h
	]
	make image! reduce [as-pair w h reverse rgb]	
]

; release all image pointers
freeOpenCV: routine [] [
	if isFile [
		releaseImage src
		releaseImage clone
		releaseImage sum]
]

; red functions


loadImage: does [
	isFile: false
	canvas/image/rgb: black
	canvas/size: 0x0
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-local-file tmp	
		img1: loadImg fileName
		if img1 <> 0 [
		isFile: true
			win/text: fileName
			;rimg: load tmp
			;canvas/image: rimg
			; update faces
			wsz: getIWidth img1
			hsz: getIHeight img1
			win/size/x: wsz + 20
			win/size/y: hsz + 60	
			canvas/size/x: wsz
			canvas/size/y: hsz
			canvas/image/size: canvas/size
			original
			lineRequired: getImageOffset
			checker/data: lineRequired 
			detail/text: "Original image"
			op/selected: 1
			either lineRequired [canvas/image: makeRedImagebyLine wsz hsz] 
				[canvas/image: makeRedImagebyPtr wsz hsz]
		]
        
	]
]

;interface 

btnLoad: make face! [
	type: 'button text: "Load" offset: 10x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][loadImage]
	]
]


btnQuit: make face! [
	type: 'button text: "Close" offset: 80x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][freeOpenCV quit]
	]
]




canvas: make face! [
	type: 'base offset: 10x40 size: 512x512
	image: rimg
]

detail: make face! [
	type: 'field offset: 240x10 size: 190x24
	
]
checker: make face![
	type: 'check text: "Line Required?" offset: 440x10 size: 100x24
	data: false
]

op: make face! [
	type: 'drop-list
		offset: 150x10
		size: 80x24
		data: ["Original" "cvAdd" "cvSub" "cvAddS" "cvSubS"	"cvSubRS" "cvMul" "cvDiv" "cvScaleAdd" "AXPY" 
		       "cvAddWeighted" "cvAnd" "cvAndS"	"cvOr" "cvOrS" "cvXor" "cvXorS"	"cvNot"]
		actors: object [
			on-create: func [face [object!]][
				face/selected: 1
			]
			on-change: func [face [object!] event [event!]][
			
			if isFile [
				switch op/selected[
					1 [original detail/text: "Original image"]
					2 [addImages detail/text: "Destination= Source + Source"]
					3 [subImages detail/text: "Destination= Source - Source : 0"]
					4 [addScalar detail/text: "Destination= Source + 255.0.0.0 value"]
					5 [subScalar detail/text: "Destination= Source - 0.0.255.0 value"]
					6 [subRScalar detail/text: "Destination= Source + 0.255.0.0 value"]
					7 [multiplication detail/text: "Destination= Source * 0.25"]
					8 [division detail/text: "Destination= Source / 0.10"]
					9 [scaleAdd  detail/text: "Destination= Source + 1.0 1.0 1.0 0.0"]
					10 [AXPY  detail/text: "Destination= Source + 1.0 1.0 1.0 0.0"]
					11 [addWeighted  detail/text: "Destination= Source + 0.33 weihgt" ]
					12 [andOperator detail/text: "Destination= Source AND Source" ]
					13 [andSOperator detail/text: "Destination= Source AND CvScalar (127.127.127.0) Value" ]
					14 [orOperator detail/text: "Destination= Source AND Source" ]
					15 [orSOperator  detail/text: "Destination= Source OR CvScalar (0.255.0.0) Value"]
					16 [xorOperator detail/text: "Destination= Source XOR Source"]
					17 [xorSOperator  detail/text: "Destination= Source XOR CvScalar (0.255.0.0) Value"]
					18 [notOperator  detail/text: "Destination= Source NOT Sum"]
				]
				either lineRequired [canvas/image: makeRedImagebyLine wsz hsz] 
				[canvas/image: makeRedImagebyPtr wsz hsz]
			]
			]
		]
]



win: make face! [
	type: 'window text: "Red View" size: 532x580
	pane:  []
]



append win/pane btnLoad
append win/pane btnQuit
append win/pane canvas
append win/pane detail
append win/pane checker
append win/pane op

view win