Red [
	Title:		"OpenCV Tests: Sort"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2019 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
	Needs:	 	'View
]

{CV_SORT_EVERY_ROW: 0
CV_SORT_EVERY_COLUMN: 1
CV_SORT_ASCENDING: 0
CV_SORT_DESCENDING: 16}


#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	tmp: declare IplImage!
	src: declare CvArr!
	dst: declare CvArr!
	r: declare CvArr!
	g: declare CvArr!
	b: declare CvArr!
	dst1: declare CvArr!
	dst2: declare CvArr!
	dst3: declare CvArr!
]


; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red


; global red variables to be passed as parameters to routines or red functions
fileName: ""
isFile: false
imgSize: 400x400
img1: 0
img2: 0
flag: 1


loadImg: routine [ name [string!] return: [integer!] /local fName &src tmp] [
	&src: 0
	fName: as c-string! string/rs-head name;
	tmp: cvLoadImage fName CV_LOAD_IMAGE_COLOR; force 8-bit
	src: as int-ptr! tmp
	dst: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 3
	r: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	g: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	b: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	dst1: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	dst2: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	dst3: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth 1
	tmp: null
	if src <> null [
		&src: as integer! src  
		cvFlip src src -1
	]
	&src
]


sortImage: routine [flag [integer!] return: [integer!]] [
	cvSplit src r g b null
	cvSort  r dst1 null flag
	cvSort  g dst2 null flag
	cvSort  b dst3 null flag
	cvMerge dst1 dst2 dst3 null dst
	as integer! dst
]


freeOpenCV: routine [] [
	releaseImage src
	releaseImage dst
	releaseImage r
	releaseImage g
	releaseImage b
	releaseImage dst1
	releaseImage dst2
	releaseImage dst3
]


loadImage: does [
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-file tmp
		img1: loadImg fileName
		img2: sortImage flag
		if img1 <> 0 [
			vl: 0.0 
			isFile: true
			wsz: getIWidth img1
			hsz: getIHeight img1
			canvas1/image: makeRedImage img1 wsz hsz
			canvas2/image: makeRedImage img2 wsz hsz
		]
	]
]

showSort: does [
	if isFile [
		img2: sortImage flag
		updateRedImage img2 canvas2/image 
	]
]


view win: layout [
	title "Image Sort"
	button "Load"		[loadImage ]
	cb: check "Descending Sort" 
	r1: radio "Columns" [flag: 1 if cb/data [flag: flag + 16] showSort]
	r2: radio "Lines"   [flag: 0 if cb/data [flag: flag + 16] showSort]
	button "Quit" 		[if isFile [freeOpenCV] recycle/on quit]
	return 
	canvas1: base imgSize
	canvas2: base imgSize
	do [r1/data: true recycle/off]
]