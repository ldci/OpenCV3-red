Red/System [
	Title:		"OpenCV Tests: Camera"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../../libs/imgproc/types_c.reds       ; image processing types and structures
#include %../../../libs/highgui/cvHighgui.reds       ; highgui functions
#include %../../../libs/imgcodecs/cvImgcodecs.reds   ; basic image functions
#include %../../../libs/videoio/cvVideoio.reds       ; to play with camera

; we use  default camera 
cvStartWindowThread ; separate window thread

windowsName: "Default Camera";  ; filename as title
;create opencv window
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO

cam: cvCreateCameraCapture CV_CAP_ANY ;

print ["Capture: " cam lf]
print ["Domain: " cvGetCaptureDomain cam lf]
print ["width: " cvGetCaptureProperty cam CV_CAP_PROP_FRAME_WIDTH lf]
print ["heigh: " cvGetCaptureProperty cam CV_CAP_PROP_FRAME_HEIGHT lf]
print ["fps: " cvGetCaptureProperty cam CV_CAP_PROP_FPS lf]



cvSetCaptureProperty cam CV_CAP_PROP_FRAME_WIDTH 640.00
cvSetCaptureProperty cam CV_CAP_PROP_FRAME_HEIGHT 480.00
;cvSetCaptureProperty cam CV_CAP_PROP_FPS 25.00


print ["Now camera is " lf]
print ["width: " cvGetCaptureProperty cam CV_CAP_PROP_FRAME_WIDTH lf ]
print ["heigh: " cvGetCaptureProperty cam CV_CAP_PROP_FRAME_HEIGHT lf]



;get first image

image: cvRetrieveFrame cam ; get the first image
pimage: as int-ptr! image

key:  27
foo: 0

; repeat until esc keypress
while [foo <> key] [
    image: cvQueryFrame cam
    ;cvGrabFrame cam
    ;image: cvRetrieveFrame cam
    pimage: as int-ptr! image
    cvShowImage windowsName pimage
    foo: cvWaitKey 40
]

print ["Done. Any key to quit" lf]
cvWaitKey 0
cvDestroyAllWindows
