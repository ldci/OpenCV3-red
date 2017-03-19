Red [
	Title:		"OpenCV Tests: tests functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; opencv Red/S interface
#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	cvimage: declare CvArr!
	&cvimage: 0
	img: declare IplImage!
	windowsName: "OpenCV Window [Any Key to close Window]"
]

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

; red routines accessing #system variables
createImage: routine [return: [integer!]][
	cvimage: as int-ptr! cvCreateImage 640 480 IPL_DEPTH_8U 3
	&cvimage: as integer! cvimage
	cvSet cvimage 255.0 0.0 127.0 0.0 null
	cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
	cvShowImage windowsName cvimage
	&cvimage
]


; if we need to work line/line
;Get data at line n  according to line number parameter
getOCVLine: routine [ln [integer!] return: [binary!] /local step idx laddr] [
	step: getIStep &cvImage				; line size
	idx: (getIWStep &cvImage) * ln			; line index
	laddr: cvImage/18 + idx				; line address
	getBinaryValue laddr step			; binary values	
]



; If we can use all image memory pointer

getOCVData: routine [return: [binary!]] [
	getBinaryValue cvImage/18 cvImage/17
]



waitFor: routine [] [
	cvWaitKey 0
]



; red functions
getImageInfo: does [
	print ["Size: " getISize img1]
	print ["ID: " getIID img1]
	print ["Number of Channels: " getIChannels img1]
	print ["Depth: "  getIDepth img1]
	print ["Alpha Channel: "  getIAlpha img1]
	print ["Color Model: " getIColorModel img1]
	print ["Channel Sequence: " getIChannelSequence img1]
	print ["Data Order: " getIdataOrder img1]
	print ["Data Origin: " getIOrigin img1]
	print ["Row Alignment: " getIRowAlign img1]
	print ["Image Width: " getIWidth img1]
	print ["Image Height: " getIHeight img1]
	print ["Image/ROI: " getIRoi img1]		; pointer
	print ["Image ROI/Mask: " getIRoiMask img1]	; pointer
	print ["Image/image ID: " getIImageID img1]	; pointer
	print ["Image/tileInfo: " getITileInfo img1]	; pointer
	print ["Image Size: " getIImageSize img1]
	print ["Image/Data: " getIImageData img1]	; pointer
	print ["Width Step: " getIWStep img1]
	print ["Border Model: " GetIBorderModel img1 1 GetIBorderModel img1 2 GetIBorderModel img1 3 GetIBorderModel img1 4]
	print ["Border Color: " GetIBorderColor img1 1 GetIBorderColor img1 2 GetIBorderColor img1 3 GetIBorderColor img1 4]
	print ["Image/Origin: "getIDataOrigin img1]	;pointer
]

; red code

img1: createImage
h: getIHeight img1
; ok to get all image
;rgb: getOCVData

;for line by line decoding when offset in image
y: 0
rgb: copy #{}
until [
	append rgb getOCVLine y
	y: y + 1
	y = h 
]

print [ rgb lf]
getImageinfo
waitFor
