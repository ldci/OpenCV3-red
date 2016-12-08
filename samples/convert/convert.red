Red [
	Title:		"OpenCV Tests: Image Conversion"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	
	; global variables that can be used by routines
	delay: 1000
	wName1: "Original 8-bit Image [ESC to Quit]"
	wName2: "Color -> Grayscale Image"
	wName3: "8-bit -> 32-bit Image" 
	wName4: "32-bit -> 8-bit Image"
	scale: 0.003921568627451 ; (1 / 255)
	src: declare CvArr!
	gray: declare CvArr!
	dst: declare CvArr!
	dst2: declare CvArr!
]

loadImage: routine [/local tmp] [
	print ["Please wait for..." newline]
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR ; to get structure values
	gray: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1; for grayscale
	dst: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_32F 3; to transform to 32-bit image
	dst2: as int-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 3; to go back 8-bit image
	src: as int-ptr! tmp
	tmp: null
	cvNamedWindow wName1 CV_WINDOW_AUTOSIZE 
	cvNamedWindow wName2 CV_WINDOW_AUTOSIZE
	cvNamedWindow wName3 CV_WINDOW_AUTOSIZE
	cvNamedWindow wName4 CV_WINDOW_AUTOSIZE
	cvShowImage wName1 src
]

convertImage: routine [][
	;convert to  a gray image
	print ["Converted to gray image" lf]
	cvCvtColor src gray CV_BGR2GRAY
	cvShowImage wName2 gray
	
	;convert to a 32-bit image [0.0..1.0]
	print ["Converted to 32-bit image" lf]
	cvConvertScale src dst scale 0.0
	
	;now convert 32 to 8-bit image [0..255]
	print ["Converted back to 8-bit image" lf]
	cvConvertScaleAbs dst dst2 255.0 0.0
	
	cvShowImage wName3 dst 
	cvShowImage wName4 dst2 
	
	cvMoveWindow wName1  100 40
	cvMoveWindow wName2  120 100
	cvMoveWindow wName3  140 190
	cvMoveWindow wName4  160 280
	print ["Any key to close" lf]
	cvWaitKey 0
]

freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage src
	releaseImage gray
	releaseImage dst
	releaseImage dst2
]

;***************** Main Program ***********************
loadImage
convertImage
freeOpenCV
quit