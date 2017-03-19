Red [
	Title:   "Find Face"
	Author:  "F. Jouen"
	File: 	 %findFaces.red
	Needs:	 'View
]

; import required OpenCV libraries
#system [
	#include %../../libs/include.reds ; all OpenCV  functions
	img: declare CvArr!
	imgCopy: declare CvArr!
	clone: declare CvArr!
	pyrImg: declare CvArr!
	cascade: declare CvHaarClassifierCascade!
	storage: declare CvMemStorage!
	faces: declare CvSeq! 
	faceRect: declare byte-ptr!
	ptr: declare int-ptr!
	roi: declare cvRect!
	nFaces: 0 
	;classifier: "c:\Users\palm\coding\red\OpenCV\cascades\haarcascades\haarcascade_frontalface_default.xml"
	classifier: "/Users/fjouen/Programmation/Programmation_en_cours/red/OpenCV/cascades/haarcascades/haarcascade_frontalface_default.xml"
]

; global red variables to be passed as parameters to routines or used by red functions

set 'appDir what-dir 
margins: 5x5
clName: "haarcascade_frontalface_default.xml"
scaleFactor: 1.1
minNeighbors: 3
minSize: 0x0
maxSize: 0x0
isFile: false
src: 0
flagValue: 1
nbFaces: 0

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

; Red Routines for OpenCV access

; release all image pointers
freeOpenCV: routine [] [
	releaseImage img
	releaseImage pyrImg
	releaseImage clone
	releaseImage imgCopy
]

loadTraining: routine [name [string!]/local fName][
	fName: as c-string! string/rs-head name;
	classifier: fName
]

; loads image with faces and returns image address as an integer
loadImg: routine [name [string!] return: [integer!] /local fName tmp isLoaded] [
	isLoaded: 0
	fName: as c-string! string/rs-head name;
	tmp: cvLoadImage fName CV_LOAD_IMAGE_COLOR ; CV_LOAD_IMAGE_ANYDEPTH OR CV_LOAD_IMAGE_ANYCOLOR; 
	img: as int-ptr! tmp
	clone: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR 
	imgCopy: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR
	pyrImg: as int-ptr! cvCreateImage tmp/width / 2  tmp/height / 2 IPL_DEPTH_8U 3
	storage: cvCreateMemStorage 0
	cvSmooth img img CV_GAUSSIAN 3 3 0.0 0.0      ;gaussian smoothing
    cvPyrDown img pyrImg CV_GAUSSIAN_5x5 		  ;reduce original size to improve speed in face recognition
    cvCopy img clone null
	cvFlip clone clone -1
	isLoaded: as integer! clone
	isLoaded  
]

; looks for faces 
findFaces: routine [sFactor [float!] minNB [integer!] flag [integer!] minS [pair!] maxS [pair!] return: [integer!] 
	/local c x y wd hg ] [
	cvCopy imgCopy img null
	cascade: cvLoadHaarClassifierCascade classifier 20 20 ;seems OK
	faces: cvHaarDetectObjects pyrImg cascade storage sFactor minNB flag minS/x minS/y maxS/x maxS/y
	nFaces: faces/total ; for faceCount routine
	if faces/total > 0 [
		c: 0
		until [
			faceRect: cvGetSeqElem faces c ; faceRect is a byte-ptr!
			ptr: as int-ptr! faceRect ; we cast to an int-ptr! since we have 4 integers to get here
			; * 2 due to original image pyrdown
			x: ptr/1 * 2 
			y: ptr/2 * 2 
			wd: (ptr/1 + ptr/3) * 2 
			hg:  (ptr/2 + ptr/4) * 2
			roi: cvRect x y wd hg
			cvRectangle img roi/x roi/y roi/width roi/height 0.0 255.0 0.0 0.0 2 CV_AA 0
			c: c + 1
			c = faces/total
		]
	]
	cvCopy img clone null
	cvFlip clone clone -1
	as integer! clone 
]

;returns nb of found faces
countFaces: routine [return: [integer!]][nFaces]


;Red Functions calling routines 

loadImage: does [
	isFile: false
	canvas/image: black
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-local-file tmp	
		src: loadImg fileName
		if src <> 0 [
			isFile: true
			win/text: fileName
			; update faces
			wsz: getIWidth src wsz 
			hsz: getIHeight src hsz
			canvas/image: makeRedImage src wsz hsz
		]
	]
]

loadClassifier: does [
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-local-file tmp
		info1/data: form second split-path tmp 
		loadTraining fileName
	]	
]

faces: does [
	t1: now/time/precise
	src: findFaces scaleFactor minNeighbors flagValue minSize maxSize
	t2:  now/time/precise
	s: form countFaces
	append s " in "
	append s third t2 - t1 
	append s " sec"
	sb/data: s
	canvas/image: makeRedImage src wsz hsz
]

;Red GUI Interface
view win: layout [
	title "Find Faces"
	button 60 "Load"			[loadImage faces]
	button 80 "Classifier"		[loadClassifier if isFile [faces]]
	info1: field  220 clname
	text 30 "Flags"
	flag: drop-down 210x24 
		data ["CV_HAAR_DO_CANNY_PRUNING" "CV_HAAR_FIND_BIGGEST_OBJECT"
	       "CV_HAAR_DO_ROUGH_SEARCH" "CV_HAAR_SCALE_IMAGE"] 
	    select 1  
	    on-change [
	    	if isFile [
	    		switch flag/selected[
	    			1  	[flagValue: 1]
	    			2	[flagValue: 4]
	    			3	[flagValue: 8]
	    			4	[flagValue: 2]
	    		]
	    		faces	
	    	]
	    ]     
	return
	text "Scale Increase"
	sl1: slider 100 [scaleFactor: 1.1 + to float! face/data 
	                tscale/data: 1.1 + face/data if isFile [faces]]
	tscale: field 40 "1.1"
	text  "Min Neighbors"
	field 30 "3" [minNeighbors: to-integer face/data if isFile [faces]]
	text 70 "Size Min Max"
	field 40 "0x0" [minSize: to-pair face/data if isFile [faces]]
	field 40 "0x0" [maxSize: to-pair face/data if isFile [faces]]
	button 50 "Quit" [if isFile [freeOpenCV] Quit]
	return
	canvas: base 640x480 black
	return
	text 100 "Found faces : " sb: field 130
	do [sl1/data: 0.0]
]