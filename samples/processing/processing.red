Red [
	Title:		"OpenCV Tests: Core Image Processing"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/highgui/cvHighgui.reds       ; highgui functions
	#include %../../libs/imgcodecs/cvImgcodecs.reds   ; basic image functions
	#include %../../libs/core/cvCore.reds             ; OpenCV core functions

	; according to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/lena.tiff"]
		Windows [picture: "c:\Users\palm\Pictures\lena.tiff"]
		Linux   [picture: "/home/fjouen/Images/lena.tiff"]
	]
	
	;global variables
	
	delay: 1000
	wName1: "Image 1 "
	wName2: "Image 1 Clone "
	wName3: "Result"
	src: declare CvArr!
	clone: declare CvArr!
	sum: declare CvArr!
	
]

; playing with some basic operators 

loadImages: routine [/local tmp] [
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR ; to get structure values
	clone: as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth tmp/nChannels 
	sum:  as int-ptr! cvCreateImage tmp/width tmp/height tmp/depth tmp/nChannels
	src: as int-ptr! tmp
	tmp: null
	cvCopy src clone null
	cvNamedWindow wName1 CV_WINDOW_AUTOSIZE 
	;cvNamedWindow wName2 CV_WINDOW_AUTOSIZE
	cvNamedWindow wName3 CV_WINDOW_AUTOSIZE
	cvShowImage wName1 src 
	;cvShowImage wName2 clone 
	cvShowImage wName3 sum 
	cvMoveWindow wName1  100 40
	cvMoveWindow wName3  640 40
	print ["Please wait! " lf]
	cvWaitKey delay
]

addImages: routine [][
	print ["cvAdd" lf]
	cvAdd src clone sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]


subImages: routine [][
	print ["cvSub" lf]
	cvSub sum clone sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

addScalar: routine [/local v][
	print ["cvAddS" lf]
	v: cvScalar 255.0 0.0 0.0 0.0
	cvAddS src v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]


subScalar: routine [/local v][
	print ["cvSubS" lf]
	v: cvScalar 255.0 255.0 0.0 0.0
	cvSubS src v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

subRScalar: routine [/local v][
	print ["cvSubRS" lf]
	v: cvScalar 255.0 0.0 0.0 0.0
	cvSubRS src v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

multiplication: routine [][
	print ["cvMul" lf]
	cvMul  src clone sum 0.25
	cvShowImage wName3 sum
	cvWaitKey delay
]
; better with 1-channel image!
division: routine [][
	print ["cvDiv" lf]
	cvDiv clone src sum 0.25
	cvShowImage wName3 sum
	cvWaitKey delay
]

scaleAdd: routine [] [
	print ["cvScaleAdd" lf]
	cvScaleAdd src 1.0 0.0 0.0 0.0 clone sum
	cvShowImage wName3 sum
	cvWaitKey delay
]

AXPY: routine [] [
	print ["AXPY" lf]
	cvAXPY src 1.0 1.0 1.0 0.0 clone sum
	cvShowImage wName3 sum
	cvWaitKey delay
]


addWeighted: routine [] [
	print ["cvAddWeighted" lf]
	cvAddWeighted src 1.0 / 3.0  clone 1.0 / 3.0 0.0 sum
	cvShowImage wName3 sum
	cvWaitKey delay
]

andOperator: routine [] [
	print ["cvAnd" lf]
	cvAnd src sum sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

andSOperator: routine [/local v] [
	print ["cvAndS" lf]
	v: cvScalar 127.0 127.0 127.0 0.0
	cvAndS clone  v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

orOperator: routine [] [
	print ["cvOr" lf]
	cvOr src sum sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

orSOperator: routine [/local v] [
	print ["cvOrS" lf]
	v: cvScalar 0.0 255.0 0.0 0.0
	cvOrS clone v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

xorOperator: routine [] [
	print ["cvXor" lf]
	cvXor sum clone sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

xorSOperator: routine [/local v] [
	print ["cvXorS" lf]
	v: cvScalar 0.0 255.0 0.0 0.0
	cvXorS clone v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

notOperator: routine [][
	print ["cvNot" lf]
	cvNot src sum
	cvShowImage wName3 sum
	cvWaitKey delay
]




dotProduct: routine [][
	print ["cvDotProduct : "  cvDotProduct src clone  lf]
	print ["All tests done. Bye..." lf]
	cvWaitKey 2000
	
]



freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage src
	releaseImage clone
	releaseImage sum
]


;************ MAIN PROGRAM **************
loadImages
addImages
subImages
addScalar
subScalar
subRScalar
multiplication
division
scaleAdd
AXPY
addWeighted
andOperator
andSOperator
orOperator
orSOperator
xorOperator
xorSOperator
notOperator
dotProduct
freeOpenCV
Quit

