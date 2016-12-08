Red [
	Title:   "OpenCV loadimage Red VID "
	Author:  "Francois Jouen"
	File: 	 %loadimage3.red
	Needs:	 'View
]


; import required OpenCV libraries
#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	; variables that can be used inside routines
	cvimage: declare CvArr! 				; pointer to OpenCV Image
	&cvimage: 0						; address of pointer as integer!
	wName: "OpenCV Source"
]


; global red variables to be passed as parameters to routines or red functions
fileName: ""
isFile: false
lineRequired: false
img1: 0
; for interface
rimg: make image! reduce [512x512 black]
wsz: 0
hsz: 0


; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

; red/s routines we need


cvLoad: routine [ name [string!] return: [integer!] /local fName isLoaded] [
	isLoaded: 0
	fName: as c-string! string/rs-head name;
	cvimage: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYCOLOR ;  force a 8-bit color conversion
	&cvimage: as integer! cvimage
	if cvimage <> null [
		isLoaded: as integer! cvimage  
		;cvShowImage wName cvimage
		cvFlip cvimage cvimage -1
	]
	isLoaded
]



getImageOffset: routine [return: [logic!]/local sz][
	sz: (getIChannels &cvimage) * (getIWidth &cvimage) * (getIHeight &cvimage)
	either (sz = getIImageSize &cvimage) [false] [true]
]


;Get data at line n  according to line number parameter
getOCVLine: routine [ln [integer!] return: [binary!] /local step idx laddr] [
	step: getStep &cvImage				; line size
	idx: (getIWStep &cvImage) * ln			; line index
	laddr: (getIImageData &cvImage) + idx				; line address
	getBinaryValue laddr step			; binary values	
]

getOCVData: routine [return: [binary!]] [
	getBinaryValue getIImageData &cvImage getIImageSize &cvImage
]

; red functions
makeRedImagebyPtr: function [w h return: [image!]] [		 
	rgb: getOCVData				 
	make image! reduce [as-pair w h reverse rgb]
]

makeRedImagebyLine: function [w h return: [image!]] [
	y: 0
	rgb: copy #{}
	until [
		append rgb getOCVLine y
		y: y + 1
		y = h
	]
	make image! reduce [as-pair w h reverse rgb]	
]

; release all image pointers
freeOpenCV: routine [] [
	releaseImage cvImage
]

; red functions
updateList: does [
		clear list/data
		clear list/text
		s: copy  "Image Size in byte: "	
		append s to string! getISize img1	
		append list/data s
		s: copy "Image ID: "
		append s to string! getIID img1
		append list/data s
		s: copy "Number of Channels: "
		append s to string! getIChannels img1
		append list/data s 
		s: copy "Image Alpha: "
		append s to string! getIAlpha img1
		append list/data s
		s: copy  "Image Depth: "
		append s to string! getIDepth img1
		append list/data s
		s: copy "Color Model: "
		append s to string! getIColorModel img1
		append list/data s
		s: copy "Channels Sequence: "
		append s to string! getIChannelSequence img1
		append list/data s
		s: copy "Data Order: "
		append s to string! getIdataOrder img1
		append list/data s
		s: copy "Data Origin: "
		append s to string! getIOrigin img1
		append list/data s
		s: copy "Data Align: "
		append s to string! getIRowAlign img1
		append list/data s
		s: copy "Image Width: "
		append s to string! getIWidth img1
		append list/data s
		s: copy "Image Height: "
		append s to string! getIHeight img1
		append list/data s
		s: copy "Image/ROI: "
		append s to string! getIRoi img1
		append list/data s
		s: copy "Image/Mask ROI: "
		append s to string! getIRoiMask img1
		append list/data s
		s: copy "Image Pointer ID: "
		append s to string! getIImageID img1
		append list/data s
		s: copy "Image/info: "
		append s to string! getITileInfo img1
		append list/data s
		s: copy "Image Size: "
		append s to string! getIImageSize img1
		append list/data s
		s: copy "Image Data: "
		append s to string! getIImageData img1
		append list/data s
		s: copy "Image Width Step: "
		append s to string! getIWStep img1
		append list/data s
		s: copy "Image Border Mode: "
		append s to string! GetIBorderModel img1 1
		append s to string! GetIBorderModel img1 2
		append s to string! GetIBorderModel img1 3
		append s to string! GetIBorderModel img1 4
		append list/data s
		s: copy "Image Border color : "
		append s to string! GetIBorderColor img1 1
		append s to string! GetIBorderColor img1 2
		append s to string! GetIBorderColor img1 3
		append s to string! GetIBorderColor img1 4
		append list/data s		
		s: copy "Image Data Origin: "
		append s to string! getIDataOrigin img1
		append list/data s

]


loadImage: does [
	canvas/image/rgb: black
	canvas/size: 0x0
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-local-file tmp	
		img1: cvLoad fileName
		if img1 <> 0 [
			win/text: fileName
			updateList
			;rimg: load tmp
			;canvas/image: rimg
			; update faces
			wsz: getIWidth img1
			hsz: getIHeight img1
			win/size/x: wsz + 225
			win/size/y: hsz + 80	
			canvas/size/x: wsz
			canvas/size/y: hsz
			canvas/image/size: canvas/size
			list/size/y: canvas/size/y
			lineRequired: getImageOffset
			checker/data: lineRequired 
			either lineRequired [canvas/image: makeRedImagebyLine wsz hsz] 
				[canvas/image: makeRedImagebyPtr wsz hsz]
		]
        
	]
]

;interface 

btnLoad: make face! [
	type: 'button text: "Load" offset: 10x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][loadImage]
	]
]


btnQuit: make face! [
	type: 'button text: "Close" offset: 80x10 size: 60x20
	actors: object [
			on-click: func [face [object!] event [event!]][freeOpenCV quit]
	]
]



list: make face! [
	type: 'text-list offset: 10x40 size: 205x512 data: []
]


canvas: make face! [
	type: 'base offset: 210x40 size: 512x512
	image: rimg
]


checker: make face![
	type: 'check text: "Line Required?" offset: 210x10 size: 100x24
	data: false
]



win: make face! [
	type: 'window text: "Red View" size: 747x580
	pane:  []
]



append win/pane btnLoad
append win/pane btnQuit
append win/pane list
append win/pane canvas
append win/pane checker

view win