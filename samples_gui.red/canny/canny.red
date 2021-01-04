Red [
	Title:   "OpenCV Canny Red VID"
	Author:  "Francois Jouen"
	File: 	 %canny.red
	Needs:	 'View
]

; import required OpenCV libraries

#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	src: declare CvArr!		; pointer to Source image
	dst: declare CvArr!		; pointer to Destination image
	gray: declare CvArr!	; for grayscale image
	edges: declare CvArr!	; for edges detection
	&src: 0					; address of image as integer
	&dst: 0					; address of image as integer
	fName: ""				; a c-string for filename storage
]


; global red variables to be passed as parameters to routines or red functions
fileName: copy ""
thresh: 0.0
img1: 0
img2: 0
wsz: 0
hsz: 0
isFile: false
mSizeX: system/view/screens/1/size/x
mSizeY: system/view/screens/1/size/y - 60
margins: 10x10

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

; red/S routines we need

makeCanny: routine [ t [float!]][
	cvSmooth src dst CV_BLUR 3 3 0.0 0.0
	cvNot gray edges
	cvCanny gray edges t t * 3.0 3
	cvZero dst
	cvCopy src dst edges
]

; img1 source
loadSrc: routine [name [string!] return: [integer!]] [
	src: null
	&src: 0
	fName: as c-string! string/rs-head name;
	src: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR ;  force a 8-bit color conversion
	if src <> null [
		;cvNamedWindow "Source" CV_WINDOW_AUTOSIZE
		;cvShowImage "Source" src
		cvFlip src src -1
		&src: as integer! src
	]
	&src
]

; img2 destination color (cedges)
createDst: routine [return: [integer!]] [
	gray: as int-ptr! cvCreateImage getIWidth &src getIHeight &src IPL_DEPTH_8U 1
	cvCvtColor src gray CV_RGB2GRAY
	edges: as int-ptr! cvCreateImage getIWidth &src getIHeight &src IPL_DEPTH_8U 1
	dst: as int-ptr! cvCreateImage getIWidth &src getIHeight &src IPL_DEPTH_8U 3
	&dst: as integer! dst   
	&dst
]



; release all image pointers
freeOpenCV: routine [] [
	releaseImage src
	releaseImage gray
	releaseImage edges
	releaseImage dst
]


loadImage: does [
	tmp: request-file 
	if not none? tmp [
		fileName: to string! to-file tmp
		sfileName: to string! second split-path tmp
		img1: loadSrc fileName
		img2: createDst
		if img1 <> 0 [
			canvas/image: none
			wsz: getIWidth img1
			hsz: getIHeight img1
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
			canvas/image: makeRedImage img1 wsz hsz	
			isFile: true
		]
		
	]
	thresh: 0 sl1/data: 0%
	text2/text: "0.0"
]

view win: layout [
	title "Canny Filter"
	origin margins space margins
	button 60 "Load"	[loadImage]
	button 60 "Quit"	[if isFile [freeOpenCV] recycle/on quit]
	return
	sl1: slider 450x20	[ thresh: to-float to-integer round face/data * 255
							text2/text: form thresh
							if isFile [
								makeCanny thresh
								either thresh = 0.0 [updateRedImage img1 canvas/image]
												    [updateRedImage img2 canvas/image]
							]	
						]
					
 	text2: field 45 "0.0"	
 	return
 	canvas: base 512x512
 	do [recycle/off]
]	



