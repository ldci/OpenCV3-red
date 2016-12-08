Red/System [
	Title:		"OpenCV Tests: tests functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2016 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../../libs/include.reds ; all OpenCV  functions


windowsName: "OpenCV Window [Any Key to close Window]"
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
cvMoveWindow windowsName 300 300
print ["64-bit 3 channels image" lf]; use Float!
image: as int-ptr! cvCreateImage 640 480 IPL_DEPTH_64F 3


cvSet image 0.0 1.0 0.0 0.0 null ;green image
cvShowImage windowsName image
cvWaitKey 1000
cvSet image 0.0 0.0 1.0 0.0 null ;red image
cvShowImage windowsName image
cvWaitKey 1000
cvSet image 1.0 0.0 0.0 0.0 null ;blue image
cvShowImage windowsName image

cvWaitKey 1000
cvZero image ; black image

; light center pixel 640x240+320
cvSet1D image  153920 0.25 0.50 1.0 0.0
cvSet1D image  153921 0.25 0.50 1.0 0.0
cvSet1D image  153922 0.25 0.50 1.0 0.0

cvShowImage windowsName image

; use a float ptr to get back RGBA values
pf: as [pointer! [float!]] cvPtr1D image 153920 NULL
?? pf
print ["Get value by pointer B: " pf/1 lf] ; 
print ["Get value by pointer G: " pf/2 lf]  ;
print ["Get value by pointer R: " pf/3 lf]

; 2 D tests
cvSet2D image   0 1 0.0 1.0 0.0 0.0
cvSet2D image   2 3 0.0 1.0 0.0 0.0
cvSet2D image   4 5 0.0 1.0 0.0 0.0
cvSet2D image   6 7 0.0 1.0 0.0 0.0
cvSet2D image   100 101 0.0 1.0 0.0 0.0
cvSet2D image   102 103 0.0 1.0 0.0 0.0
cvSet2D image   104 105 0.0 1.0 0.0 0.0
cvSet2D image   106 107 0.0 1.0 0.0 0.0


cvShowImage windowsName image


pf: as [pointer! [float!]] cvPtr2D image 100 101 NULL
?? pf
print ["Get value by pointer B: " pf/1 lf] ; 
print ["Get value by pointer G: " pf/2 lf]  ;
print ["Get value by pointer R: " pf/3 lf]


; test iplimage to mat conversions
header: declare CvMat!
mat1: cvGetMat image header null 0
print ["Image to Matrix" lf]
?? mat1
print["Mat Type " mat1/type lf]
print["Mat refcount " mat1/refcount lf]
print["Mat hdr " mat1/hdr_refcount lf]
print["Mat data " mat1/data lf]
print["Mat rows " mat1/rows lf]
print["Mat cols " mat1/cols lf]
Print ["Done" lf]

cvWaitKey 0
releaseImage image

