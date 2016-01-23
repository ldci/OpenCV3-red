Red [
	Title:		"OpenCV Tests: 1 Channel image Core Image Processing"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
	#include %../../libs/core/core.reds             ; OpenCV core functions

	; according to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/baboon.jpg"]
		Windows [picture: "c:\Users\palm\Pictures\baboon.jpg"]
		Linux  	[picture: "/home/fjouen/Images/baboon.jpg"]
	]
	; global variables
	img: declare CvArr!
	s0: declare CvArr!
	s1: declare CvArr!
	s2: declare CvArr!
	dst: declare CvArr!
	delay: 1000
	windowsName: "Original Image"
	
]

loadImage: routine [/local tmp] [
	print ["Please wait for..." newline]
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR ; to get structure values
	; creates 3 images for RGB planes
	s0: as byte-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1
	s1: as byte-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1
	s2: as byte-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1
	dst: as byte-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_8U 1
	img: as byte-ptr! tmp
	tmp: null
	cvSplit img s0 s1 s2 null
	cvNamedWindow windowsName CV_WINDOW_AUTOSIZE ; create window 
	cvNamedWindow "Destination" CV_WINDOW_AUTOSIZE
	cvShowImage windowsName img
	cvShowImage "Destination" dst
	cvMoveWindow windowsName  100 40
	cvMoveWindow "Destination"  620 40
	cvWaitKey delay
]

processAll: routine [] [
	print ["cvCmp with CV_CMP_EQ" lf]
	cvCmp s0 s1 dst CV_CMP_EQ
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmp with CV_CMP_GT" lf]
	cvCmp s0 s1 dst CV_CMP_GT
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmp with CV_CMP_GE" lf]
	cvCmp s0 s1 dst CV_CMP_GE
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmp with CV_CMP_LT" lf]
	cvCmp s0 s1 dst CV_CMP_LT
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmp with CV_CMP_LE" lf]
	cvCmp s0 s1 dst CV_CMP_LE
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmp with CV_CMP_NE" lf]
	cvCmp s0 s1 dst CV_CMP_NE
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmpS with CV_CMP_EQ" lf]
	cvCmpS s0 64.00 dst CV_CMP_EQ
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmpS with CV_CMP_GT" lf]
	cvCmpS s0 64.00 dst CV_CMP_GT
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmpS with CV_CMP_GE" lf]
	cvCmpS s0 64.00 dst CV_CMP_GE
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmpS with CV_CMP_LT" lf]
	cvCmpS s0 64.00 dst CV_CMP_LT
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmpS with CV_CMP_LE" lf]
	cvCmpS s0 64.00 dst CV_CMP_LE
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvCmpS with CV_CMP_NE" lf]
	cvCmpS s0 64.00 dst CV_CMP_NE
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvMin" lf]
	cvMin s0 s1 dst 
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvMax" lf]
	cvMax s0 s1 dst 
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvMinS" lf]
	cvMinS s0 128.00 dst 
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvMaxS" lf]
	cvMinS s0 64.00 dst 
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvAbsDiff" lf]
	cvAbsDiff s0 s1 dst 
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvAbsDiffS" lf]
	cvAbsDiffS s0 dst 64.00 64.00 64.00 64.00  
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvAbs" lf]
	cvAbs s1 dst 
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	; all pixels between 0.0 and 127.0 in Source image
	print ["cvInRangeS" lf]
	cvInRangeS s1  0.0 0.0 0.0 0.0 127.0 127.0 127.0 0.0 dst 
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	;dst(idx) = lower <= src(idx) < upper
	print ["cvInRange" lf]
	cvInRange s0 s1 s2 dst 
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvDiv" lf]
	cvDiv s2 s1 dst 1.0
	cvShowImage "Destination" dst
	cvWaitKey delay
	
	print ["cvPow" lf]
	cvPow s0 dst 2.0
	cvShowImage "Destination" dst
	print ["All tests done. Bye..." lf]
	cvWaitKey 2000
	
	; require 32-bit image! (CV_32F)
	;print ["cvExp" lf]
	;cvExp s0 dst 
	;cvShowImage "Destination" dst
	;cvWaitKey delay
	
	;print ["cvLog" lf]
	;cvLog s0 dst 
	;cvShowImage "Destination" dst
	;cvWaitKey 0
]

freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage img
	releaseImage dst
	releaseImage s0
	releaseImage s1
	releaseImage s2
]

;********************** MAIN PROGRAM **************************

loadImage
processAll
freeOpenCV
quit