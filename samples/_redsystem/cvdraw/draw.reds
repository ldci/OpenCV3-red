Red/System [
	Title:		"OpenCV Tests: Drawing"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../../libs/imgproc/types_c.reds       ; image processing types and structures
#include %../../../libs/highgui/highgui.reds       ; highgui functions
#include %../../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
#include %../../../libs/imgproc/imgproc.reds       ; OpenCV image  processing
#include %../../../libs/core/core.reds             ; OpenCV core functions

#include %random/randomf.reds                   ; Arnold van Hofwegen's random
#include %random/user.reds                      ; Boleslav Brezovsky's tools
#define NUMBER 100
#define DELAY 5

print [CV_GRAPH_ITEM_VISITED_FLAG lf]


wndname: "OpenCV drawing and text output functions"
lineType: CV_AA; // change it to 8 to see non-antialiased graphics
i: 1 
width: 1000 
height: 700

width3: width * 3
height3: height * 3;
thickness: 0

pt1: declare CvPoint!
pt2: declare CvPoint!

sz: declare CvSize!
color: declare CvScalar!
angle: 0.0
radius: 0
font: declare CvFont!

cvInitFont font CV_FONT_HERSHEY_SIMPLEX 2.0 2.0 0.0 1 CV_AA
_font: 0
vs: 0.0
hs: 0.0

text_size: declare CvSize!
ymin: 0


image: cvCreateImage width height IPL_DEPTH_32F 3
cvNamedWindow wndname CV_WINDOW_AUTOSIZE
cvZero as byte-ptr! image

cvGetTextSize "Any key to start" font text_size as int-ptr! ymin
pt1/x: (width - text_size/width) / 2
pt1/y: (height + text_size/height) / 2

cvPutText as byte-ptr! image "Any key to start" pt1/x pt1/y font 0.0 56.0 -56.0 0.0
cvShowImage wndname as byte-ptr! image
cvwaitKey 0

cvZero as byte-ptr! image

cvGetTextSize "Drawing Lines" font text_size as int-ptr! ymin
cvPutText as byte-ptr! image "Drawing Lines" pt1/x pt1/y font 0.0 56.0 -56.0 0.0

random-seed 310952

i: 1

print ["Drawing Lines" lf]
; draw lines
until [
    pt1/x: random / 655360
    pt1/y: random / 655360
    pt2/x: random / 655360
    pt2/y: random / 655360
    color/v0: 255.00
    color/v1: 255.0 + i; int-to-float random / 655360
    color/v2: 127.0 + i; int-to-float random / 655360
    color/v3: 0.0
    thickness: random / 65536000
    print [ (random / 3276800) newline]
    cvLine as byte-ptr! image pt1/x pt1/y pt2/x pt2/y color/v0 color/v1 color/v2 color/v3 thickness lineType 0
    cvShowImage wndname as byte-ptr! image
    cvwaitKey delay
    i: i + 1
    i = (number + 1)
]

cvwaitKey 0




