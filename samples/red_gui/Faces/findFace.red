Red [
	Title:   "Find Face"
	Author:  "F. Jouen"
	File: 	 %findFaces.red
	Needs:	 'View
]

; import required OpenCV libraries
#system [
	;#include %../../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	; variables that can be used inside routines
	;cvimage: declare CvArr! 		; pointer to OpenCV Image
	;&cvimage: 0						; address of pointer as integer!
	;wName: "Source"
]




; global red variables to be passed as parameters to routines or red functions


set 'appDir what-dir 
isImage: false
margins: 5x5

clname: "haarcascade_frontalface_alt_tree.xml"
scaleFactor: 1.1
minNeighbors: 3
wsize: 0



view win: layout [
	title "Find Faces"
	button 60 "Load"	
	button 60 "Classifier"
	info1: field  250 clname
	
	text 50 "Flags"
	flag: drop-down 200x24 
		data ["CV_HAAR_DO_CANNY_PRUNING" "CV_HAAR_FIND_BIGGEST_OBJECT"
	       "CV_HAAR_DO_ROUGH_SEARCH" "CV_HAAR_SCALE_IMAGE"] 
	    select 1       
	button 60 "Quit" [Quit]
	return
	text "Scale Increase"
	sl1: slider 100 [scaleFactor: 1.1 + to float! face/data 
	                tscale/data: 0.1 + face/data]
	tscale: field 50 "0.1"
	text  "Min nb of rect"
	field 50 "0" [minNeighbors: to-integer face/data]
	text "Min Win Size"
	field 50 "0" [wsize: to-integer face/data]
	button 95 "Find Faces"
	do [sl1/data: 0.0]
]