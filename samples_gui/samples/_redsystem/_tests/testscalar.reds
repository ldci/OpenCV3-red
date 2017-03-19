Red/System [
	Title:		"OpenCV Tests: tests functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../../libs/include.reds ; all OpenCV  functions


image: as int-ptr! cvCreateImage 512 512 32 3
imageAddress: as integer! image
; get image values
print [ image/1 lf]
print [ image/2 lf]
print [ image/3 lf]
print [ image/4 lf]
print [ image/5 lf]
print [ as byte! image/6 lf]
print [ as byte! image/7 lf]
print [ image/8 lf]
print [ image/9 lf]
print [ image/10 lf]
print [ image/11 lf]
print [ image/12 lf]
print [ image/13 lf]
print [ image/14 lf]
print [ image/15 lf]
print [ image/16 lf]
print [ image/18 lf]
print [ image/19 lf]
print [ image/20 lf]
print [ image/21 lf]
print [ image/22 lf]
print [ image/23 lf]
print [ image/24 lf]
print [ image/25 lf]
print [ image/26 lf]
print [ image/27 lf]
print [ image/28 lf]

; rows and cols
print ["Get Size " lf]
print  [ "Height: " cvGetDimSize image 0 lf]
print  ["Width: " cvGetDimSize image 1 lf]

;print [cvCountNonZero image lf]

;cvAvg image null

; to show

windowsName: "OpenCV Window [Any Key to close Window]"
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
cvShowImage windowsName image
cvWaitKey 0
