Red [
	Title:   "OpenCV gaussian Red VID "
	Author:  "Francois Jouen"
	File: 	 %gaussian.red
	Needs:	 'View
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           	; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          	; basic OpenCV types and structures
	#include %../../libs/imgproc/types_c.reds       	; image processing types and structures
	#include %../../libs/highgui/cvHighgui.reds       	; highgui functions
	#include %../../libs/imgcodecs/cvImgcodecs.reds   	; basic image functions
	#include %../../libs/imgproc/cvImgproc.reds       	; OpenCV image  processing
	#include %../../libs/core/cvCore.reds             	; OpenCV core functions
	
	; variables for routines
	img: declare CvArr!
	dst: declare CvArr!
	imgStruct: declare IplImage!
	dstStruct: declare IplImage!
	wName: "OpenCV Source"
]

; global red variables to be passed as parameters to routines or red functions
fileName: ""


cvImage: make object! [
	iByteSize: 0
	iID: 0
	iNchannels: 0
	iAlpha: 0
	iDepth: 0
	iColorModel: ""
	iChannelSequence: ""
	iDataOrder: 0
	iDataOrigin: 0
	IDataAlign: 0
	iWidth:  0
	iHeight: 0
	iRoi: 0
	iMaskRoi: 0
	iIdPtr: 0
	iInfoPtr: 0
	iSize: 0
	iData: 0
	iWstep: 0
	iBM0: 0
	iBM1: 0
	iBM2: 0
	iBM3: 0
	iBMC0: 0
	iBMC1: 0
	IBMC2: 0
	IBMC3: 0
	iDataOrigin: 0
]

isFile: false
thresh: 0

makeRGB: routine[ address [integer!] return: [integer!]] [
	as integer! getByteValue address 
]

makeRedImage: function [w h channel step data return: [image!]] [
	rgb: copy #{}		 
	y: 0
	istep: w * channel  
	until [
		index: step * y
		line: copy #{}
		lineAddress: data + index
		loop istep  [append line makeRGB lineAddress  lineAddress: lineAddress + 1]
		append tail rgb line		
		y: y + 1
		y = h
	]					 
	make image! reduce [as-pair w h reverse rgb]
]

makeGaussianBlur: routine [ t [integer!]][
	cvSmooth img dst CV_GAUSSIAN t 3 0.0 0.0
]

cvLoad: routine [ name [string!] return: [logic!] /local fName isLoaded] [
	isLoaded: false
	fName: as c-string! string/rs-head name;
	img: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR ;  force a 8-bit color conversion
	dst: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR 
	imgStruct: getImageValues img ; IplImage structure
	dstStruct: getImageValues dst ; IplImage structure
	if img <> null [
		isLoaded: true  
		;cvShowImage wName img
		;cvShowImage "Blur" dst
		cvFlip img img -1
		cvFlip dst dst -1
	]
	isLoaded
]

