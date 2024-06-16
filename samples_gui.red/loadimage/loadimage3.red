Red [
	Title:   "OpenCV loadimage Red VID "
	Author:  "Francois Jouen"
	File: 	 %loadimage3.red
	Needs:	 'View
]

; import required OpenCV libraries
#system-global [
	#include %../../libs/include.reds ; all OpenCV  functions
]

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

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

loadImg: routine [
	name 		[string!] 
	return: 	[integer!] 
	/local  
	fName		[c-string!] 
	&cvImage 	[integer!]	 
	cvImage		[int-ptr!]
][
	&cvImage: 0
	fName: as c-string! string/rs-head name
	cvImage: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR; (force a 8-bit color conversion)
	if cvImage <> null [
		cvFlip cvImage cvImage -1
		&cvImage: as integer! cvImage  
	]
	&cvImage
]


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
	unless none? tmp [		
		fileName: to-string tmp
		img1: LoadImg fileName	;--call Red routine with Red/S code
		either img1 <> 0 [
			canvas/image: none
			wsz: getIWidth img1
			hsz: getIHeight img1
			list/size/y: hsz
			; if image does not fit screen, scale it
			scale: max 1 1 + max (3 * margins/x + wsz) / mSizeX (6 * margins/y + hsz) / mSizeY
			; redim window with min size
			win/size/x: 3 * margins/x + list/size/x + max 256 wsz / to-integer scale
			win/size/y: 6 * margins/y + max 256 hsz / to-integer scale
			win/text: append append append fileName " (1:" to-integer scale ")"
			canvas/size/x: wsz / to-integer scale
			canvas/size/y: hsz / to-integer scale
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
	button 60 "Quit"	[recycle/on quit]
	pad 110x0
	checker: text "Reading by Line Required"
	return
	list: text-list 250x512 data []
	canvas: base 512x512 white
	do [checker/visible?: false recycle/off]
]

