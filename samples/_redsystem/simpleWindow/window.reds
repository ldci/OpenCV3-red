Red/System [
	Title:		"OpenCV Tests: Creating  Window"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2014 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../../libs/red/types_r.reds          ; some specific structures for Red/S 
#include %../../../libs/core/types_c.reds         ; basic OpenCV types and structures
#include %../../../libs/imgproc/types_c.reds      ; image processing types and structures
#include %../../../libs/highgui/cvHighgui.reds      ; highgui functions


windowsName: "OpenCV Window [ESC to close Window]"
cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
cvResizeWindow windowsName 640 480
cvMoveWindow windowsName 200 200
cvWaitKey 0
cvDestroyAllWindows
