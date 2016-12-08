Red/System [
	Title:		"OpenCV 3.0.0 Binding: photo"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../libs/platforms.reds            ; lib path according to os
#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structuresñ




#enum InpaintingModes [
    CV_INPAINT_NS:      0
    CV_INPAINT_TELEA:   1
]
 
#import [
    cvPhoto importMode [
        cvInpaint: "cvInpaint" [
        "Inpaints the selected region in the image "
            src             [byte-ptr!]
            inpaint_mask    [byte-ptr!]
            dst             [byte-ptr!]
            inpaintRange    [float!]
            flags           [integer!]
        ]
    ]; end photo
] ;end import

