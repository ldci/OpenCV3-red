Red [
	Title:		"OpenCV Tests: Faces "
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; according to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/caravage.jpg"]
		Windows [picture: "c:\Users\palm\Pictures\caravage.jpg"]
		Linux	[picture: "/home/fjouen/Images/caravage.jpg"]
	]
	
	classifier: "/Users/fjouen/Programmation/Programmation_en_cours/Red/OpenCV/cascades/haarcascades/haarcascade_frontalface_alt.xml"
	
	img: declare CvArr!
	pyrImg: declare CvArr!
	cascade: declare CvHaarClassifierCascade!
	storage: declare CvMemStorage!
	faces: declare CvSeq! 
	faceRect: declare byte-ptr!
	ptr: declare int-ptr!
	roi: declare cvRect!
	windowsName: "Input Source"
	; you can play with these variables to modifiy image processing
	scaleFactor: 1.1 ; must be > 1.0
	minNeighbors: 3 ;  Default value 3
	; Minimum window size. By default, it is set to the size of samples the classifier 
	;has been trained on (~20×20 for face detection).
	minSize: 20 
	maxSize: 0
	flags: CV_HAAR_DO_ROUGH_SEARCH;CV_HAAR_FIND_BIGGEST_OBJECT ;CV_HAAR_SCALE_IMAGE;CV_HAAR_DO_CANNY_PRUNING ;  
]

; loads image with faces
loadImage: routine [/local tmp] [
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR 
	img: as int-ptr! tmp
	pyrImg: as int-ptr! cvCreateImage tmp/width / 2  tmp/height / 2 IPL_DEPTH_8U 3
	storage: cvCreateMemStorage 0
	cvSmooth img img CV_GAUSSIAN 3 3 0.0 0.0      ;gaussian smoothing
    cvPyrDown img pyrImg CV_GAUSSIAN_5x5 		  ;reduce original size to improve speed in face recognition
	cvNamedWindow windowsName CV_WINDOW_AUTOSIZE  ;create window 
	cvShowImage windowsName img
	cvMoveWindow windowsName  100 40
]


; looks for faces 
findFaces: routine [/local c x y wd hg] [
	;cvLoad classifier as byte-ptr! cascade "" ""; doesn't work
	cascade: cvLoadHaarClassifierCascade classifier 20 20 ;seems OK
	;print [cascade/flags " " cascade/count " " cascade/orig_window_size_x " " cascade/orig_window_size_y " " 
	;cascade/real_window_size_x " " cascade/real_window_size_y " " cascade/scale " " 
	;cascade/stage_classifier " "  cascade/hid_cascade lf]
	faces: cvHaarDetectObjects pyrImg cascade storage scaleFactor minNeighbors flags minSize minSize maxSize maxSize
	print ["Found faces: " faces/total lf]
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
			;print [c " " x " " y " " wd " " hg lf]
			cvRectangle img roi/x roi/y roi/width roi/height 0.0 255.0 0.0 0.0 2 CV_AA 0
			c: c + 1
			c = faces/total
		]
	]
	cvShowImage windowsName img
	cvWaitKey 0
]

; frees memory
freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage img
	releaseImage pyrImg
]



;********************** MAIN PROGRAM **************************

loadImage
findFaces
freeOpenCV
quit




