Red [
	Title:		"OpenCV Tests: Hough Transform"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2019 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
	Needs:	 'View
]
; import required OpenCV libraries

#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	pt1: declare CvPoint!
	pt2: declare CvPoint!
	src: declare CvArr!
	dst: declare CvArr!
	colorSrc: declare CvArr!
	colorDst: declare CvArr!
	storage: declare CvMemStorage!
	lines: declare CvSeq!
	pline: declare byte-ptr!
	fName: ""				; a c-string for filename storage
]

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red



iSize: 400x400
thresh: 0
distance: 1.0
angle: PI / 180.0
param1: 50.0  ; param1 ~ line length - for probabilistic
param2: 10.0  ; param2 ~ line gap - for probabilistic
minAngle: 0.0
maxAngle: PI
img1: 0
img2: 0
isFile: false
fileName: copy ""
wsz: hsz: 100

loadSrc: routine [name [string!] return: [integer!] /local tmp &src ] [
	src: null
	&src: 0
	fName: as c-string! string/rs-head name;
	tmp: cvLoadImage fName CV_LOAD_IMAGE_GRAYSCALE
	src: as int-ptr! tmp
	tmp: cvLoadImage fName CV_LOAD_IMAGE_COLOR
	colorSrc: as int-ptr! tmp
	dst: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1
	colorDst: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 3
	src: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR ;  force a 8-bit color conversion
	tmp: null
	if colorSrc <> null [
		cvFlip colorSrc colorSrc -1
		&src: as integer! colorSrc
	]
	&src
]

createDst: routine [return: [integer!]] [
	cvFlip colorDst colorDst -1
	as integer! colorDst   
]

computeHough: routine [
	method 		[integer!]
	distance 	[float!]
	angle 		[float!]
	threshold	[integer!] 
	param1		[float!]
	param2		[float!]
	minTheta	[float!]
	maxTheta	[float!]
	return:		[integer!]
	/local tmp &storage c ptr]
[
	cvCanny src dst 50.0 200.0 3
	cvCvtColor dst colorDst CV_GRAY2BGR
	storage: cvCreateMemStorage 0
	&storage: as byte-ptr! storage
	lines: cvHoughLines2 dst &storage method distance 
		   angle threshold param1 param2 minTheta maxTheta
	
	c: 0
	if lines/total > 0 [
		until [
			pline: cvGetSeqElem lines c ; pline is a byte-ptr!
			; we cast to an int-ptr! since we have 4 integers to get here
			ptr: as int-ptr! pline 
			pt1/x: ptr/1
			pt1/y: ptr/2
			pt2/x: ptr/3
			pt2/y: ptr/4
			cvLine colorDst pt1/x pt1/y pt2/x pt2/y 0.0 0.0 255.0 0.0 2 CV_AA 0
			c: c + 1
			(c = lines/total) or (c = 100)
		]
	]
	cvFlip colorDst colorDst -1
	as integer! colorDst   
]

showHough: does [
	if isFile [
		img2: computeHough 1 distance angle thresh param1 param2 minAngle maxAngle
		updateRedImage img2 canvas2/image
	]
]


loadImage: does [
	tmp: request-file 
	if not none? tmp [
		isFile: true
		fileName: to string! to-file tmp
		sfileName: to string! second split-path tmp
		img1: loadSrc fileName
		if img1 <> 0 [
			win/text: copy "Probabilistic Hough Transform: "
			append win/text sfileName
			canvas1/image: none
			wsz: getIWidth img1
			hsz: getIHeight img1
			thresh: (min wsz hsz) / 2
			sl1/data: 50%
			fThresh/text: form thresh
			img2: computeHough 1 distance angle thresh param1 param2 minAngle maxAngle	
			canvas1/image: makeRedImage img1 wsz hsz
			canvas2/image: makeRedImage img2 wsz hsz	
			isFile: true
		]
	]
]


view win: layout [
	title "Probabilistic Hough Transform"
	button "Load"	[loadImage]
	
	text "Rho" 30
	fRho: field 40 [if error? try [distance: to-float face/text] [distance: 1.0]
		 if distance > 0.0 [showHough]
	] "1.0"
	
	text "Theta" 40	 
	fTheta: field 40 [
		if error? try [angle: to-float face/text] [angle: pi / 180]
		 if angle > 0.0 [showHough]
	]
	
	text "Line Length" 70 
	fLength: field 40 [
		 if error? try [param1: to-float face/text] [param1: 50.0]
		 if param1 > 0.0 [showHough]]
		 "50.0"
	text "Line Gap" 60 
	
	fGap: field 40  "10.0" [if error? try [param2: to-float face/text] [param2: 10.0]
		 if param2 > 0.0 [showHough]]
		 
	text "Threshold" 70 
	sl1: slider 100 [thresh: 1 + to-integer round face/data * (min wsz hsz) 
							fThresh/text: form thresh
							showHough
						]
	fThresh: field 40 "1"
	button 50 "Quit" 	[recycle/on Quit]
	return
	text 400 "Source Image"
	text 400 "Line Detection"
	return
	canvas1: base iSize
	canvas2: base iSize
	do [sl1/data: 0% fTheta/text: form angle recycle/off]
	
]