Red [
	Title:		"OpenCV Camera Test with C++ Functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:    	"BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#system [
	; OpenCV functions we need
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures`
	#include %../../libs/core/core.reds             ; OpenCV core functions
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/videoio/videoio.reds       ; to play with camera
	img: 0; for our images
]

createCam: routine [device [integer!]] [
	openCamera device
	setCameraProperty  CV_CAP_PROP_FRAME_WIDTH 640.00
	setCameraProperty  CV_CAP_PROP_FRAME_HEIGHT 480.00
	setCameraProperty  CV_CAP_PROP_FPS 25.00
]

; read webcam frames
render: routine [return: [integer!]] [
	img: readCamera
	cvShowImage "OpenCV Camera Test with Red and C++ Functions" as int-ptr! img
	return cvWaitKey 40
]

; free memory used by OpenCV
freeOpenCV: routine [return: [integer!]] [
	cvDestroyAllWindows
	releaseCamera
	return 0
]

createCam 0
rep: 0
until [
	rep: render ; read images from camera until esc key is pressed
rep = escape
]
freeOpenCV
