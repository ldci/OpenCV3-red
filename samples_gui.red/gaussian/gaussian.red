Red [
	Title:   "OpenCV gaussian Red VID "
	Author:  "Francois Jouen"
	File: 	 %gaussian.red
	Needs:	 'View
]

; import required OpenCV libraries
#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	src: declare CvArr!	; pointer to Source image
	dst: declare CvArr!	; pointer to Destination image
	&src: 0			; address of image as integer
	&dst: 0			; address of image as integer
]





; global red variables to be passed as parameters to routines
fileName: ""
thresh: 0
rimg: make image! reduce [512x512 black]
img1: 0
img2: 0
wsz: 0
hsz: 0
mSizeX: system/view/screens/1/size/x
mSizeY: system/view/screens/1/size/y - 60
margins: 10x10

lineRequired: false
isFile: false
param1: 1

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

; red/S routines we need

makeGaussianBlur: routine [ t [integer!]][
	cvSmooth src dst CV_GAUSSIAN t 3 0.0 0.0
]

;img1
loadSrc: routine [ name [string!] return: [integer!] /local fName isLoaded] [
	isLoaded: 0
	fName: as c-string! string/rs-head name;
	src: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR ;  force a 8-bit color conversion
	if src <> null [
		&src: as integer! src
		isLoaded: as integer! src
		cvFlip src src -1
	]
	isLoaded
]

;img2
createDst: routine [return: [integer!]] [
	dst: as int-ptr! cvCreateImage getIWidth &src getIHeight &src IPL_DEPTH_8U 3
	;cvFlip dst dst -1
	&dst: as integer! dst   
	&dst
]




; release all image pointers
freeOpenCV: routine [] [
	releaseImage src
	releaseImage dst
]



loadImage: does [
	tmp: request-file 
	if not none? tmp [
		canvas/image: black
		isFile: true
		fileName: to string! to-file tmp
		sfileName: to string! second split-path tmp	
		img1: loadSrc fileName
		img2: createDst
		if img1 <> 0 [
			wsz: getIWidth img1
			hsz: getIHeight img1
			; if image does not fit screen, scale it
			scale: (max 1 1 + max (2 * margins/x + wsz) / mSizeX (9 * margins/y + hsz) / mSizeY)
			win/size/x: to-integer (2 * margins/x + max 256 wsz / to-integer scale)	
			win/size/y: to-integer (9 * margins/y + max 256 hsz / to-integer scale)	
			win/text: append append append sfileName " (1:" scale ")"
			canvas/size/x: wsz / to-integer scale
			canvas/size/y: hsz / to-integer scale
			sl1/size/x: wsz / to-integer scale 
			sl1/size/x: sl1/size/x - 50
			text2/offset/x: win/size/x - 55
			canvas/offset/x: win/size/x - canvas/size/x / 2
			sl1/offset/x: canvas/offset/x
			lineRequired: getImageOffset img1
			canvas/image: makeRedImage img1 wsz hsz
		]
	]
	thresh: 0 sl1/data: 0% text2/text: "0.0"
	
]

; for Red Gui Interface

view win: layout [
	title "Gaussian Filter"
	origin margins space margins
	button 60 "Load"	[loadImage]
	button 60 "Quit"	[if isFile [freeOpenCV] recycle/on quit]
	return
	sl1: slider 460x20	[thresh: to integer! round face/data * 255
							if odd? thresh [param1: to integer! round face/data * 255]
							text2/text: form param1
							if isFile [
								makeGaussianBlur param1
								either thresh = 0 [updateRedImage img1 canvas/image] 
											   	  [updateRedImage img2 canvas/image]
							]
						]
	text2: field 45 "0.0"	
 	return
 	canvas: base 512x512
 	do [recycle/off]
]







