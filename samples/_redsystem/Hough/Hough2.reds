Red/System [
	Title:		"OpenCV Tests: Hough2"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../../libs/include.reds ; all OpenCV  functions

; according to OS 
#switch OS [
    MacOSX  [image: "/Users/fjouen/Pictures/hough.jpg"]
    Windows [image: "c:\Users\palm\Pictures\hough.jpg"]
    Linux   [image: "/home/fjouen/Images/hough.jpg"]
]


; you can play with these variables to modifiy image processing
rho: 1.0
theta: PI / 180.0
param1: 50.0
param2: 10.0
thresh: 50
min_theta: 0.0
max_theta: PI
; end of variables you can play with

size: declare CvSize!
line: declare byte-ptr!
pt1: declare CvPoint!
pt2: declare CvPoint!
ptr: declare int-ptr!

srcWnd: "Source"
dstWnd: "Hough Transform"

; load source and create images for processing
src: cvLoadImage image CV_LOAD_IMAGE_GRAYSCALE
colorSrc: cvLoadImage image  CV_LOAD_IMAGE_ANYCOLOR
size/width: src/width
size/height: src/height
dst: cvCreateImage size/width size/height IPL_DEPTH_8U 1
colorDst: cvCreateImage size/width size/height IPL_DEPTH_8U 3 

; create windows and show source
cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE 
cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
cvMoveWindow dstWnd 500 300
cvShowImage srcWnd  as int-ptr! colorSrc

; process image with Hough transform
storage: as byte-ptr! cvCreateMemStorage 0
cvCanny as int-ptr! src as int-ptr! dst 50.0 100.0 3
cvCvtColor as int-ptr! dst as int-ptr! colorDst CV_GRAY2BGR
lines: cvHoughLines2 as int-ptr! dst storage CV_HOUGH_PROBABILISTIC rho theta thresh param1 param2 min_theta max_theta

c: 0
until [
   line: cvGetSeqElem lines c ; line is a byte-ptr!
   ptr: as int-ptr! line ; we cast to an int-ptr! since we have 4 integers to get here
   pt1/x: ptr/1
   pt1/y: ptr/2
   pt2/x: ptr/3
   pt2/y: ptr/4
   ;print [ptr " " c " " pt1/x " " pt1/y " " pt2/x " " pt2/y lf]
   cvLine as int-ptr! colorDst pt1/x pt1/y pt2/x pt2/y 0.0 0.0 255.0 0.0 2 CV_AA 0
   c: c + 1
   c = lines/total
]

; show result
cvShowImage  dstWnd  as int-ptr! colorDst
cvWaitKey 0 ; until a key is pressed


releaseImage  as int-ptr! src
releaseImage  as int-ptr! colorSrc
releaseImage  as int-ptr! dst
releaseImage  as int-ptr! colorDst

cvDestroyAllWindows 