Red [
	Title:		"OpenCV Tests: Flip Image"
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
	]
	; global variables
	
	delay: 1000
	wName: "Flip Image"
	img: declare CvArr!
	
]

flipImage: routine [][
    print ["Please wait for..." newline]
    img: as byte-ptr! cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR 
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