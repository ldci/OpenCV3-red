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
	dst: declare CvArr!
	clone: declare CvArr!
	sum: declare CvArr!
	src: declare CvArr! 				; pointer to OpenCV Image
	&src: 0						; address of pointer as integer!
	&clone: 0
	&sum: 0
	&dst: 0
	isFile: false

]


; global red variables to be passed as parameters to routines or red functions
fileName: ""
isFile: false
lineRequired: false
img1: 0
img2: 0
wsz: 0
hsz: 0


; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

; red/s routines we need
original: routine [return: [integer!]] [
	cvCopy clone dst null
	as integer! dst
]

addImages: routine [return: [integer!]][
	cvZero sum
	cvAdd src src sum null
	cvCopy sum dst null
	as integer! dst
	
]

subImages: routine [return: [integer!]][
	cvZero sum
	cvSub src src sum null
	cvCopy sum dst null
	as integer! dst
]

addScalar: routine [return: [integer!] /local v][
	v: cvScalar 255.0 0.0 0.0 0.0
	cvAddS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
	as integer! dst
]

subScalar: routine [return: [integer!] /local v][
	v: cvScalar 0.0 0.0 255.0 0.0
	cvSubS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
	as integer! dst
]

subRScalar: routine [return: [integer!] /local v][
	v: cvScalar 0.0 255.0 0.0 0.0
	cvSubRS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
	as integer! dst
]

multiplication: routine [return: [integer!] ][
	cvMul  src src sum 0.25
	cvCopy sum dst null
	as integer! dst
]

; better with 1-channel image!
division: routine [return: [integer!]][
	cvDiv src src sum 0.10
	cvCopy sum dst null
	as integer! dst
]

scaleAdd: routine [return: [integer!]] [
	cvScaleAdd src 1.0 0.0 0.0 0.0 src sum
	cvCopy sum dst null
	as integer! dst
]

AXPY: routine [return: [integer!]] [
	cvAXPY src 1.0 1.0 1.0 0.0 src sum
	cvCopy sum dst null
	as integer! dst
]

addWeighted: routine [return: [integer!]] [
	cvAddWeighted src 0.3  src 0.3 0.3 sum
	cvCopy sum dst null
	as integer! dst
]

andOperator: routine [return: [integer!]] [
	cvAnd src clone sum null
	cvCopy sum dst null
	as integer! dst
]

andSOperator: routine [return: [integer!] /local v] [
	v: cvScalar 127.0 127.0 127.0 0.0
	cvAndS src  v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
	as integer! dst
]

orOperator: routine [return: [integer!]] [
	cvOr src sum sum null
	cvCopy sum dst null
	as integer! dst
]

orSOperator: routine [return: [integer!] /local v] [
	v: cvScalar 0.0 255.0 0.0 0.0
	cvOrS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
	as integer! dst
]

xorOperator: routine [return: [integer!] ] [
	cvXor sum src sum null
	cvCopy sum dst null
	as integer! dst
]

xorSOperator: routine [return: [integer!] /local v] [
	v: cvScalar 0.0 255.0 0.0 0.0
	cvXorS src v/v0 v/v1 v/v2 v/v3 sum null
	cvCopy sum dst null
	as integer! dst
]

notOperator: routine [return: [integer!]][
	cvNot src sum
	cvCopy sum dst null
	as integer! dst
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
		cvFlip src src -1
		cvFlip dst dst -1
		cvFlip clone clone -1
	]
	
	isLoaded
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
	canvas/image: black
	canvas/size: 0x0
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-local-file tmp	
		img1: loadImg fileName
		if img1 <> 0 [
		isFile: true
			win/text: fileName
			; update faces
			wsz: getIWidth img1
			hsz: getIHeight img1
			win/size/x: wsz + 20
			win/size/y: hsz + 90	
			canvas/size/x: wsz
			canvas/size/y: hsz
			original
			lineRequired: getImageOffset img1
			checker/data: lineRequired 
			detail/text: "Original image"
			op/selected: 1
			either lineRequired [canvas/image: makeImagebyLine img1 wsz hsz] 
				[canvas/image: makeImage img1 wsz hsz]
		]
	]
]

;interface 

view win: layout [
	title "Image Operators"
	button 50 "Load"	[loadImage]
	
	op: drop-list 100 
				data ["Original" "cvAdd" "cvSub" "cvAddS" "cvSubS"	"cvSubRS" "cvMul" "cvDiv" "cvScaleAdd" "AXPY" 
		       	"cvAddWeighted" "cvAnd" "cvAndS"	"cvOr" "cvOrS" "cvXor" "cvXorS"	"cvNot"]
		       	select 1
		       	on-change [
		       		if isFile [
		       		t1: now/time/precise
					switch op/selected[
						1 [img2: original detail/text: "Original image"]
						2 [img2: addImages detail/text: "Destination= Source + Source"]
						3 [img2: subImages detail/text: "Destination= Source - Source : 0"]
						4 [img2: addScalar detail/text: "Destination= Source + 255.0.0.0 value"]
						5 [img2: subScalar detail/text: "Destination= Source - 0.0.255.0 value"]
						6 [img2: subRScalar detail/text: "Destination= Source + 0.255.0.0 value"]
						7 [img2: multiplication detail/text: "Destination= Source * 0.25"]
						8 [img2: division detail/text: "Destination= Source / 0.10"]
						9 [img2: scaleAdd  detail/text: "Destination= Source + 1.0 1.0 1.0 0.0"]
						10 [img2: AXPY  detail/text: "Destination= Source + 1.0 1.0 1.0 0.0"]
						11 [img2: addWeighted  detail/text: "Destination= Source + 0.33 weihgt" ]
						12 [img2: andOperator detail/text: "Destination= Source AND Source" ]
						13 [img2: andSOperator detail/text: "Destination= Source AND CvScalar (127.127.127.0) Value" ]
						14 [img2: orOperator detail/text: "Destination= Source OR Source" ]
						15 [img2: orSOperator  detail/text: "Destination= Source OR CvScalar (0.255.0.0) Value"]
						16 [img2: xorOperator detail/text: "Destination= Source XOR Source"]
						17 [img2: xorSOperator  detail/text: "Destination= Source XOR CvScalar (0.255.0.0) Value"]
						18 [img2: notOperator  detail/text: "Destination= Source NOT Sum"]
					]
					either lineRequired [canvas/image: makeImagebyLine img2 wsz hsz] 
					[canvas/image: makeImage img2 wsz hsz]
					sb2/data: third now/time/precise - t1
					]
				]
	
	detail: field 210
	checker: check 50x24 "Line?"
	button 50 "Quit"	[if isFile [freeOpenCV] quit]
	return
 	sb: field 100 "Rendered in "
 	sb2: field 50 
	return
	canvas: base 512x512 black
	
]			
