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
	&cvimage: 0						; address of image as integer
]


; global red variables to be passed as parameters to routines or red functions
fileName: make string! ""
isFile: false
img1: 0
; for interface
wsz: 0
hsz: 0
mSizeX: system/view/screens/1/size/x
mSizeY: system/view/screens/1/size/y - 70
margins: 10x10

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red


LoadImg: routine [name [string!] return: [integer!] /local fName] [
	&cvimage: 0
	fName: as c-string! string/rs-head name
	;fName: as c-string! string/rs-head as red-string! #get 'fileName ; better?
	cvimage: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR; (force a 8-bit color conversion)
	if cvimage <> null [
		cvFlip cvimage cvimage -1
		&cvimage: as integer! cvimage  
	]
	&cvimage
]

; release all image pointers
freeOpenCV: routine [] [releaseImage cvImage]

; red functions

updateList: does [
		clear list/data	
		append list/data rejoin ["Image Header Size in byte: " form getISize img1]	
		append list/data rejoin ["Image ID: " form getIID img1]
		append list/data rejoin ["Number of Channels: " form  getIChannels img1]
		append list/data rejoin ["Image Alpha: " form getIAlpha img1]
		append list/data rejoin ["Image Depth: " form getIDepth img1]
		append list/data rejoin ["Color Model: " form getIColorModel img1]
		append list/data rejoin ["Channels Sequence: " form getIChannelSequence img1]
		append list/data rejoin ["Data Order: " form getIdataOrder img1]
		append list/data rejoin ["Data Origin: " form getIOrigin img1]
		append list/data rejoin ["Data Align: " form getIRowAlign img1]
		append list/data rejoin ["Image Width: " form getIWidth img1]
		append list/data rejoin ["Image Height: " form getIHeight img1]
		append list/data rejoin ["Image ROI: " form getIRoi img1]
		append list/data rejoin ["Image Mask ROI: " form getIRoiMask img1]
		append list/data rejoin ["Image Pointer ID: " form getImageID img1]
		append list/data rejoin ["Image Info: " form getITileInfo img1]
		append list/data rejoin ["Image Size: " form getImageSize img1]
		append list/data rejoin ["Image Data: " form getImageData img1]
		append list/data rejoin ["Image Width Step: " form getIWStep img1]
		append list/data rejoin ["Image Border Mode: "
								 form getIBorderModel img1 1
								 form getIBorderModel img1 2
								 form getIBorderModel img1 3
								 form getIBorderModel img1 4]
		append list/data rejoin ["Image Border color: "
								 form getIBorderColor img1 1
								 form getIBorderColor img1 2
		      					 form getIBorderColor img1 3
								 form getIBorderColor img1 4]
		append list/data rejoin ["Image Data Origin: " form getIDataOrigin img1]
]

loadImage: does [
	canvas/image: white
	clear list/data
	clear list/text
	isFile: false
	clear fileName
	tmp: request-file 
	if not none? tmp [		
		fileName: copy to string! to-file tmp
		img1: LoadImg fileName
		either img1 <> 0 [
			canvas/image: none
			wsz: getIWidth img1
			hsz: getIHeight img1
			list/size/y: hsz
			; if image does not fit screen, scale it
			scale: max 1 1 + max (3 * margins/x + wsz) / mSizeX (6 * margins/y + hsz) / mSizeY
			; redim window with min size
			win/size/x: 3 * margins/x + list/size/x + max 256 wsz / scale
			win/size/y: 6 * margins/y + max 256 hsz / scale
			win/text: append append append fileName " (1:" scale ")"
			canvas/size/x: wsz / scale
			canvas/size/y: hsz / scale
			checker/visible?: getImageOffset img1
			canvas/image: makeRedImage img1 wsz hsz
			updateList
			isFile: true
		] [Alert "Unsupported File"]
	]
	
]

;interface 
view win: layout [
	title "OpenCV Image Reading"
	origin margins space margins
	button 60 "Load"	[loadImage]
	button 60 "Quit"	[recycle/on if isFile [freeOpenCV] quit]
	pad 110x0
	checker: text "Reading by Line Required"
	return
	list: text-list 250x512 data []
	canvas: base 512x512 white
	do [checker/visible?: false recycle/off]
]

