Red [
	Title:   "OpenCV routines"
	Author:  "Francois Jouen"
	File: 	 %cvroutines.red
]



; for individual pixel or pointer reading

getByteValue: routine [
	address [integer!] 
	return: [integer!] 
	/local p
][
    p: as [pointer! [byte!]] address
    as integer! p/value
]

getIntegerValue: routine [address [integer!] return: [integer!] /local p][
    p: as [pointer! [integer!]] address
    p/value
]

getFloat32Value: routine [address [integer!] return: [float!] /local p][
    p: as [pointer! [float32!]] address
    as float! p/value
]

getFloatValue: routine [address [integer!] return: [float!] /local p][
    p: as [pointer! [float!]] address
    p/value
]

;  some routines to get information about OpenCV image

; sizeof(IplImage) should be 112 bytes
getISize: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/1
]

; version (=0)
getIID: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/2
]

; Most of OpenCV functions support 1,2,3 or 4 channels
getIChannels: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/3
]
; alpha: Ignored by OpenCV
getIAlpha: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/4
]

;image depth in bits
getIDepth: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/5
]

; color model 
getIColorModel: routine [img [integer!] return: [string!] /local b str src] [
	src: as int-ptr! img
	b: as byte! src/6
	if (b = #"R") [str: "RGBA"]
	if (b = #"B") [str: "BGRA"]
	if (b = #"G") [str: "GRAY"]
	as red-string! stack/set-last as red-value! string/load str length? str UTF-8 
]

; color order
getIChannelSequence: routine [img [integer!] return: [string!] /local b str src] [
	src: as int-ptr! img
	b: as byte! src/7
	if (b = #"B") [str: "BGRA"]
	if (b = #"R") [str: "RGBA"] 
	if (b = #"G") [str: "GRAY"]
	as red-string! stack/set-last as red-value! string/load str length? str UTF-8
]

;0 - interleaved color channels, 1 - separate color channels.
getIdataOrder: routine [img [integer!] return: [string!] /local b str src] [
	src: as int-ptr! img
	b: src/8
	if (b = 0) [str: "interleaved color channels"]
	if (b = 1) [str: "separate color channels"]
	as red-string! stack/set-last as red-value! string/load str length? str UTF-8
]

;0 - top-left origin, 1 - bottom-left origin (Windows bitmaps style). 
getIOrigin: routine [img [integer!] return: [string!] /local b str src] [
	src: as int-ptr! img
	b: src/9
	if (b = 0) [str: "top-left"]
	if (b = 1) [str: "bottom-left"]
	as red-string! stack/set-last as red-value! string/load str length? str UTF-8
]

;Alignment of image rows (4 or 8).OpenCV ignores it and uses widthStep instead.
getIRowAlign: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/10
]
; image x size
getIWidth: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/11
]

; image y size
getIHeight: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/12
]

; IplROI!pointer Image ROI. If NULL, the whole image is selected 
getIRoi: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/13
]

;Must be NULL.
getIRoiMask: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/14
]

;Must be NULL.
getImageID: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/15
]
;Must be NULL.
getITileInfo: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/16
]

;Image data size in bytes
getImageSize: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/17
]

;Pointer to aligned image data.
getImageData: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/18
]

;Size of aligned image row in bytes.
getIWStep: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/19
]

;Ignored by OpenCV.
getIBorderModel: routine [img [integer!] idx [integer!] return: [integer!] /local v src] [
	src: as int-ptr! img
	if (idx = 1) [v: src/20]
	if (idx = 2) [v: src/21]
	if (idx = 3) [v: src/22]
	if (idx = 4) [v: src/23]
	v
]

;Ignored by OpenCV.
getIBorderColor: routine [img [integer!] idx [integer!] return: [integer!] /local v src] [
	src: as int-ptr! img
	if (idx = 1) [v: src/24]
	if (idx = 2) [v: src/25]
	if (idx = 3) [v: src/26]
	if (idx = 4) [v: src/27]
	v
]

;Pointer to very origin of image data
getIDataOrigin: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/28
]

; for image calculation when a line offset is required
getIStep: routine [img [integer!] return: [integer!] /local src] [
	src: as int-ptr! img
	src/3 * src/11
]



; useful to know memory aligment of OpenCV image
; if false -> getLine line/line
; if true -> getImageData

getImageOffset: routine [img [integer!] return: [logic!]/local sz][
	sz: (getIChannels img) * (getIWidth img) * (getIHeight img)
	either (sz = getImageSize img) [false] [true]
]

; get memory as binary! string

;old  and test version

__getBinaryValue: routine [dataAddress [integer!] dataSize [integer!] return: [binary!] 
	/local src p bdata] [
	src: as byte-ptr! dataAddress
	p:  allocate dataSize
	copy-memory p src dataSize
	bdata: binary/load p dataSize
	stack/set-last as red-value! bdata
	free p
	src: null
	stack/reset
	bdata
]

; Thanks to Qtxie for the optimization!

getBinaryValue: routine [dataAddress [integer!] dataSize [integer!] return: [binary!]] [
	as red-binary! stack/set-last as red-value! binary/load as byte-ptr! dataAddress dataSize
]

clearBinaryValue: routine [dataAddress [integer!] dataSize [integer!]] [
	binary/rs-clear as red-binary! stack/set-last as red-value! binary/load as byte-ptr! dataAddress dataSize
]


; From OpenCV to Red Image

; get image memory content line by line
getLine: routine [ img [integer!] ln [integer!] return: [binary!] /local step idx laddr] [
	step: getIStep img					; line size
	idx: (getIWStep img) * ln			; line index
	laddr: (getImageData img) + idx		; line address
	getBinaryValue laddr step			; binary values	
]

; get all image memory content by pointer
getAllImageData: routine [img [integer!] return: [binary!]] [
	getBinaryValue getImageData img getImageSize img
]

; clear memory content
clearAllImageData: routine [img [integer!]] [
	clearBinaryValue getIDataOrigin img getImageSize img
]


; Red Functions calling routines to create or update Red Image from OpenCV Image



;reverse BGRA to RGBA for red images

makeImage: function [ img [integer!] w [integer!] h [integer!] return: [image!]] [	
	make image! reduce [as-pair w h reverse getAllImageData img] 
]

makeImagebyLine: function [img [integer!] w [integer!] h [integer!] return: [image!]] [
	y: 0
	rgb: copy #{}
	until [
			append rgb getLine img y
			y: y + 1
		y = h
	]
	make image! reduce [as-pair w h reverse rgb]	
]


; test
getRBGValues: function [img [integer!] return: [binary!]] [
	rgb: copy #{}
	either getImageOffset img [
		y: 0
		h: getIHeight img
		until [
			append rgb getLine img y
			y: y + 1
		y = h
		]
	] [rgb: getBinaryValue getImageData img getImageSize img]
	reverse rgb
]


{since red 0.6.4 GC must be off before calling makeRedImage and updateRedImage functions
and reactivated after}

makeRedImage: function [img [integer!] w [integer!] h [integer!] return: [image!]] [	
	either getImageOffset img [makeImagebyLine img w h] [makeImage img w h]
]

updateImage: function [ src [integer!] dst [image!]] [
	dst/rgb: reverse getAllImageData src
]

updateImagebyLine: function [src [integer!] dst [image!]] [
	y: 0
	h: dst/size/y
	rgb: copy #{}
	until [
			append rgb getLine src y
			y: y + 1
		y = h
	]
 	dst/rgb: reverse rgb
]

updateRedImage: function [src [integer!] dst [image!]] [	
	either getImageOffset src [updateImagebyLine src dst] [updateImage src dst]
]