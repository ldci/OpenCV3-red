Red/System [
	Title:		"OpenCV 3.0.0 Binding: imgcodecs"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../libs/platforms.reds            ; lib path according to os
#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structuresñ


; OpenCV imgcodecs C Functions



#enum cvimg [
    ;8bit, color or not
    CV_LOAD_IMAGE_UNCHANGED:        -1
    ;8bit, gray
    CV_LOAD_IMAGE_GRAYSCALE:        0
    ;?, color
    CV_LOAD_IMAGE_COLOR:			1
    
    CV_LOAD_IMAGE_ANYDEPTH:         2
    ;?, any color
    CV_LOAD_IMAGE_ANYCOLOR:         4
]

#enum imgwrite[
    CV_IMWRITE_JPEG_QUALITY:    		1
    CV_IMWRITE_JPEG_PROGRESSIVE:    		2
    CV_IMWRITE_JPEG_OPTIMIZE:    		3
    CV_IMWRITE_JPEG_RST_INTERVAL:   		4
    CV_IMWRITE_JPEG_LUMA_QUALITY:   		5
    CV_IMWRITE_JPEG_CHROMA_QUALITY: 		6
    CV_IMWRITE_PNG_COMPRESSION:    		16
    CV_IMWRITE_PNG_STRATEGY:       		17
    CV_IMWRITE_PNG_BILEVEL:    			18
    CV_IMWRITE_PNG_STRATEGY_DEFAULT:    	0
    CV_IMWRITE_PNG_STRATEGY_FILTERED:    	1
    CV_IMWRITE_PNG_STRATEGY_HUFFMAN_ONLY:       2
    CV_IMWRITE_PNG_STRATEGY_RLE:    		3
    CV_IMWRITE_PNG_STRATEGY_FIXED:    		4
    CV_IMWRITE_PXM_BINARY:    			32
    CV_IMWRITE_WEBP_QUALITY:    		64
]

#enum imgor [
  CV_CVTIMG_FLIP:       1
  CV_CVTIMG_SWAP_RB:    2
]

#import [
    cvImgcodecs importMode [
        ;iscolor can be a combination of above flags where CV_LOAD_IMAGE_UNCHANGED overrides the other flags
  	;using CV_LOAD_IMAGE_ANYCOLOR alone is equivalent to CV_LOAD_IMAGE_UNCHANGED
  	;unless CV_LOAD_IMAGE_ANYDEPTH is specified images are converted to 8bit
        cvLoadImage: "cvLoadImage" [
        "load image from file"
	    filename        [c-string!]
	    iscolor         [integer!]
	    return:         [IplImage!]
        ]
        
        cvLoadImageM: "cvLoadImage" [
        "Load matrice"
	    filename        [c-string!]
	    iscolor         [integer!] ;CV_DEFAULT(CV_LOAD_IMAGE_COLOR))
	    return:         [CvMat!]
	]
        
        cvSaveImage: "cvSaveImage" [
        "save image to file"
	    filename        [c-string!]
	    image           [CvArr!];  OK
            return:         [integer!]
	]
        
        cvDecodeImage: "cvDecodeImage" [
        "decode image stored in the buffer"
            buf             [Byte-ptr!]
            iscolor         [integer!] ;
            return:         [IplImage!]
        ]
        
        cvDecodeImageM: "cvDecodeImageM" [
        "decode image stored in the buffer"
            buf             [Byte-ptr!]
            iscolor         [integer!] ;
            return:         [CvMat!]
        ]
        
        cvEncodeImage: "cvEncodeImage" [
        "encode image and store the result as a byte vector (single-row 8uC1 matrix)"
            ext             [c-string!]
            image           [CvArr!]
            params          [int-ptr!] ; a pointer int* value
            return:         [CvMat!]
        ]
        
        cvConvertImage: "cvConvertImage" [
        "utility function: convert one image to another with optional vertical flip."
	    src             [CvArr!]
	    des             [CvArr!]
	    flags           [integer!] ;CV_DEFAULT(0)
	]
        
        cvHaveImageReader: "cvHaveImageReader" [
            filename        [c-string!]   
        ]
        
        cvHaveImageWriter: "cvHaveImageWriter" [
            filename        [c-string!]   
        ]
    ] ;end imgcodecs
] ;end import

