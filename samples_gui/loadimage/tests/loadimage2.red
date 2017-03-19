Red [
	Title:   "OpenCV loadimage Red VID "
	Author:  "Francois Jouen"
	File: 	 %loadimage2.red
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
	imgStruct: declare IplImage!
	wName: "OpenCV Source"
]


; global red variables to be passed as parameters to routines or red functions
fileName: ""
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

isFile: false

cvLoad: routine [ name [string!] return: [logic!] /local fName isLoaded] [
	isLoaded: false
          fName: as c-string! string/rs-head name;
	img: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR ;  force a 8-bit color conversion 
	if img <> null [
		isLoaded: true  
		;cvShowImage wName img
		cvFlip img img -1
	]
	isLoaded
]

; to get each ipl structure value
getValue: routine [index [integer!] return: [integer!] /local v s] [
	imgStruct: getImageValues img ; IplImage structure
	case [
		index = 1 [v: imgStruct/nSize]
		index = 2 [v: imgStruct/ID]
		index = 3 [v: imgStruct/nChannels]
		index = 4 [v: imgStruct/alphaChannel]
		index = 5 [v: imgStruct/depth]
		index = 6 [s: imgStruct/colorModel 
			if s/1 = #"R" [v: 1] ; RGB 
			if s/1 = #"G" [v: 3] ; GRAY
		] 
		index = 7 [s: imgStruct/channelSeq  
			if s/1 = #"R" [v: 1] ; RGBA 
			if s/1 = #"B" [v: 2] ; BGRA 
			if s/1 = #"G" [v: 3] ; GRAY
		
		] 
		index = 8  [v: imgStruct/dataOrder]
		index = 9  [v: imgStruct/origin]
		index = 10 [v: imgStruct/align]
		index = 11 [v: imgStruct/width]
		index = 12 [v: imgStruct/height]
		index = 13 [v: as integer! imgStruct/*roi]
		index = 14 [v: as integer! imgStruct/*maskROI]
		index = 15 [v: as integer! imgStruct/*imageId]
		index = 16 [v: as integer! imgStruct/*tileInfo]
		index = 17 [v: imgStruct/imageSize]
		index = 18 [v: imgStruct/*imageData]
		index = 19 [v: imgStruct/widthStep]
		index = 20 [v: imgStruct/bm0]
		index = 21 [v: imgStruct/bm1]
		index = 22 [v: imgStruct/bm2]
		index = 23 [v: imgStruct/bm3]
		index = 24 [v: imgStruct/bc0]
		index = 25 [v: imgStruct/bc1]
		index = 26 [v: imgStruct/bc2]
		index = 27 [v: imgStruct/bc3]
		index = 28 [v: as integer! imgStruct/*imageDataOrigin]
	]
	v
]


getImageValues: does [
	iByteSize: getValue 1
	iID: getValue 2
	iNchannels: getValue 3
	iAlpha: getValue 4
	iDepth: getValue 5
	v: getValue 6
	either v = 1 [iColorModel: "RGBA"] [iColorModel: "GRAY"]
	v: getValue 7
	if v = 1 [iChannelSequence: "RGBA"]
	if v = 2 [iChannelSequence: "BGRA"]
	if v = 3 [iChannelSequence: "GRAY"]
	iDataOrder: getValue 8
	iDataOrigin: getValue 9
	IDataAlign: getValue 10
	iWidth:  getValue 11
	iHeight: getValue 12
	iRoi: getValue 13
	iMaskRoi: getValue 14
	iIdPtr: getValue 15
	iInfoPtr: getValue 16
	iSize: getValue 17
	iData: getValue 18
	iWstep: getValue 19
	iBM0: getValue 20
	iBM1: getValue 21
	iBM2: getValue 22
	iBM3: getValue 23
	iBMC0: getValue 24
	iBMC1: getValue 25
	iBMC2: getValue 26
	iBMC3: getValue 27
	iDataOrigin: getValue 28
]


updateList: does [
		clear list/data
		clear list/text
		s: copy  "Image Size in byte: "	
		append s to string! iByteSize	
		append list/data s
		s: copy "Image ID: "
		append s to string! iID
		append list/data s
		s: copy "Number of Channels: "
		append s to string! iNchannels
		append list/data s
		s: copy "Image Alpha: "
		append s to string! iAlpha
		append list/data s
		s: copy  "Image Depth: "
		append s to string! iDepth
		append list/data s
		s: copy "Color Model: "
		append s to string! iColorModel
		append list/data s
		s: copy "Channels Sequence: "
		append s to string! iChannelSequence
		append list/data s
		s: copy "Data Order: "
		append s to string! iDataOrder
		append list/data s
		s: copy "Data Origin: "
		append s to string! iDataOrigin
		append list/data s
		s: copy "Data Align: "
		append s to string! IDataAlign
		append list/data s
		s: copy "Image Width: "
		append s to string! iWidth
		append list/data s
		s: copy "Image Height: "
		append s to string! iHeight
		append list/data s
		s: copy "Image ROI: "
		append s to string! iRoi
		append list/data s
		s: copy "Image Mask ROI: "
		append s to string! iMaskRoi
		append list/data s
		s: copy "Image Pointer ID: "
		append s to string! iIdPtr
		append list/data s
		s: copy "Image info: "
		append s to string! iInfoPtr
		append list/data s
		s: copy "Image Size: "
		append s to string! iSize
		append list/data s
		s: copy "Image Data: "
		append s to string! iData
		append list/data s
		s: copy "Image Width Step: "
		append s to string! iWstep
		append list/data s
		s: copy "Image Border Mode: "
		append s to string! iBM0
		append s to string! iBM1
		append s to string! iBM2
		append s to string! iBM3 
		append list/data s
		s: copy "Image Border color : "
		append s to string! iBMC0
		append s to string! iBMC1
		append s to string! iBMC2
		append s to string! iBMC3
		append list/data s		
		s: copy "Image Data Origin: "
		append s to string! iDataOrigin
		append list/data s

]

makeRGB: routine[ address [integer!] return: [integer!]] [
	as integer! getByteValue address 
]

rimg: make image! reduce [512x512 black]
fileName: ""

loadImage: does [
	canvas/image/rgb: black
	canvas/size: 0x0
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-local-file tmp	
		isFile: cvLoad fileName
		if isFile [
			win/text: fileName
			getImageValues	
			updateList
			;rimg: load tmp
			;canvas/image: rimg
			; update faces
        	win/size/x: iWidth + 225
			win/size/y: iHeight + 80	
			canvas/size/x: iWidth
			canvas/size/y: iheight
        	canvas/image/size: canvas/size
        	list/size/y: canvas/size/y
        	; get image values to make a Red image
			rgb: copy #{}		 
			y: 0
			istep: iWidth * iNchannels  
			until [
				index: iWstep * y
				line: copy #{}
				lineAddress: iData + index
				loop istep  [append line makeRGB lineAddress  lineAddress: lineAddress + 1]
				append tail rgb line
				y: y + 1
				y = iHeight
			]					 
			canvas/image: make image! reduce [as-pair iWidth iHeight  reverse rgb]
        ]
        
    ]
]

; for interface

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


list: make face! [
	type: 'text-list offset: 10x40 size: 205x512 data: []
]


canvas: make face! [
	type: 'base offset: 210x40 size: 512x512
	image: rimg
]


win: make face! [
	type: 'window text: "Red View" size: 747x580
	pane:  []
]

; create red/Gui
append win/pane btnLoad
append win/pane btnQuit
append win/pane list
append win/pane canvas
view win