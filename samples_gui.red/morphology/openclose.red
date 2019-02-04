Red [
	Title:   "OpenCV Morphology"
	Author:  "Francois Jouen"
	File: 	 %openclose.red
	Needs:	 'View
]

; import required OpenCV libraries

#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	src: declare CvArr!		; pointer to Source image
	dst: declare CvArr!		; pointer to Destination image
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
margins: 10x10
flagValue: 0

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

; red/S routines we need

OpenClose: routine [ t [integer!] shape [integer!] /local an element &element][
	either t > 0 [an: t] [an: 0 - t]
	element: cvCreateStructuringElementEx (an * 2) + 1 (an * 2) + 1 an an shape null ; 0
	&element: declare double-int-ptr!
	&element/ptr: as int-ptr! element 
	either t < 0 [cvErode src dst element 1 cvDilate dst dst element 1]
                 [cvDilate src dst element 1 cvErode dst dst element 1]
	cvReleaseStructuringElement  &element
]

; img1 source
loadSrc: routine [name [string!] return: [integer!]] [
	src: null
	&src: 0
	fName: as c-string! string/rs-head name;
	src: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR ;  force a 8-bit color conversion
	if src <> null [
		cvFlip src src -1
		&src: as integer! src
	]
	&src
]

; img2 destination color (cedges)
createDst: routine [return: [integer!]] [
	dst: as int-ptr! cvCreateImage getIWidth &src getIHeight &src IPL_DEPTH_8U 3
	&dst: as integer! dst   
	&dst
]



; release all image pointers
freeOpenCV: routine [] [
	releaseImage src
	releaseImage dst
]

showOperator: does [
	if isFile [
		OpenClose thresh flagValue
		either thresh = 0.0 [updateRedImage img1 canvas/image]
							[updateRedImage img2 canvas/image]
	]	
]



loadImage: does [
	tmp: request-file 
	if not none? tmp [
		isFile: true
		fileName: to string! to-file tmp
		sfileName: to string! second split-path tmp
		img1: loadSrc fileName
		img2: createDst
		if img1 <> 0 [
			canvas/image: none
			wsz: getIWidth img1
			hsz: getIHeight img1
			canvas/image: makeRedImage img1 wsz hsz	
			isFile: true
		]
	]
	thresh: 0 sl1/data: 0%
	text2/text: "0.0"
]

view win: layout [
	title "Morphology: Open/Close"
	origin margins space margins
	button 60 "Load"	[loadImage]
	text "Structuring Element" 
	flag: drop-down 150x24 
		data ["CV_SHAPE_RECT" "CV_SHAPE_CROSS" "CV_SHAPE_ELLIPSE"] 
	    select 1  
	    on-change [
	    	switch flag/selected[
	    		1  	[flagValue: 0]
	    		2	[flagValue: 1]
	    		3	[flagValue: 2]
	    	]
	    	showOperator
	    ]     
	
	pad 75x0
	button 60 "Quit"	[if isFile [freeOpenCV] recycle/on quit]
	return
	sl1: slider 450x20	[ thresh: to-integer round face/data * 64
							text2/text: form thresh
							showOperator
						]
					
 	text2: field 45 "0.0"	
 	return
 	canvas: base 512x512
 	do [recycle/off]
]	



