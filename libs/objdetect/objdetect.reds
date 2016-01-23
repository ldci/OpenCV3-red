Red/System [
	Title:		"OpenCV 3.0.0 Binding: objdetect"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../libs/plateforms.reds            ; lib path according to os
#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structures


; OpenCV objdetect C Functions


;****************************************************************************************
;*                         Haar-like Object Detection functions                         *
;****************************************************************************************

CV_HAAR_MAGIC_VAL:    42500000h
CV_TYPE_NAME_HAAR:    "opencv-haar-classifier"
CV_HAAR_FEATURE_MAX:  3
CV_HAAR_DO_CANNY_PRUNING:    1
CV_HAAR_SCALE_IMAGE:         2
CV_HAAR_FIND_BIGGEST_OBJECT: 4
CV_HAAR_DO_ROUGH_SEARCH:     8

#define CvHidHaarClassifierCascade! byte-ptr!


CvHaarFeature!: alias struct! [
    tilted      [integer!]
    x 		[integer!]  ;x-coordinate of the left-most rectangle corner[s]
    y 		[integer!]  ;y-coordinate of the top-most or bottom-most corner[s]
    width 	[integer!]  ;width of the rectangle 
    height 	[integer!]  ;height of the rectangle
    weight      [float!]
]

CvHaarClassifier!: alias struct! [
    count           [integer!]
    haar_feature    [CvHaarFeature!]
    threshold       [float-ptr!]
    left            [int-ptr!]
    right           [int-ptr!]
    alpha           [float-ptr!]
]

CvHaarStageClassifier!: alias struct! [
    count           [integer!]
    threshold       [float!]
    classifier      [CvHaarClassifier!]
    _next           [integer!]
    _child          [integer!]
    _parent         [integer!]
]



CvHaarClassifierCascade!: alias struct! [
    flags               [integer!]
    count               [integer!]
    orig_window_size_x  [integer!]
    orig_window_size_y  [integer!]
    real_window_size_x  [integer!]
    real_window_size_y  [integer!]
    scale               [float!]
    stage_classifier    [CvHaarStageClassifier!]
    hid_cascade         [CvHidHaarClassifierCascade!]
]

CvAvgComp!: alias struct! [
    x 		[integer!]  ;x-coordinate of the left-most rectangle corner[s]
    y 		[integer!]  ;y-coordinate of the top-most or bottom-most corner[s]
    width 	[integer!]  ;width of the rectangle 
    height 	[integer!]  ;height of the rectangle
    neighbors   [integer!]
]

#import [
    objdetect importMode [
        cvHaarDetectObjects: "cvHaarDetectObjects" [
        "Loads haar classifier cascade from a directory"
            image               [CvArr!]		;!
            cascade             [CvHaarClassifierCascade!]		;!
            storage             [CvMemStorage!]		;!
            scale_factor        [float!]  ;CV_DEFAULT(1.1)
            min_neighbors       [integer!] ; CV_DEFAULT(3)
            flags               [integer!]  ;CV_DEFAULT(0)
            min_size_w          [integer!]  ; CvSize CV_DEFAULT(cvSize(0,0))
            min_size_h          [integer!]  ; CvSize CV_DEFAULT(cvSize(0,0))
            return:             [CvSeq!]		;! !  
        ]
        
        cvReleaseHaarClassifierCascade: "cvReleaseHaarClassifierCascade" [
        "Releases classifier"
            cascade             [struct! [ptr [CvHaarClassifierCascade!]]]
        ]
        
        cvSetImagesForHaarClassifierCascade: "cvSetImagesForHaarClassifierCascade" [
        "sets images for haar classifier cascade"
            cascade             [CvHaarClassifierCascade!]
            sum                 [CvArr!]		
            squm                [CvArr!]		
            tilted_sum          [CvArr!]
            scale               [float!]  
        ]
        
        cvRunHaarClassifierCascade: "cvRunHaarClassifierCascade" [
        "runs the cascade on the specified window "
            cascade             [CvHaarClassifierCascade!]
            pt_x                [integer!] ; CvPoint
            pt_y                [integer!] ; CvPoint
            start_stage         [integer!] ; CV_DEFAULT(0)
            return:             [integer!]       
        ]
    ];  end objdetect
]; end import 