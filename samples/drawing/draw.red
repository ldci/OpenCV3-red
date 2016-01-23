Red [
	Title:		"OpenCV Tests: Draw functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


; import required OpenCV libraries
#system [
    #include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
    #include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
    #include %../../libs/imgproc/types_c.reds       ; image processing types and structures
    #include %../../libs/core/core.reds             ; OpenCV core functions
    #include %../../libs/highgui/highgui.reds       ; highgui functions
    #include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
    #include %../../libs/imgproc/imgproc.reds       ; OpenCV image  processing
    #include %../../libs/red/user.reds		    ; for conversion
    
    ; some variables that can be accessed ONLY by routines and NOT by RED code
    pt1: declare CvPoint!
    pt2: declare CvPoint!
    color: declare CvScalar!
    font: declare CvFont!
    text_size: declare CvSize!
    width: 1000 
    height: 700
    width3: width * 3
    height3: height * 3;
    thickness: 0
    ymin: 0
    iplimage: declare IplImage!
    image2: declare IplImage!
    ii: 1.0
]

; global red variables to be passed as parameters to routines

number: 99
p1: 0x0
p2: 0x0
p3: 0x0
p4: 0x0
p5: 0x0
p6: 0x0
wndname: "Red can call OpenCV drawing and text output functions"
r: g: b: 0
radius: 0
angle: 0.0
sz: 0x0;
tmpFont: 0
vsf: 0
hsf: 0

; red random functions
random/seed 65536

randomPoints: does [
	p1/x: (random 3000) % 1000
	p1/y: (random 2100) % 700
	p2/x: (random 3000) % 1000
	p2/y: (random 2100) % 700
]

randomColor: does [
	r:  random 255
	g:  random 255
	b:  random 255
]

;we can't use block! with routine so use pair!
randomArray: does [
	p1/x: (random 3000) % 1000
	p1/y: (random 2100) % 700
	p2/x: (random 3000) % 1000
	p2/y: (random 2100) % 700
	p3/x: (random 3000) % 1000
	p3/y: (random 2100) % 700
	p4/x: (random 3000) % 1000
	p4/y: (random 2100) % 700
	p5/x: (random 3000) % 1000
	p5/y: (random 2100) % 700
	p6/x: (random 3000) % 1000
	p6/y: (random 2100) % 700
]

randomFont: does [
	; 0 to 7 see basic font types in cxcore.reds
	tmpFont: first random [0 1 2 3 4 5 6 7]
	vsf: first random [1 2 3 4 5 6]
	hsf: first random [1 2 5]
]

; Red routines to access opencv functions

; create a 32-bit image
; openCV 32 bits images rgb values are [-127.00 + 128.00]
; this is why we use the tocvRGB function
; if you want play with 8-bit image rgb values are [0..255]

createImage: routine [ name [string!]
	] [
	cvInitFont font CV_FONT_HERSHEY_SIMPLEX 2.0 2.0 0.0 1 CV_AA
	iplimage: cvCreateImage width height IPL_DEPTH_32F 3
	cvNamedWindow as c-string! string/rs-head name CV_WINDOW_AUTOSIZE
	cvZero as byte-ptr! iplimage
	cvGetTextSize "Any key to start" font text_size as int-ptr! ymin
	pt1/x: (width - text_size/width) / 2
	pt1/y: (height + text_size/height) / 2
	cvPutText as byte-ptr! iplimage "Any key to start" pt1/x pt1/y font 0.0 56.0 -56.0 0.0
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
	cvwaitKey 0
]

; give some information about tested functions
makeTitle: routine [name [string!] txt [string!]][
	cvInitFont font CV_FONT_HERSHEY_SIMPLEX 2.0 2.0 0.0 1 CV_AA
	cvGetTextSize as c-string! string/rs-head txt font text_size as int-ptr! ymin
	pt1/x: (width - text_size/width) / 2
	pt1/y: (height + text_size/height) / 2
	cvZero as byte-ptr! iplimage
	cvPutText as byte-ptr! iplimage as c-string! string/rs-head txt pt1/x pt1/y font 0.0 56.0 -56.0 0.0
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
]

; clear main image
clearImage: routine [name [string!]][
	cvZero as byte-ptr! iplimage
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
]

waitFor: routine [delay [integer!]][cvwaitKey delay]

;************************* Image Substraction ***************************
initSubstract: routine [][
	cvInitFont  font CV_FONT_HERSHEY_COMPLEX 3.0 3.0 0.0 5 CV_AA
	cvGetTextSize "www.red-lang.org" font text_size as int-ptr! ymin
	pt1/x: (width - text_size/width) / 2
	pt1/y: (height + text_size/height) / 2
	image2: cvCloneImage iplimage 
]

