Red [
	Title:   "OpenCV loadimage Red VID "
	Author:  "Francois Jouen"
	File: 	 %loadimage.red
	Needs:	 'View
]



; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           	; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          	; basic OpenCV types and structures
	#include %../../libs/imgproc/types_c.reds       	; image processing types and structures
	#include %../../libs/highgui/cvHighgui.reds       	; highgui functions
	#include %../../libs/imgcodecs/cvImgcodecs.reds   	; basic image functions
	#include %../../libs/imgproc/cvImgproc.reds       	; OpenCV image  processing
	#include %../../libs/core/cvCore.reds             	; OpenCV core functions
	
	; variables for routines
	img: declare CvArr!
	imgStruct: declare IplImage!
	iWidth: 0
	wName: "OpenCV Source"
]

live?: system/view/auto-sync?: no

; global red variables to be passed as parameters to routines or red functions
fileName: ""


cvLoad: routine [ name [string!]] [
	img: as int-ptr! cvLoadImage as c-string! string/rs-head name CV_LOAD_IMAGE_ANYCOLOR 
	cvShowImage wName img
]

; to get each ipl structure value
getValue: routine [index [integer!] return: [integer!] /local v s] [
	imgStruct: getImageValues img ; IplImage structure
	case [
		index = 1 [v: imgStruct/nSize]
		index = 2 [v: imgStruct/ID]
		index = 3 [v: imgStruct/nChannels]
		index = 4 [v: imgStruct/alphaChannel]
		index = 5 [v: imgStruct/depth]
		index = 6 [s: imgStruct/colorModel 
			if s/1 = #"R" [v: 1] ; RGB 
			if s/1 = #"G" [v: 3] ; GRAY
		] 
		index = 7 [s: imgStruct/channelSeq  
			if s/1 = #"R" [v: 1] ; RGBA 
			if s/1 = #"B" [v: 2] ; BGRA 
			if s/1 = #"G" [v: 3] ; GRAY
		
		] 
		index = 8  [v: imgStruct/dataOrder]
		index = 9  [v: imgStruct/origin]
		index = 10 [v: imgStruct/align]
		index = 11 [v: imgStruct/width]
		index = 12 [v: imgStruct/height]
		index = 13 [v: as integer! imgStruct/*roi]
		index = 14 [v: as integer! imgStruct/*maskROI]
		index = 15 [v: as integer! imgStruct/*imageId]
		index = 16 [v: as integer! imgStruct/*tileInfo]
		index = 17 [v: imgStruct/imageSize]
		index = 18 [v: imgStruct/*imageData]
		index = 19 [v: imgStruct/widthStep]
		index = 20 [v: imgStruct/bm0]
		index = 21 [v: imgStruct/bm1]
		index = 22 [v: imgStruct/bm2]
		index = 23 [v: imgStruct/bm3]
		index = 24 [v: imgStruct/bc0]
		index = 25 [v: imgStruct/bc1]
		index = 26 [v: imgStruct/bc2]
		index = 27 [v: imgStruct/bc3]
		index = 28 [v: as integer! imgStruct/*imageDataOrigin]
	]
	v
]


loadImage: does [
	
	tmp: request-file
	if not none? tmp [
		clear list/data
		clear list/text
		s: copy ""
		fileName: to string! to-local-file tmp	
		activeFile/text: to string!  to-local-file tmp	
		rimg/image: load tmp
		cvLoad fileName
		s: "Image Size in byte: "	
		append s to string! getValue 1	
		append list/data s
		s: "Image ID: "
		append s to string! getValue 2
		append list/data s
		s: "Number of Channels: "
		append s to string! getValue 3
		append list/data s
		s: "Image Alpha: "
		append s to string! getValue 4
		append list/data s
		s: "Image Depth: "
		append s to string! getValue 5
		append list/data s
		s: "Color Model: "
		v: getValue 6
		either v = 1 [append s "RGBA"] [append s "GRAY"]
		append list/data s
		s: "Channels Sequence: "
		v: getValue 6
		if v = 1 [append s "RGBA"]
		if v = 2 [append s "BGRA"]
		if v = 3 [append s "GRAY"]
		append list/data s
		s: "Data Order: "
		append s to string! getValue 8
		append list/data s
		s: "Data Origin: "
		append s to string! getValue 9
		append list/data s
		s: "Data Align: "
		append s to string! getValue 10
		append list/data s
		s: "Image Width: "
		append s to string! getValue 11
		append list/data s
		s: "Image Height: "
		append s to string! getValue 12
		append list/data s
		s: "Image ROI: "
		append s to string! getValue 13
		append list/data s
		s: "Image Mask ROI: "
		append s to string! getValue 14
		append list/data s
		s: "Image Pointer ID: "
		append s to string! getValue 15
		append list/data s
		s: "Image info: "
		append s to string! getValue 16
		append list/data s
		s: "Image Size: "
		append s to string! getValue 17
		append list/data s
		s: "Image Data: "
		append s to string! getValue 18
		append list/data s
		s: "Image Width Step: "
		append s to string! getValue 19
		append list/data s
		s: "Image Border Mode 1: "
		append s to string! getValue 20
		append list/data s
		s: "Image Border Mode 2: "
		append s to string! getValue 21
		append list/data s
		s: "Image Border Mode 3: "
		append s to string! getValue 22
		append list/data s
		s: "Image Border Mode 4: "
		append s to string! getValue 23
		append list/data s
		s: "Image Border 1 color : "
		append s to string! getValue 24
		append list/data s
		s: "Image Border 2 color: "
		append s to string! getValue 25
		append list/data s
		s: "Image Border 3 color: "
		append s to string! getValue 26
		append list/data s
		s: "Image Border 4 color: "
		append s to string! getValue 27
		append list/data s
		s: "Image Data Origin: "
		append s to string! getValue 28
		append list/data s
	]
]


MainWin: [
        title "Load Image"
        button 205 "Load Image" [loadImage]
        activeFile: field 400 ""
        button 100 "Quit" [Quit] 
        return
        list: text-list 205x512 data []
        rimg: image 512x512 black
]

view MainWin
