Red [
	Title:		"OpenCV Camera Test with C++ Functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#system [
	; import required OpenCV libraries
	#include %../../libs/include.reds ; all OpenCV  functions
	#include %../../libs/capture/c++cam.reds ; c++ camera exported functions
	img: 0; for our images
	count: 0
]



createCam: routine [device [integer!]] [
	openCamera device
	setCameraProperty  CV_CAP_PROP_FRAME_WIDTH 640.00
	setCameraProperty  CV_CAP_PROP_FRAME_HEIGHT 480.00
	setCameraProperty  CV_CAP_PROP_FPS 25.00
]

; read webcam frames
render: routine [return: [integer!]] [
	count: count + 1
	img: readCamera
	print [count " : "]
	cvShowImage "OpenCV Camera Test with Red and C++ Functions" as int-ptr! img
	return cvWaitKey 40
]

; free memory used by OpenCV
freeOpenCV: routine [return: [integer!]] [
	cvDestroyAllWindows
	releaseCamera
	return 0
]

;*********************** Main Program *******************************
createCam 0
rep: 0
until [
	rep: render ; read images from camera until esc key is pressed
	print stats
rep = escape
]
freeOpenCV
