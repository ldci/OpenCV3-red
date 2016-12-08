Red [
	Title:		"OpenCV Tests: Load Image"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	
	; global variables that can be used by routines
	delay: 1000
	wName: "Src Image"
	img: declare CvArr!
	imgStruct: declare IplImage!
]


loadImage: routine [][
    img: as int-ptr! cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR 
    imgStruct: getImageValues img ; get IplImage structure
    cvShowImage wName img
    cvMoveWindow wName  100 100
    
]
; to get each ipl structure value
getValue: routine [index [integer!] return: [integer!] /local v s] [
	imgStruct: getImageValues img ; IplImage structure
	case [
		index = 1 [v: imgStruct/nSize]
		index = 2 [v: imgStruct/ID]
		index = 3 [v: imgStruct/nChannels]
		index = 4 [v: imgStruct/alphaChannel]
		index = 5 [v: imgStruct/depth]
		index = 6 [s: imgStruct/colorModel 
			if s/1 = #"R" [v: 1] ; RGB 
			if s/1 = #"G" [v: 3] ; GRAY
		] 
		index = 7 [s: imgStruct/channelSeq  
			if s/1 = #"R" [v: 1] ; RGBA 
			if s/1 = #"B" [v: 2] ; BGRA 
			if s/1 = #"G" [v: 3] ; GRAY
		
		] 
		index = 8  [v: imgStruct/dataOrder]
		index = 9  [v: imgStruct/origin]
		index = 10 [v: imgStruct/align]
		index = 11 [v: imgStruct/width]
		index = 12 [v: imgStruct/height]
		index = 13 [v: as integer! imgStruct/*roi]
		index = 14 [v: as integer! imgStruct/*maskROI]
		index = 15 [v: as integer! imgStruct/*imageId]
		index = 16 [v: as integer! imgStruct/*tileInfo]
		index = 17 [v: imgStruct/imageSize]
		index = 18 [v: as integer! imgStruct/*imageData]
		index = 19 [v: imgStruct/widthStep]
		index = 19 [v: imgStruct/bm0]
		index = 20 [v: imgStruct/bm1]
		index = 21 [v: imgStruct/bm2]
		index = 22 [v: imgStruct/bm3]
		index = 23 [v: imgStruct/bc0]
		index = 24 [v: imgStruct/bc1]
		index = 25 [v: imgStruct/bc2]
		index = 26 [v: imgStruct/bc3]
		index = 27 [v: as integer! imgStruct/*imageDataOrigin]
	]
	v
]

freeOpenCV: routine [] [
	cvWaitKey 0
	cvDestroyAllWindows
	releaseImage img	
]


;********************** MAIN PROGRAM **************************

loadImage
print [getValue 1 lf]
print [getValue 11 getValue 12 getValue 17 lf]
print [getValue 6 getValue 7  lf]
freeOpenCV
quit