drawSubstract: routine [
	name 	[string!]
	r  		[integer!]
	g  		[integer!]
	b  		[integer!]
	/local allS
	] [
	allS: cvScalarAll ii
	cvSubS as byte-ptr! image2 allS/v0 allS/v1 allS/v2 allS/v3 as byte-ptr! iplimage null
	color: tocvRGB int-to-float r int-to-float g int-to-float b 0.0
	cvPutText as byte-ptr! iplimage "www.red-lang.org" pt1/x pt1/y font color/v0 color/v1 color/v2 color/v3
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
	ii: ii + 1.0
	cvWaitKey 1
]


;************************* Draw Lines ***************************

drawText: routine [
	name [string!]
	p1 		[pair!]
	f		[integer!]
	h		[integer!]
	v		[integer!]
	r  		[integer!]
	g  		[integer!]
	b  		[integer!]
	t  		[integer!]]
	[
	cvInitFont font f int-to-float h int-to-float v 0.0 t CV_AA
	color: tocvRGB int-to-float r int-to-float g int-to-float b 0.0
	cvPutText as byte-ptr! iplimage "Red is fantastic!" p1/x p1/y font color/v0 color/v1 color/v2 color/v3
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
	cvWaitKey 1
]


;************************* Draw Lines ***************************
drawLines: routine [
	name		[string!]
	p1 		[pair!]
	p2 		[pair!]
	r  		[integer!]
	g  		[integer!]
	b  		[integer!]
	t  		[integer!]
	][
	color: tocvRGB int-to-float r int-to-float g int-to-float b 0.0
	cvLine as byte-ptr! iplimage p1/x p1/y p2/x p2/y color/v0 color/v1 color/v2 color/v3 t CV_AA 0
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
	cvWaitKey 1
]

;************************* Draw Rectangles ***************************
drawRectangles: routine [
	name		[string!]
	p1 		[pair!]
	p2 		[pair!]
	r  		[integer!]
	g  		[integer!]
	b  		[integer!]
	t  		[integer!]
	][
	color: tocvRGB int-to-float r int-to-float g int-to-float b 0.0
	cvRectangle as byte-ptr! iplimage p1/x p1/y p2/x p2/y color/v0 color/v1 color/v2 color/v3 t CV_AA 0
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
	cvWaitKey 1
]

;************************* Draw Circles ***************************
drawCircles: routine [
	name		[string!]
	p1 		[pair!]
	rad		[integer!]
	r  		[integer!]
	g  		[integer!]
	b  		[integer!]
	t  		[integer!]
	][
	color: tocvRGB int-to-float r int-to-float g int-to-float b 0.0
	cvCircle as byte-ptr! iplimage p1/x p1/y rad color/v0 color/v1 color/v2 color/v3 t CV_AA 0
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
	cvWaitKey 1
]

;************************* Draw Ellipses ***************************
drawEllipses: routine [
	name		[string!]
	p1 		[pair!]
	p2		[pair!]
	angle		[float!]
	r  		[integer!]
	g  		[integer!]
	b  		[integer!]
	t  		[integer!]
	/local anglea starta enda 
	][
	color: tocvRGB int-to-float r int-to-float g int-to-float b 0.0
	; until a new float! implementation by red 0.6.0
	; float as conssdred as pointers!
	anglea: angle
	starta:  angle + 100.0 
	enda: angle + 200.0
	cvEllipse as byte-ptr! iplimage p1/x p1/y p2/x p2/y anglea starta enda color/v0 color/v1 color/v2 color/v3 t CV_AA 0
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
	cvWaitKey 1
]

;************************* Draw Polygons ***************************
drawPolygons: routine [
	name	[string!]
	p1 		[pair!]
	p2		[pair!]
	p3 		[pair!]
	p4		[pair!]
	p5 		[pair!]
	p6		[pair!]
	r  		[integer!]
	g  		[integer!]
	b  		[integer!]
	t  		[integer!]
	/local mem1 mem2 parray ppoints dppoints contours isClosed
	] [
	; Array of polyline vertex counters [3][3]
	mem1: allocate 2 * size? integer!
	parray: as [int-ptr!] mem1
	parray/1: 3
	parray/2: 3
	;Array of pointers to polylines 12
	mem2: allocate 12 * size? integer!
	ppoints: as [int-ptr!] mem2 ; a pointer to CvPoints array
	ppoints/1: p1/x
	ppoints/2: p1/y
	ppoints/3: p2/x
	ppoints/4: p2/y
	ppoints/5: p3/x
	ppoints/6: p3/y
	ppoints/7: p4/x
	ppoints/8: p4/y
	ppoints/9: p5/x
	ppoints/10: p5/y
	ppoints/11: p6/x
	ppoints/12: p6/y
	
	dppoints: declare diptr! ; double int pointer to CvPoints array
	dppoints/ptr: ppoints
	color: tocvRGB int-to-float r int-to-float g int-to-float b 0.0
	contours: 2
	isClosed: 1 
	cvPolyLine as byte-ptr! iplimage dppoints parray contours isClosed color/v0 color/v1 color/v2 color/v3 t CV_AA 0
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
	free mem1
	free mem2
	cvWaitKey 1
]

