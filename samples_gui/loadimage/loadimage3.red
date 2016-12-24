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
	cvimage: declare CvArr! 		; pointer to OpenCV Image
	&cvimage: 0						; address of pointer as integer!
	wName: "OpenCV Source"
]


; global red variables to be passed as parameters to routines or red functions
fileName: ""
lineRequired: false
isFile: false
img1: 0
; for interface
wsz: 0
hsz: 0


; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red


LoadImg: routine [ name [string!] return: [integer!] /local fName isLoaded] [
	isLoaded: 0
	fName: as c-string! string/rs-head name;
	cvimage: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_ANYDEPTH OR CV_LOAD_IMAGE_ANYCOLOR
	;CV_LOAD_IMAGE_UNCHANGED; CV_LOAD_IMAGE_COLOR (force a 8-bit color conversion)
	&cvimage: as integer! cvimage
	if cvimage <> null [
		isLoaded: as integer! cvimage  
		;cvShowImage wName cvimage
		cvFlip cvimage cvimage -1
	]
	isLoaded
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
		append s to string! getIBorderModel img1 1
		append s to string! getIBorderModel img1 2
		append s to string! getIBorderModel img1 3
		append s to string! getIBorderModel img1 4
		append list/data s
		s: copy "Image Border color: "
		append s to string! getIBorderColor img1 1
		append s to string! getIBorderColor img1 2
		append s to string! getIBorderColor img1 3
		append s to string! getIBorderColor img1 4
		append list/data s		
		s: copy "Image Data Origin: "
		append s to string! getIDataOrigin img1
		append list/data s

]


loadImage: does [
	canvas/image: black
	canvas/size: 0x0
	isFile: false
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-local-file tmp	
		img1: LoadImg fileName
		if img1 <> 0 [
			win/text: fileName
			updateList
			; update faces
			wsz: getIWidth img1
			hsz: getIHeight img1
			win/size/x: wsz + 240
			win/size/y: hsz + 60	
			canvas/size/x: wsz
			canvas/size/y: hsz
			list/size/y: canvas/size/y
			lineRequired: getImageOffset img1
			checker/data: lineRequired 
			either lineRequired [canvas/image: makeImagebyLine img1 wsz hsz] 
				[canvas/image: makeImage img1 wsz hsz]
			isFile: true
		]
	]
]

;interface 
view win: layout [
	title "Image Reading"
	button 60 "Load"	[loadImage]
	button 60 "Quit"	[if isFile [freeOpenCV] quit]
	pad 80x0
	checker: check 100x24 "Line Required?"
	return
	list: text-list 210x512 data []
	canvas: base 512x512 black
]

