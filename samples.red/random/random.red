Red [
	Title:		"OpenCV Tests: Random functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; for random generator

random/seed 65536

#system [
    ; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
    windowsName: "Random Tests"
    img: declare CvArr!
    rng: declare byte-ptr! ; just a pointer for random generator 
]

; we use 32-bit image [0.0..1.0]
; we need 2 scalar for colors
cl11: make float! random 1.0
cl12: make float! random 1.0
cl13: make float! random 1.0
cl14: make float! random 1.0
cl21: make float! random 1.0
cl22: make float! random 1.0
cl23: make float! random 1.0
cl24: make float! random 1.0

;free mem
freeOpenCV: routine [] [
   cvDestroyAllWindows
   releaseImage img
]


render: routine [
	c11 [float!]
	c12 [float!]
	c13 [float!]
	c14 [float!]
	c21 [float!]
	c22 [float!]
	c23 [float!]
	c24 [float!]

] [
    img: as int-ptr! cvCreateImage 512 512 IPL_DEPTH_32F 3
    cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
    rng/value: as byte! 255
    cvRandArr rng img CV_RAND_NORMAL c11 c12 c13 c14 c21 c22 c23 c24
    cvShowImage windowsName img
    cvWaitKey 2000
    cvRandArr rng img CV_RAND_UNI c11 c12 c13 c14 c21 c22 c23 c24
    cvShowImage windowsName img
    cvWaitKey 2000
    cvRandShuffle img rng 1.0
    cvShowImage windowsName img
    cvWaitkey 2000
]


render cl11 cl12 cl13 cl14 cl21 cl22 cl23 cl24
print ["Bye..." lf]
freeOpenCV
