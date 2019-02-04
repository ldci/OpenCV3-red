Red [
	Title:		"Sobel"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2019 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
	Needs:	 	'View
]


#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	kernel: 1 ; up to 31 but always ODD !!!
	src: declare CvArr!
	dst: declare CvArr!
	dst2: declare CvArr!
]

#include %../../libs/red/cvroutines.red
margins: 10x10
img1: 0
img2: 0
wsz: 0
hsz: 0
xOrder: 1
yOrder: 0
isFile: false
thresh: 1

freeOpenCV: routine [] [
	releaseImage src
	releaseImage dst
]


loadImg: routine [ name [string!] return: [integer!] /local tmp fName &src] [
	&src: 0
	fName: as c-string! string/rs-head name;
	tmp: cvLoadImage fName CV_LOAD_IMAGE_COLOR; force 8-bit
	dst: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_32F 3
	dst2: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 3
	src: as int-ptr! tmp
	tmp: null
	if src <> null [
		&src: as integer! src  
		cvFlip src src -1
	]
	&src
]

sobel: routine [xOrder [integer!] yOrder [integer!] knl [integer!] return: [integer!]] [
	cvSobel src dst xOrder yOrder knl
	; we need a 8-bit image for red 
	cvConvertScale dst dst2 1.0 0.0
	as integer! dst2	
]

showSobel: does [
	if isFile [
		img2: sobel xOrder yOrder thresh
		updateRedImage img2 canvas2/image
	]
]


loadImage: does [
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-file tmp
		img1: loadImg fileName
		if img1 <> 0 [
			sl1/data: 0%
			text2/text: "1"
			thresh: 1
			img2: sobel xOrder yOrder thresh
			win/text: to string! second split-path tmp 
			isFile: true
			wsz: getIWidth img1
			hsz: getIHeight img1
			canvas1/image: makeRedImage img1 wsz hsz
			canvas2/image: makeRedImage img2 wsz hsz
		]
	]
]

view win: layout [
	title "Sobel Filter"
	origin margins space margins
	button 60 "Load"	[loadImage]
	button 60 "Quit"	[if isFile [freeOpenCV] recycle/on quit]
	return
	text "Sobel Direction" 
	r1: radio "Vertical" 	[if r1/data [xOrder: 1 yOrder: 0] if odd? thresh [showSobel]]
	r2: radio "Horizontal"  [if r2/data [xOrder: 0 yOrder: 1] if odd? thresh [showSobel]]
	r3: radio "Both"  		[if r3/data [xOrder: 1 yOrder: 1] if odd? thresh [showSobel]]
	text "Kernel Size"
	sl1: slider 80x20	[ thresh: 1 + to-integer face/data * 6 
						  if even? thresh [thresh: thresh + 1]
						  text2/text: form thresh
						  showSobel
						]				
 	text2: field 20 "1"	
 	return
 	canvas1: base 256x256
 	canvas2: base 512x512
 	do [r1/data: true recycle/off]
]