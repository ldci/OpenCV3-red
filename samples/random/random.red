Red [
	Title:		"OpenCV Tests: Random functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; for random generator

random/seed 65536

#system [
    #include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
    #include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
    #include %../../libs/imgproc/types_c.reds       ; image processing types and structures
    #include %../../libs/core/core.reds             ; OpenCV core functions
    #include %../../libs/highgui/highgui.reds       ; highgui functions
    #include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
    #include %../../libs/imgproc/imgproc.reds       ; OpenCV image  processing
    windowsName: "Random Tests"
    image: declare CvArr!
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
   releaseImage image
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
    image: as byte-ptr! cvCreateImage 512 512 IPL_DEPTH_32F 3
    cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
    rng/value: as byte! 255
    cvRandArr rng image CV_RAND_NORMAL c11 c12 c13 c14 c21 c22 c23 c24
    cvShowImage windowsName image
    cvWaitKey 2000
    cvRandArr rng image CV_RAND_UNI c11 c12 c13 c14 c21 c22 c23 c24
    cvShowImage windowsName image
    cvWaitKey 2000
    cvRandShuffle image rng 1.0
    cvShowImage windowsName image
    cvWaitkey 2000
]


render cl11 cl12 cl13 cl14 cl21 cl22 cl23 cl24
print ["Bye..." lf]
freeOpenCV
