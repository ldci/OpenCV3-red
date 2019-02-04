Red [
	Title:		"OpenCV Tests: Flip"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2019 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
	Needs:	 'View
]

#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	img: declare CvArr!
]

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red


fileName: ""
isFile: false
img1: 0
imgSize: 512x512
flag: -1

freeOpenCV: routine [] [
	releaseImage img	
]



loadImg: routine [ name [string!] return: [integer!] /local fName &img] [
	&img: 0
	fName: as c-string! string/rs-head name;
	img: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR; force 8-bit
	if img <> null [
		&img: as integer! img  
		cvFlip img img -1
	]
	&img
]

flip: routine [flag [integer!] return: [integer!]][
	cvFlip img img flag
	as integer! img 
]

showFlip: does [
	if isFile [
		img1: flip flag
		updateRedImage img1 canvas/image 
	]
]

loadImage: does [
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-file tmp
		img1: loadImg fileName
		if img1 <> 0 [
			isFile: true
			wsz: getIWidth img1
			hsz: getIHeight img1
			canvas/image: makeRedImage img1 wsz hsz
		]
	]
]

view win: layout [
	title "Image Flip"
	button "Load"		[loadImage]
	r1: radio "X-axis" 	[flag:  0 showFlip]
	r2: radio "Y-axis"  [flag:  1 showFlip]
	r3: radio "Both" 	[flag: -1 showFlip]
	pad 100x0
	button "Quit" 		[if isFile [freeOpenCV] recycle/on quit]
	return 
	canvas: base imgSize
	do [r1/data: true recycle/off]
]