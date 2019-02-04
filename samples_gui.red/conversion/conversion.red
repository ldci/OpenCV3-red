Red [
	Title:		"OpenCV Tests: Image Conversion"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2019 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
	Needs:	 'View
]

#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	iscale: 0.003921568627451 ; (1 / 255)
	src: declare CvArr!
	gray: declare CvArr!
	gray2: declare CvArr!
	dst: declare CvArr!
	dst2: declare CvArr!
]


; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red


; global red variables to be passed as parameters to routines or red functions
fileName: ""
isFile: false
img1: 0
wsz: 0
hsz: 0



freeOpenCV: routine [] [
	releaseImage src
	releaseImage gray
	releaseImage dst
	releaseImage dst2
]



loadImg: routine [ name [string!] return: [integer!] /local fName &src tmp] [
	&src: 0
	fName: as c-string! string/rs-head name;
	tmp: cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR ; to get structure values 
	gray: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1; for grayscale
	gray2: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 3
	dst: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_32F 3; to transform to 32-bit image
	dst2: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 3; to go back 8-bit image
	src: as int-ptr! tmp
	tmp: null
	if src <> null [
		&src: as integer! src  
		cvFlip src src -1
		cvFlip dst dst -1
	]
	&src
]

grayScale: routine [return: [integer!]][
	;convert to  a gray image
	cvCvtColor src gray CV_BGR2GRAY
	; red cann't process 1 channel image , we have to merge
	cvMerge gray gray gray null gray2 
	as integer! gray2	
]


to32bit: routine [return: [integer!]][
	;convert to a 32-bit image [0.0..1.0]
	cvConvertScale src dst iscale 0.0 ; conversion is OK
	; red cann't process 32-bit image, so go back to 8-bit
	cvConvertScaleAbs dst dst2 255.0 0.0
	as integer! dst2	
]

to8bit: routine [return: [integer!]][
	;now convert 32 to 8-bit image [0..255]
	cvConvertScaleAbs dst dst2 255.0 0.0
	as integer! dst2	
]


loadImage: does [
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-file tmp
		img1: loadImg fileName
		if img1 <> 0 [
			wsz: getIWidth img1
			hsz: getIHeight img1
			canvas1/image: makeRedImage img1 wsz hsz
			canvas2/image: makeRedImage grayScale wsz hsz
			canvas3/image: makeRedImage to32bit wsz hsz
			canvas4/image: makeRedImage to8bit wsz hsz
		]
	]
]



view win: layout [
	title "Image Conversion"
	button "Load"	[loadImage]
	button "Quit" 	[freeOpenCV quit]
	return
	text 256 "Source Image"
	text 256 "Source to grayscale"
	text 256 "Source to 32-bit Image"
	text 256 "32-bit to 8-bit Image"
	return
	canvas1: base 256x256
	canvas2: base 256x256
	canvas3: base 256x256
	canvas4: base 256x256
	
]