; to get each ipl structure value
getValue: routine [ nStruct [integer!] index [integer!] return: [integer!] /local v s st] [
	case [
		nStruct = 1 [st: imgStruct] ; iplImage!
		nStruct = 2 [st: dstStruct] ; iplImage!
	]
	case [
		index = 1 [v: st/nSize]
		index = 2 [v: st/ID]
		index = 3 [v: st/nChannels]
		index = 4 [v: st/alphaChannel]
		index = 5 [v: st/depth]
		index = 6 [s: st/colorModel 
			if s/1 = #"R" [v: 1] ; RGB 
			if s/1 = #"G" [v: 3] ; GRAY
		] 
		index = 7 [s: st/channelSeq  
			if s/1 = #"R" [v: 1] ; RGBA 
			if s/1 = #"B" [v: 2] ; BGRA 
			if s/1 = #"G" [v: 3] ; GRAY
		]
		index = 8  [v: st/dataOrder]
		index = 9  [v: st/origin]
		index = 10 [v: st/align]
		index = 11 [v: st/width]
		index = 12 [v: st/height]
		index = 13 [v: as integer! st/*roi]
		index = 14 [v: as integer! st/*maskROI]
		index = 15 [v: as integer! st/*imageId]
		index = 16 [v: as integer! st/*tileInfo]
		index = 17 [v: st/imageSize]
		index = 18 [v: st/*imageData]
		index = 19 [v: st/widthStep]
		index = 20 [v: st/bm0]
		index = 21 [v: st/bm1]
		index = 22 [v: st/bm2]
		index = 23 [v: st/bm3]
		index = 24 [v: st/bc0]
		index = 25 [v: st/bc1]
		index = 26 [v: st/bc2]
		index = 27 [v: st/bc3]
		index = 28 [v: as integer! st/*imageDataOrigin]
	]
	v
]

; transform Red/S structure to Red Object!
makeImageObject: function [n return: [object!]/local obj v][
	obj: make object! cvImage
	obj/iByteSize: getValue n 1
	obj/iID: getValue n 2
	obj/iNchannels: getValue n 3
	obj/iAlpha: getValue n 4
	obj/iDepth: getValue n 5
	v: getValue n 6
	either v = 1 [obj/iColorModel: "RGBA"] [obj/iColorModel: "GRAY"]
	v: getValue n 7
	if v = 1 [obj/iChannelSequence: "RGBA"]
	if v = 2 [obj/iChannelSequence: "BGRA"]
	if v = 3 [obj/iChannelSequence: "GRAY"]
	obj/iDataOrder: getValue n 8
	obj/iDataOrigin: getValue n 9
	obj/IDataAlign: getValue n 10
	obj/iWidth:  getValue n 11
	obj/iHeight: getValue n 12
	obj/iRoi: getValue n 13
	obj/iMaskRoi: getValue n 14
	obj/iIdPtr: getValue n 15
	obj/iInfoPtr: getValue n 16
	obj/iSize: getValue n 17
	obj/iData: getValue n 18
	obj/iWstep: getValue n 19
	obj/iBM0: getValue n 20
	obj/iBM1: getValue n 21
	obj/iBM2: getValue n 22
	obj/iBM3: getValue n 23
	obj/iBMC0: getValue n 24
	obj/iBMC1: getValue n 25
	obj/iBMC2: getValue n 26
	obj/iBMC3: getValue n 27
	obj/iDataOrigin: getValue n 28
	obj
]





loadImage: does [
	thresh: 0
	canvas/image/rgb: black
	canvas/size: 0x0
	sl1/data: 0
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-local-file tmp	
		isFile: cvLoad fileName
		if isFile [
			win/text: fileName
			cvSrc: makeImageObject 1
			cvDst: makeImageObject 2
			win/size/x: cvSrc/iWidth + 20
			win/size/y: cvSrc/iHeight + 80	
			canvas/size/x: cvSrc/iWidth
			canvas/size/y: cvSrc/iheight
        	canvas/image/size: canvas/size
        	canvas/image: makeRedImage cvSrc/iWidth cvSrc/iHeight cvSrc/iNchannels cvSrc/iWstep cvSrc/iData
        	
		]
    ]
]

rimg: make image! reduce [512x512 black]
fileName: ""

btnLoad: make face! [
	type: 'button text: "Load" offset: 10x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][loadImage]
	]
]


btnQuit: make face! [
	type: 'button text: "Close" offset: 80x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][quit]
	]
]


canvas: make face! [
	type: 'base offset: 10x70 size: 512x512
	image: rimg
]

text1: make face! [
	type: 'text offset: 10x40 size: 50x20 text: "Threshold"
]

text2: make face! [
	type: 'field offset: 490x40 size: 30x20 text: "0"
]

sl1: make face! [
	type: 'slider offset: 60x40 size: 420x20
	actors: object [
		on-change: func [face [object!] event [event! none!]][
			;thresh: modulo to integer! round face/data * 255  2
			;if thresh = 1 [param1: to integer! round face/data * 255]
			thresh: to integer! round face/data * 255
			if odd? thresh [param1: to integer! round face/data * 255]
			text2/text: form to integer! round face/data * 255 
			makeGaussianBlur param1
			either [thresh <= 3]
			[canvas/image: makeRedImage cvSrc/iWidth cvSrc/iHeight cvSrc/iNchannels cvSrc/iWstep cvSrc/iData]
			[canvas/image: makeRedImage cvDst/iWidth cvDst/iHeight cvDst/iNchannels cvDst/iWstep cvDst/iData]
		]
	]
]




win: make face! [
	type: 'window text: "Red View" size: 532x610
	pane:  []
]

append win/pane btnLoad
append win/pane btnQuit
append win/pane canvas
append win/pane sl1
append win/pane text1
append win/pane text2

view win