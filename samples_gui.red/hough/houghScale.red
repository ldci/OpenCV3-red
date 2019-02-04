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
thresh: 1
distance: 1.0
angle: PI / 180.0
param1: 5.0 ; param1 
param2: 5.0  ; param2 
minAngle: 0.0
maxAngle: PI
img1: 0
img2: 0
flagValue: 1
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
	/local tmp &storage c ptr0 ptr1 rho theta a b bn x0 y0]
[
	cvCanny src dst 50.0 200.0 3
	cvCvtColor dst colorDst CV_GRAY2BGR
	storage: cvCreateMemStorage 0
	&storage: as byte-ptr! storage
	
	
	;CV_HOUGH_MULTI_SCALE :lines/elem_size = 16
	lines: cvHoughLines2 dst &storage 2 distance 
	angle threshold param1 param2 minTheta maxTheta
	c: 0
	if lines/total > 0 [
		until [
			pline: cvGetSeqElem lines c ; pline is a byte-ptr!
			; we cast to a float32-ptr! since we have 2 C float values to get here
			ptr0: as float32-ptr! pline 
			rho: as float! ptr0/1	; negative values?
			theta: as float! ptr0/2 ; seems correct
			a: cos theta
			b: sin theta
			bn: 0.0 - b
			x0: a * rho
			y0: b * rho
			pt1/x:  as integer! (x0 + (1000.0 * bn))
			pt1/y:  as integer! (y0 + (1000.0 * a))
			pt2/x:  as integer! (x0 - (1000.0 * bn))
			pt2/y:  as integer! (y0 - (1000.0 * a))
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
		recycle/off
		img2: computeHough 2 distance angle thresh param1 param2 minAngle maxAngle
		updateRedImage img2 canvas2/image
		recycle/on
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
			win/text: copy "Hough Transform: "
			append win/text sfileName
			canvas1/image: none
			wsz: getIWidth img1
			hsz: getIHeight img1
			thresh: (min wsz hsz) / 2
			sl1/data: 50%
			fThresh/text: form thresh
			img2: computeHough 2 distance angle thresh param1 param2 minAngle maxAngle
			canvas1/image: makeRedImage img1 wsz hsz
			canvas2/image: makeRedImage img2 wsz hsz	
			isFile: true
		]
	]
]


view win: layout [
	title "Hough Transform"
	button "Load"	[loadImage]
	text "Rho Dividor" 
	fRho: field 40 [if error? try [param1: to-float face/text] [param1: 0.5]
					if param1 > 0.0 [showHough]]
	text "Theta Dividor" 
	fTheta: field	40 [if error? try [param2: to-float face/text] [param2: 0.1]
					if param2 > 0.0 [showHough]]
	text "Threshold" 70 
	sl1: slider 220 [thresh: 1 + to-integer round face/data * (min wsz hsz) 
							fThresh/text: form thresh
							showHough
						]
	fThresh: field 40 "1"
	button "Quit" 	[recycle/on Quit]
	return
	text 400 "Source Image"
	text 400 "Line Detection"
	return
	canvas1: base iSize
	canvas2: base iSize
	do [sl1/data: 0% fRho/text: form param1 fTheta/text: form param2 recycle/off]
	
]