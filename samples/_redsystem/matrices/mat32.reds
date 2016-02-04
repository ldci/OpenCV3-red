Red/System [
	Title:		"OpenCV Tests: tests functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../../libs/red/types_r.reds          ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds         ; basic OpenCV types and structures
#include %../../../libs/imgproc/types_c.reds      ; image processing types and structures
#include %../../../libs/core/core.reds      	  ; core functions
#include %../../../libs/highgui/highgui.reds      ; highgui functions


print ["32-bit 1 channel image" lf]

image: as byte-ptr! cvCreateImage 640 480 IPL_DEPTH_32F 1
cvZero image


;print [getSizeW  image " " getSizeH image lf] ; OK Correct 
size: getSize  image
print ["getSize Function: " size/width " " size/height lf ]


print ["cvGetDimSize Function Test " lf ]
; rows and cols
print  ["Rows: " cvGetDimSize image 0 lf]
print  ["Cols: " cvGetDimSize image 1 lf]

p: declare pointer! [integer!]
;print ["Pointer " p  lf ]
?? p
dims: cvGetDims image p ; ok returns 2 for image and mat p is an array of integer

print ["Test cvGetDims " lf ]
print ["Dimensions: " dims lf]
;print ["Pointer " p  lf ]
print ["valeur 1 Rows: " p/1 lf]
print ["valeur 2 Cols: " p/2 lf] 


; test set pixel value
; light center pixel 640x240+320
cvSet1D image 153920 0.95 0.0 0.0 0.0


;cvGetReal inly for 1 channel matrix
print ["Get value by cvGetReal: "cvGetReal1D image 153920 lf]

;test ptr access
; image 32-bit -> float32 0..1
pf: as [pointer! [float32!]] cvPtr1D image 153920 NULL
?? pf
print ["Get value by pointer: " pf/1 lf] ; OK 



; to show

windowsName: "OpenCV Window [Any Key to close Window]"
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
cvShowImage windowsName image
cvWaitKey 0
releaseImage image