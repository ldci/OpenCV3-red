Red [
	Title:		"OpenCV Tests: Gaussian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	element_shape: CV_SHAPE_RECT
	max_iters: 10;
	open_close_pos: max_iters + 1
	erode_dilate_pos: max_iters + 1
	;the address of variable which receives trackbar position update
	&open_close_pos: declare pointer![integer!] &open_close_pos: :open_close_pos
	&erode_dilate_pos: declare pointer![integer!] &erode_dilate_pos: :erode_dilate_pos
	
	src: declare CvArr!
	dst: declare CvArr!
	
	;callback functions for open/close trackbar
	OpenClose: func [[importMode] pos [integer!] /local n an element &element][
		n: &open_close_pos/value - max_iters
		either n > 0 [an: n] [an: 0 - n]
		element: cvCreateStructuringElementEx (an * 2) + 1 (an * 2) + 1 an an element_shape null ; 0
		&element: declare double-int-ptr!
		&element/ptr: as int-ptr! element 
		either n < 0 [cvErode src dst element 1 cvDilate dst dst element 1]
                     [cvDilate src dst element 1 cvErode dst dst element 1]
		cvReleaseStructuringElement  &element
		cvShowImage "Open/Close" dst
	]

	ErodeDilate: func [[importMode] pos [integer! ] /local n an element &element][
		n: &erode_dilate_pos/value - max_iters
		either n > 0 [an: n] [an: 0 - n]
		element: cvCreateStructuringElementEx (an * 2) + 1 (an * 2) + 1 an an element_shape null ; 0
		&element: declare double-int-ptr!
		&element/ptr: as int-ptr! element
		either n < 0 [cvErode  src dst element 1] [cvDilate src dst element 1 ]
		cvReleaseStructuringElement &element
		cvShowImage "Erode/Dilate" dst
	]		
]

morphology: routine [/local tmp tmp2][
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
	tmp2: cvCloneImage tmp ; cvCloneImage wants IplImage and not CvArr pointer
	src: as int-ptr! tmp
	dst: as int-ptr! tmp2
	tmp: null
	tmp2: null
	
	cvNamedWindow "Open/Close" CV_WINDOW_AUTOSIZE
	cvNamedWindow "Erode/Dilate" CV_WINDOW_AUTOSIZE
	cvMoveWindow "Open/Close" 30 100
	cvMoveWindow "Erode/Dilate" 630 100

	; trackbars
	cvCreateTrackbar  "Iterations" "Open/Close" &open_close_pos max_iters * 2 + 1 :OpenClose 
	cvCreateTrackbar "Iterations" "Erode/Dilate" &erode_dilate_pos max_iters * 2 + 1 :ErodeDilate

	cvShowImage "Open/Close" dst
	cvShowImage "Erode/Dilate" dst    

	cvWaitKey 0 ; until a key is pressed
]

; free memory used by OpenCV
freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage src
	releaseImage dst
]

;*************************** Main Program*********************
morphology
freeOpenCV
quit