drawConvexPoly: routine [
	name	[string!]
	p1 		[pair!]
	p2		[pair!]
	p3 		[pair!]
	p4		[pair!]
	p5 		[pair!]
	p6		[pair!]
	r  		[integer!]
	g  		[integer!]
	b  		[integer!]
    /local mem2  ppoints
] [
	mem2: allocate 12 * size? integer!
	ppoints: as [int-ptr!] mem2 ; a pointer to CvPoints array
	ppoints/1: p1/x
	ppoints/2: p1/y
	ppoints/3: p2/x
	ppoints/4: p2/y
	ppoints/5: p3/x
	ppoints/6: p3/y
	ppoints/7: p4/x
	ppoints/8: p4/y
	ppoints/9: p5/x
	ppoints/10: p5/y
	ppoints/11: p6/x
	ppoints/12: p6/x
	color: tocvRGB int-to-float r int-to-float g int-to-float b 0.0
	cvFillConvexPoly as byte-ptr! iplimage ppoints 6 color/v0 color/v1 color/v2 color/v3 CV_AA 0
	cvShowImage as c-string! string/rs-head name as byte-ptr! iplimage
	free mem2
	cvWaitKey 1
]


;************************* free memory used by OpenCV ***************************

freeOpenCV: routine [] [
	cvDestroyAllWindows
	releaseImage as byte-ptr! iplimage
	releaseImage as byte-ptr! image2
]


;************************* Main Red Program ***************************

print ["Select graphical window" newline]
createImage wndname
makeTitle wndname "Drawing Lines"
waitFor 500
clearImage wndname

i: 0
until [
	randomPoints
	randomColor
	thickness: random 10
	drawLines wndname p1 p2 r g b thickness
	i: i + 1
	i = (number + 1)
]
waitFor 1000

makeTitle wndname "Drawing Rectangles "
waitFor 500
clearImage wndname
i: 0
until [
	randomPoints
	randomColor
	thickness: first random [-1 1 0 2 3 4 5 6 7 8 9] ;-1 for filled form
	drawRectangles wndname p1 p2 r g b thickness
	i: i + 1
	i = (number + 1)
]
waitFor 1000

makeTitle wndname "Drawing Circles "
waitFor 500
clearImage wndname
i: 0
until [
	randomPoints
	randomColor
	thickness: first random [-1 1 0 2 3 4 5 6 7 8 9] ;-1 for filled form
	radius: random 200
	drawCircles wndname p1 radius r g b thickness
	i: i + 1
	i = (number + 1)
]
waitFor 1000
makeTitle wndname "Drawing Ellipses "
waitFor 500
clearImage wndname
i: 0
until [
	randomPoints
	p2/x: random 200
	p2/y: random 200
	randomColor
	angle: random 1000 * 0.180
	thickness: first random [-1 1 0 2 3 4 5 6 7 8 9] ;-1 for filled form
	drawEllipses wndname p1 p2 angle r g b thickness
	i: i + 1
	i = (number + 1)
]
waitFor 1000

makeTitle wndname "Drawing Polygons "
waitFor 500
clearImage wndname
i: 0
until [
	randomPoints
	randomArray
	randomColor
	thickness: first random [0 2 3 4 5 6 7 8 9 10]
	drawPolygons wndname p1 p2 p3 p4 p5 p6 r g b thickness
	i: i + 1
	i = (number + 1)
]
waitFor 1000

makeTitle wndname "Fill Convex Polygons "
waitFor 500
clearImage wndname
i: 0
until [
	randomArray
	randomColor
	thickness: first random [0 2 3 4 5 6 7 8 9 10]
	drawConvexPoly wndname p1 p2 p3 p4 p5 p6 r g b 
	i: i + 1
	i = (number + 1)
]
waitFor 1000

makeTitle wndname "Drawing Text "
waitFor 500
clearImage wndname
i: 0
until [
	randomPoints
	randomColor
	randomFont
	thickness: first random [1 2 3]
	drawText wndname p1 tmpFont hsf vsf r g b thickness
	i: i + 1
	i = (number + 1)
]
waitFor 1000

initSubstract
i: 1
until [
	randomColor
	drawSubstract wndname r g b
	i: i + 1
	i = 128
]
waitFor 1000

clearImage wndname
makeTitle wndname "Any Key to close "
waitFor 0
freeOpenCV
quit


