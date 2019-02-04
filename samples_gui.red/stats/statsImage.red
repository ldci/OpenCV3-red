Red [
	Title:		"Image Stats"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2019 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
	Needs:	 	'View
]


; import required OpenCV libraries
#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	; global variables that can be used by routines
	img: declare CvArr!
	sum: declare CvScalar!
	mean: declare CvScalar!
	std: declare CvScalar!
]

; some routines for image conversion from openCV to Red 
#include %../../libs/red/cvroutines.red

fileName: ""
isFile: false
img1: 0
imgSize: 450x450


freeOpenCV: routine [] [
	releaseImage img	
]

loadImg: routine [ name [string!] return: [integer!] /local s fName &img] [
	&img: 0
	fName: as c-string! string/rs-head name;
	img: as int-ptr! cvLoadImage fName CV_LOAD_IMAGE_COLOR; force 8-bit
	if img <> null [
		; get mean and Standard Deviation values 
		cvAvgSdv img mean std null
		; getSum temporary replace cvSum 
		sum: getSum img
		&img: as integer! img  
		cvFlip img img -1
	]
	&img
]

returnSum: routine [channel [integer!]return: [float!] /local v][
	switch channel [
		0 [v: sum/v0]
		1 [v: sum/v1]
		2 [v: sum/v2]
		3 [v: sum/v3]
	]
	v
]

returnStd: routine [channel [integer!]return: [float!] /local v][
	switch channel [
		0 [v: std/v0]
		1 [v: std/v1]
		2 [v: std/v2]
		3 [v: std/v3]
	]
	v
]


returnMean: routine [channel [integer!]return: [float!] /local v][
	switch channel [
		0 [v: mean/v0]
		1 [v: mean/v1]
		2 [v: mean/v2]
		3 [v: mean/v3]
	]
	v
]

getMean: function [return: [block!]] [
	blk: copy []
	append blk returnMean 0
	append blk returnMean 1
	append blk returnMean 2
	append blk returnMean 3
	blk
]

getSum: function [return: [block!]] [
	blk: copy []
	append blk returnSum 0
	append blk returnSum 1
	append blk returnSum 2
	append blk returnSum 3
	blk
]

getStd: function [return: [block!]] [
	blk: copy []
	append blk returnStd 0
	append blk returnStd 1
	append blk returnStd 2
	append blk returnStd 3
	blk
]



loadImage: does [
	tmp: request-file 
	if not none? tmp [		
		fileName: to string! to-file tmp
		img1: loadImg fileName
		if img1 <> 0 [
			win/text: to string! second split-path tmp 
			result/text: copy "Image Stats by channel (RGBA)"
			append result/text newline
			isFile: true
			wsz: getIWidth img1
			hsz: getIHeight img1
			canvas/image: makeRedImage img1 wsz hsz
			append result/text rejoin ["Image size : " form as-pair wsz hsz newline]
			append result/text rejoin ["Sum : " form getSum newline]
			append result/text rejoin ["Mean : " form getMean newline]
			append result/text rejoin ["Std : " form getStd newline]
		]
	]
]


view win: layout [
	title "Image Statistics"
	button "Load"		[loadImage]
	button "Quit" 		[if isFile [freeOpenCV] recycle/on quit]
	return 
	canvas: base imgSize
	return
	result: area 450x80
	do [recycle/off]
]