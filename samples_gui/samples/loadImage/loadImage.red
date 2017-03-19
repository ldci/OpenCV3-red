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
			if s/1 = #"R" [v: 1]
			if s/1 = #"B" [v: 2]
			if s/1 = #"G" [v: 3]
		] 
		index = 7 [s: imgStruct/channelSeq 
			;if s = "RGBA" [v: 1]
			;if s = "BGRA" [v: 2]
			;if s = "GRAY" [v: 3]
			
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
		index = 20 [v: imgStruct/bm0]
		index = 21 [v: imgStruct/bm1]
		index = 22 [v: imgStruct/bm2]
		index = 23 [v: imgStruct/bm3]
		index = 24 [v: imgStruct/bc0]
		index = 25 [v: imgStruct/bc1]
		index = 26 [v: imgStruct/bc2]
		index = 27 [v: imgStruct/bc3]
		index = 28 [v: as integer! imgStruct/*imageDataOrigin]
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
print ["Image Header Size: " getValue 1]
print ["Image ID: " getValue 2]
print ["Number of Channels: " getValue 3]
print ["Alpha Channel: " getValue 4] 
print ["Image Depth: " getValue 5]
if getValue 6 = 1 [cm: "RGBA"]
if getValue 6 = 2 [cm: "BGRA"]
print ["Image Color Model: " cm]
if getValue 7 = 1 [co: "RGBA"]
if getValue 7 = 2 [co: "BGRA"]
print ["Image Color Order: " co]
either getValue 8 = 0 [dto: "interleaved color channels" ] [dto: "separate color channels"]
print ["Data Order: " dto]
either getValue 9 = 0 [dtor: "top-left origin" ] [dtor: "bottom-left origin"] 
print ["Origin: " dtor]
print ["Alignment of image rows: " getValue 10]
print ["Image width: "getValue 11]
print ["Image height: "getValue 12]
print ["Image ROI: " getValue 13]
print ["Mask ROI: " getValue 14]
print ["Image ID: " getValue 15]
print ["IplTileInfo: " getValue 16]
print ["Image Size: " getValue 17]
print ["Image Data Address: " getValue 18]
print ["Image Width Step: " getValue 19]
print ["Border Mode: " getValue 20 getValue 21 getValue 22 getValue 23]
print ["Border Color: " getValue 24 getValue 25 getValue 26 getValue 27]
print ["Image Data Origin: " getValue 28]

freeOpenCV
quit