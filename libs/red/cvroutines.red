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





;old version
_getBinaryValue: routine [dataAddress [integer!] dataSize [integer!] return: [binary!] /local src p] [
"Get RBG values from OpenCV Image"
	src: as byte-ptr! dataAddress
	p:  allocate dataSize
	copy-memory p src dataSize
	stack/set-last as red-value! binary/load p dataSize
	binary/load p dataSize
	
]

; get memory as binary! string
; Thanks to Qtxie for the optimization!
getBinaryValue: routine [dataAddress [integer!] dataSize [integer!] return: [binary!]] [
	as red-binary! stack/set-last as red-value! binary/load as byte-ptr! dataAddress dataSize
]




;  some routines to get information about OpenCV image


; for image calculation when a line offset is required
getIStep: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/3 * tmp/11
]

getISize: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/1
]

getIID: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/2
]


getIChannels: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/3
]

getIAlpha: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/4
]

getIDepth: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/5
]


getIColorModel: routine [img [integer!] return: [string!] /local b str tmp] [
	tmp: as int-ptr! img
	b: as byte! tmp/6
	if (b = #"R") [str: "RGBA"]
	if (b = #"G") [str: "GRAY"]
	as red-string! stack/set-last as red-value! string/load str length? str UTF-8 
]

getIChannelSequence: routine [img [integer!] return: [string!] /local b str tmp] [
	tmp: as int-ptr! img
	b: as byte! tmp/7
	if (b = #"B") [str: "BGRA"]
	if (b = #"R") [str: "RGBA"] 
	if (b = #"G") [str: "GRAY"]
	as red-string! stack/set-last as red-value! string/load str length? str UTF-8
]

getIdataOrder: routine [img [integer!] return: [string!] /local b str tmp] [
	tmp: as int-ptr! img
	b: tmp/8
	if (b = 0) [str: "interleaved color channels"]
	if (b = 1) [str: "separate color channels"]
	as red-string! stack/set-last as red-value! string/load str length? str UTF-8
]

getIOrigin: routine [img [integer!] return: [string!] /local b str tmp] [
	tmp: as int-ptr! img
	b: tmp/9
	if (b = 0) [str: "top-left"]
	if (b = 1) [str: "bottom-left"]
	as red-string! stack/set-last as red-value! string/load str length? str UTF-8
]

getIRowAlign: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/10
]

getIWidth: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/11
]

getIHeight: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/12
]


getIRoi: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/13
]

getIRoiMask: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/14
]

getIImageID: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/15
]

getITileInfo: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/16
]

getIImageSize: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/17
]
getIImageData: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/18
]

getIWStep: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/19
]

getIBorderModel: routine [img [integer!] idx [integer!] return: [integer!] /local v tmp] [
	tmp: as int-ptr! img
	if (idx = 1) [v: tmp/20]
	if (idx = 2) [v: tmp/21]
	if (idx = 3) [v: tmp/22]
	if (idx = 4) [v: tmp/23]
	v
]


getIBorderColor: routine [img [integer!] idx [integer!] return: [integer!] /local v tmp] [
	tmp: as int-ptr! img
	if (idx = 1) [v: tmp/24]
	if (idx = 2) [v: tmp/25]
	if (idx = 3) [v: tmp/26]
	if (idx = 4) [v: tmp/27]
	v
]


getIDataOrigin: routine [img [integer!] return: [integer!] /local tmp] [
	tmp: as int-ptr! img
	tmp/28
]


; useful to know memory aligment of OpenCV image
; if false -> getLine line/line
; if true -> getImageData

getImageOffset: routine [&src [integer!] return: [logic!]/local sz][
	sz: (getIChannels &src) * (getIWidth &src) * (getIHeight &src)
	either (sz = getIImageSize &src) [false] [true]
]


; From OpenCV to Red Image

; get image memory content line by line
getLine: routine [ img [integer!] ln [integer!] return: [binary!] /local step idx laddr] [
	step: getIStep img				; line size
	idx: (getIWStep img) * ln			; line index
	laddr: (getIImageData img) + idx				; line address
	getBinaryValue laddr step			; binary values	
]

; get all image memory content by pointer
getImageData: routine [img [integer!] return: [binary!] /local tmp] [
 	getBinaryValue getIImageData img getIImageSize img
]


; Red Functions calling routines to create Red Image from OpenCV Image

makeImage: function [ im [integer!] w [integer!] h [integer!] return: [image!]] [		 
	rgb: getImageData im
	make image! reduce [as-pair w h reverse rgb] ;reverse BGRA to RGBA for red
]


makeImagebyLine: function [im [integer!] w [integer!] h [integer!] return: [image!]] [
	y: 0
	rgb: copy #{}
	until [
		append rgb getLine im y
		y: y + 1
		y = h
	]
	make image! reduce [as-pair w h reverse rgb]	
]

makeRedImage: function [im [integer!] w [integer!] h [integer!] return: [image!]] [
	lineRequired: getImageOffset im
	either lineRequired [makeImagebyLine im w h] [makeImage im w h]
]