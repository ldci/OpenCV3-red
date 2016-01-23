Red [
	Title:		"OpenCV Tests: Image Space Color"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/imgproc/types_c.reds       ; image processing types and structures
	#include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
	#include %../../libs/imgproc/imgproc.reds	    ; image processing functions
	#include %../../libs/core/core.reds             ; OpenCV core functions

	; according to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/lena.tiff"]
		Windows [picture: "c:\Users\palm\Pictures\lena.tiff"]
		Linux  	[picture: "/home/fjouen/Images/lena.tiff"]
	]
	; global variables
	delay: 1000
	wName1: "Original Image"
	wName2: "Modified Image"
	scale: 0.003921568627451 ; (1 / 255)
	bit8: true ; 8 or 32-bit images
	src: declare CvArr!
	dst: declare CvArr!
]

loadImages: routine [/local tmp] [
	print ["Playing with cvCvtColor" lf]
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR ; to get structure values
	src: as byte-ptr! cvCreateImage tmp/width tmp/height IPL_DEPTH_32F 3
	dst: as byte-ptr! cvCreateImage tmp/width tmp/height tmp/depth tmp/nChannels 
	cvConvertScale as byte-ptr! tmp src scale 0.0
	if bit8 [src: as byte-ptr! tmp] 
	tmp: null
	cvNamedWindow wName1 CV_WINDOW_AUTOSIZE
	cvNamedWindow wName2 CV_WINDOW_AUTOSIZE
	cvZero dst
	cvShowImage wName1 src
	cvShowImage wName2 dst 
	cvMoveWindow wName1  50 40
	cvMoveWindow wName2  600 40
	cvWaitKey delay
]

processImages: routine [][
	;RGB<=>CIE XYZ.Rec 709 with D65 white point (CV_BGR2XYZ, CV_RGB2XYZ, CV_XYZ2BGR, CV_XYZ2RGB): 
	print ["RGB<=>CIE XYZ.Rec 709 with D65 white point" lf]
	cvCvtColor src dst CV_BGR2XYZ 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_RGB2XYZ
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_RGB2XYZ 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_XYZ2BGR
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_XYZ2RGB
	cvShowImage wName2 dst 
	cvWaitKey delay

	; RGB<=>YCrCb JPEG (a.k.a. YCC) CV_BGR2YCrCb, CV_RGB2YCrCb, CV_YCrCb2BGR, CV_YCrCb2RGB

	print ["RGB<=>YCrCb JPEG (a.k.a. YCC)" lf]
	cvCvtColor src dst CV_BGR2YCrCb 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_RGB2YCrCb
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_YCrCb2BGR 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_YCrCb2RGB
	cvShowImage wName2 dst 
	cvWaitKey delay
	
	;RGB<=>HSV (CV_BGR2HSV, CV_RGB2HSV, CV_HSV2BGR, CV_HSV2RGB) 
	print ["RGB<=>HSV" LF]
	cvCvtColor src dst CV_BGR2HSV 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_RGB2HSV
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_HSV2BGR 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_HSV2RGB
	cvShowImage wName2 dst 
	cvWaitKey delay
	
	;RGB<=>HLS (CV_BGR2HLS, CV_RGB2HLS, CV_HLS2BGR, CV_HLS2RGB) 
	print ["RGB<=>HLS" lf]
	cvCvtColor src dst CV_BGR2HLS 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_RGB2HLS
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_HLS2BGR 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_HLS2RGB
	cvShowImage wName2 dst 
	cvWaitKey delay
	
	;RGB<=>CIE L*a*b* (CV_BGR2Lab, CV_RGB2Lab, CV_Lab2BGR, CV_Lab2RGB) 
	print ["RGB<=>CIE L*a*b*" lf]
	cvCvtColor src dst CV_BGR2Lab 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_RGB2Lab
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_Lab2BGR 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_Lab2RGB
	cvShowImage wName2 dst 
	cvWaitKey delay

	;RGB<=>CIE L*u*v* (CV_BGR2Luv, CV_RGB2Luv, CV_Luv2BGR, CV_Luv2RGB) 
	print ["RGB<=>CIE L*u*v*" lf]
	cvCvtColor src dst CV_BGR2Luv 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_RGB2Luv
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_Luv2BGR 
	cvShowImage wName2 dst 
	cvWaitKey delay
	cvCvtColor src dst CV_Luv2RGB
	cvShowImage wName2 dst 
	cvWaitKey delay * 2
	print ["bye..." lf]
]

freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage src
	releaseImage dst
]


;*************** Main Program **********************
loadImages
processImages
freeOpenCV