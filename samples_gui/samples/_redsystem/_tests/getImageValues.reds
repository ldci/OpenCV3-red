Red/System [
	Title:		"OpenCV Tests: tests functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/include.reds ; all OpenCV  functions

;IPL_DEPTH_8U IPL_DEPTH_16U IPL_DEPTH_32F
image: as int-ptr! cvCreateImage 640 480 IPL_DEPTH_8U 3
cvSet image 255.0 255.0 0.0 0.0 null
;image: as int-ptr! cvCreateImage 640 480 IPL_DEPTH_32F 3
;cvSet image 0.0 0.0 1.0 0.0 null ;red image for 32-bit depth
img: getImageValues image ; get IplImage structure
print [img lf]

print ["Size: " img/nSize lf]
print ["ID: " img/ID lf]
print ["nChannels: " img/nChannels lf]
print ["Depth: " img/depth lf]
print ["Color Model: " img/colorModel lf]
print ["Channel Sequence: " img/channelSeq lf]
either (img/dataOrder = 0) [print ["Data order: interleaved color channels"  lf ]]
    [print ["Data order: separate color channels" lf ]]
either (img/origin = 0) [print ["Origin: top-left"  lf ]]
    [print ["Origin: bottom-left" lf ]]
print ["Row aligment: " img/align lf] 
print ["Width: " img/width lf]
print ["Height: " img/height lf]
print ["RoI: " img/*roi lf]
if img/*roi <> null [
    print [img/*roi/1 lf]
    print [img/*roi/2 lf]
    print [img/*roi/3 lf]
    print [img/*roi/4 lf]
    print [img/*roi/5 lf]
]

print ["Image Size: " img/imageSize lf]
print ["Data: " img/*imageData lf]
print ["Step: " img/widthStep lf]
print ["Border Model: " img/bm0 img/bm1 img/bm2 img/bm3 lf]
print ["Border Color: " img/bc0 img/bc1 img/bc2 img/bc3 lf]
print ["Data Origin: " img/*imageDataOrigin lf]

source: as byte-ptr! image/18
p:  allocate image/17

;source: as byte-ptr! img/*imageData
;p:  allocate img/imageSize


; copy destination source length
copy-memory p source  image/17 ; OK copy from address a series of byte

s: as c-string! p ; OK we get a string with n bytes values
; for test OK 
i: 1
loop (img/imageSize) [print [i " " as integer! s/i lf]   i: i + 1]




; test image/data
;base: img/*imageData
;loop (img/imageSize) [ print [as integer! getByteValue base lf] base: base + 1]
; tests



; to show

windowsName: "OpenCV Window [Any Key to close Window]"
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
cvShowImage windowsName image

cvWaitKey 0
