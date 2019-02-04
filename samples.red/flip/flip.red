Red [
	Title:		"OpenCV Tests: Flip Image"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	delay: 1000
	wName: "Flip Image"
	img: declare CvArr!
	
]

flipImage: routine [][
    print ["Please wait for..." newline]
    img: as int-ptr! cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR 
    cvShowImage wName img
    cvMoveWindow wName  100 100
    cvWaitKey delay
    cvFlip img img 0
    cvShowImage wName img
    cvWaitKey delay
    cvFlip img img 1
    cvShowImage wName img
    cvWaitKey delay
    cvFlip img img -1
    cvShowImage wName img
    cvWaitKey delay
    cvFlip img img 1
    cvShowImage wName img
    cvWaitKey delay
    cvFlip img img 1
    cvShowImage wName img
    cvWaitKey 2000
    print ["Bye ..." newline]
]


freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage img	
]


;********************** MAIN PROGRAM **************************

flipImage
freeOpenCV
quit