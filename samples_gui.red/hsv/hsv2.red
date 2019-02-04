Red [
	Title:		"OpenCV Tests: HSV"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
	Needs:	 'View
]

#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	src: declare CvArr!
	hsv: declare CvArr!
	mask: declare CvArr!
	mask2: declare CvArr!
]


; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red


; global red variables to be passed as parameters to routines or red functions
fileName: ""
isFile: false
img1: 0
wsz: 0
hsz: 0
vl: 0.0 
vh: 255.0



freeOpenCV: routine [] [
	releaseImage src
	releaseImage hsv
	releaseImage mask
	releaseImage mask2
]



loadImg: routine [ name [string!] return: [integer!] /local fName &src tmp] [
	&src: 0
	fName: as c-string! string/rs-head name;
	tmp: cvLoadImage fName CV_LOAD_IMAGE_COLOR; force 8-bit
	; to get structure values
	src: as int-ptr! tmp
	; creates HSV image
	;hsv: as int-ptr! cvCloneImage tmp
	hsv: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 3
	; creates mask: same size as original but with  only 1 channel
	mask:  as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1;
	mask2: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 3
	tmp: null
	if src <> null [
		&src: as integer! src  
		cvFlip src src -1
	]
	&src
]

makeHSV: routine [return: [integer!]][
	; conversion BGR to HSV 
	cvCvtColor src hsv CV_BGR2HSV
	as integer! hsv
]

makeMask: routine [ lv [float!] hv [float!]return: [integer!]  /local v][
	cvZero mask
	v: cvScalar 255.0 255.0 255.0 0.0
	cvAddS mask v/v0 v/v1 v/v2 v/v3 mask null ; mask is white (test for cvAddS)
	; extract values > 127.00 in H channel and between 0 and 127 in S and V channels
	;cvInRangeS hsv lv 0.0 0.0 0.0 hv 127.0 127.0 0.0 mask
	;cvInRangeS hsv lv 0.0 0.0 0.0 hv 255.0 255.0 0.0 mask
	cvInRangeS hsv lv lv lv 0.0 hv hv hv 0.0 mask
	cvMerge mask mask mask null mask2
	as integer! mask2
]




loadImage: does [
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-file tmp
		img1: loadImg fileName
		if img1 <> 0 [
			vl: 0.0 
			vh: 255.0
			sl1/data: 0% 
			sl2/data: 100%
			isFile: true
			wsz: getIWidth img1
			hsz: getIHeight img1
			canvas1/image: makeRedImage img1 wsz hsz
			canvas2/image: makeRedImage makeHSV wsz hsz
			canvas3/image: makeRedImage makeMask vl vh wsz hsz
		]
	]
]

view win: layout [
	title "HSV Mask"
	button "Load"	[loadImage]
	button "Quit" 	[if isFile [freeOpenCV] recycle/on quit]
	return
	text 256 "Source Image"
	text 256 "Source to HSV"
	text 40 "Mask"
	text 30 "Low"
	sl1: slider 140 [vl: to-float face/data * 255.0
					t1/text: form to-integer vl
					if isFile [updateRedImage makeMask vl vh canvas3/image ]]
	t1: text 35 "0"
	text 30 "High"
	sl2: slider 140 [vh: to-float face/data * 255.0
					t2/text: form to-integer vh
					if isFile [updateRedImage makeMask vl vh canvas3/image ]]
	t2: text 35  "255"
	return
	canvas1: base 256x256
	canvas2: base 256x256
	canvas3: base 512x512
	
	do [sl1/data: 0% sl2/data: 100% recycle/off]
	
	
]