Red/System [
	Title:		"OpenCV Tests: Camera"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]




#include %../../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../../libs/imgproc/types_c.reds       ; image processing types and structures
#include %../../../libs/highgui/highgui.reds       ; highgui functions
#include %../../../libs/core/core.reds
#include %../../../libs/videoio/videoio.reds       ; to play with camera
#include %../../../libs/cvcapture/cvcapture.reds       ; to play with camera




print [videocapture lf]


; we use  default camera 
cvStartWindowThread ; separate window thread

windowsName: "Default Camera";  ; filename as title
;create opencv window
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO

rep: openCamera 0


;

print ["Capture: " rep lf]
print ["width: " getCameraProperty CV_CAP_PROP_FRAME_WIDTH lf]
print ["heigh: " getCameraProperty CV_CAP_PROP_FRAME_HEIGHT lf]
print ["fps: " getCameraProperty CV_CAP_PROP_FPS lf]



setCameraProperty  CV_CAP_PROP_FRAME_WIDTH 640.00
setCameraProperty  CV_CAP_PROP_FRAME_HEIGHT 480.00
setCameraProperty  CV_CAP_PROP_FPS 25.00


print ["Now camera is " lf]
print ["width: " getCameraProperty CV_CAP_PROP_FRAME_WIDTH lf ]
print ["heigh: " getCameraProperty CV_CAP_PROP_FRAME_HEIGHT lf]
print ["fps: " getCameraProperty CV_CAP_PROP_FPS lf]

img: readCamera
cvShowImage "Default Camera" as int-ptr! img

key:  27
foo: 0

; repeat until esc keypress
while [foo <> key] [
    img: readCamera
    cvShowImage "Default Camera" as int-ptr! img
    foo: cvWaitKey 40
]

cvDestroyAllWindows
releaseCamera
