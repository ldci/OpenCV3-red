Red [
	Title:		"Window with Events"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	; OpenCV functions we need
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures`
	#include %../../libs/core/cvCore.reds             ; OpenCV core functions
	#include %../../libs/highgui/cvHighgui.reds       ; highgui functions
	#include %../../libs/imgcodecs/cvImgcodecs.reds   ; basic image functions
	#include %../../libs/imgproc/types_c.reds       ; image processing types and structures
	; accoding to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/lena.tiff"]
		Windows [picture: "c:\Users\palm\Pictures\lena.tiff"]
		Linux   [picture: "/home/fjouen/Images/lena.tiff"]
	]
	; global variables
	windowsName: "OpenCV Window [Any Key to close Window]"
	img: declare CvArr!
	sum: declare CvScalar!
	mean: declare CvScalar!
	std: declare CvScalar!
	]


makeWindow: routine [] [
	cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
	img: as int-ptr! cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR
	
	print  [ "Height: "  cvGetDimSize img 0 lf]
	print  ["Width: " cvGetDimSize img 1 lf]
	
	; get mean and Standard Deviation values 
	cvAvgSdv img mean std null
	; get sum temporary replace cvSum 
	sum: getSum img
	Print ["Image Stats by channel (RGBA)" lf ]
	print ["Mean : " mean/v0 " " mean/v1 " "  mean/v2  " " mean/v3 lf]
	print ["Std: " std/v0 " " std/v1 " " std/v2 " " std/v3 lf]
	print ["Sum : " sum/v0 " " sum/v1 " "  sum/v2  " " sum/v3 lf]
	cvShowImage windowsName img
	cvMoveWindow windowsName 200 200
	cvWaitKey 0
]

; free memory used by OpenCV
freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage img
]


; *********** Main Progrem ************
makeWindow
freeOpenCV
quit


