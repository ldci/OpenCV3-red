Red/System [
	Title:		"OpenCV ImgProc Types"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2015 F. Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;for standalone testing
;#include %../red/types_r.reds
;#include %../core/core_types_c.reds 

;**************************** Connected Component  **************************************
CvConnectedComp!: alias struct! 
[
    area		[float!]     ;area of the connected component
    value 		[cvScalar!]  ;average color of the connected component
    rect 		[CvRect!]    ;ROI of the component
    contour 	        [byte-ptr!]     ; CvSeqoptional component boundary (the contour might have child contours corresponding to the holes)
]


#enum SmoothMethod_c [
    CV_BLUR_NO_SCALE:   0
    CV_BLUR:            1
    CV_GAUSSIAN:        2
    CV_MEDIAN:          3
    CV_BILATERAL:       4
]

CV_GAUSSIAN_5x5:  7


#enum sFilters [
    CV_SCHARR:              -1
    CV_MAX_SOBEL_KSIZE:     7
]

#enum colorConvserion [
    CV_BGR2BGRA:        0
    CV_RGB2RGBA:    CV_BGR2BGRA
    CV_BGRA2BGR:    1
    CV_RGBA2RGB:    CV_BGRA2BGR
    CV_BGR2RGBA:    2
    CV_RGB2BGRA:    CV_BGR2RGBA
    CV_RGBA2BGR:    3
    CV_BGRA2RGB:    CV_RGBA2BGR
    CV_BGR2RGB:    4
    CV_RGB2BGR:    CV_BGR2RGB
    CV_BGRA2RGBA:    5
    CV_RGBA2BGRA:    CV_BGRA2RGBA
    CV_BGR2GRAY:    6
    CV_RGB2GRAY:    7
    CV_GRAY2BGR:    8
    CV_GRAY2RGB:    CV_GRAY2BGR
    CV_GRAY2BGRA:    9
    CV_GRAY2RGBA:    CV_GRAY2BGRA
    CV_BGRA2GRAY:    10
    CV_RGBA2GRAY:    11
    CV_BGR2BGR565:    12
    CV_RGB2BGR565:    13
    CV_BGR5652BGR:    14
    CV_BGR5652RGB:    15
    CV_BGRA2BGR565:    16
    CV_RGBA2BGR565:    17
    CV_BGR5652BGRA:    18
    CV_BGR5652RGBA:    19
    CV_GRAY2BGR565:        20
    CV_BGR5652GRAY:        21
    CV_BGR2BGR555:    22
    CV_RGB2BGR555:    23
    CV_BGR5552BGR:    24
    CV_BGR5552RGB:    25
    CV_BGRA2BGR555:    26
    CV_RGBA2BGR555:    27
    CV_BGR5552BGRA:    28
    CV_BGR5552RGBA:    29
    CV_GRAY2BGR555:    30
    CV_BGR5552GRAY:    31
    CV_BGR2XYZ:    32
    CV_RGB2XYZ:    33
    CV_XYZ2BGR:    34
    CV_XYZ2RGB:    35
    CV_BGR2YCrCb:    36
    CV_RGB2YCrCb:    37
    CV_YCrCb2BGR:    38
    CV_YCrCb2RGB:    39
    CV_BGR2HSV:    40
    CV_RGB2HSV:    41
    CV_BGR2Lab:    44
    CV_RGB2Lab:    45
    CV_BayerBG2BGR:    46
    CV_BayerGB2BGR:    47
    CV_BayerRG2BGR:    48
    CV_BayerGR2BGR:    49
    CV_BayerBG2RGB:    CV_BayerRG2BGR
    CV_BayerGB2RGB:    CV_BayerGR2BGR
    CV_BayerRG2RGB:    CV_BayerBG2BGR
    CV_BayerGR2RGB:    CV_BayerGB2BGR
    CV_BGR2Luv:    50
    CV_RGB2Luv:    51
    CV_BGR2HLS:    52
    CV_RGB2HLS:    53
    CV_HSV2BGR:    54
    CV_HSV2RGB:    55
    CV_Lab2BGR:        56
    CV_Lab2RGB:        57
    CV_Luv2BGR:        58
    CV_Luv2RGB:        59
    CV_HLS2BGR:        60
    CV_HLS2RGB:        61
    CV_BayerBG2BGR_VNG:        62
    CV_BayerGB2BGR_VNG:        63
    CV_BayerRG2BGR_VNG:        64
    CV_BayerGR2BGR_VNG:        65
    CV_BayerBG2RGB_VNG:        CV_BayerRG2BGR_VNG
    CV_BayerGB2RGB_VNG:        CV_BayerGR2BGR_VNG
    CV_BayerRG2RGB_VNG:        CV_BayerBG2BGR_VNG
    CV_BayerGR2RGB_VNG:        CV_BayerGB2BGR_VNG
    CV_BGR2HSV_FULL:         66
    CV_RGB2HSV_FULL:         67
    CV_BGR2HLS_FULL:         68
    CV_RGB2HLS_FULL:         69
    CV_HSV2BGR_FULL:         70
    CV_HSV2RGB_FULL:         71
    CV_HLS2BGR_FULL:         72
    CV_HLS2RGB_FULL:         73
    CV_LBGR2Lab:         74
    CV_LRGB2Lab:         75
    CV_LBGR2Luv:         76
    CV_LRGB2Luv:         77
    CV_Lab2LBGR:         78
    CV_Lab2LRGB:         79
    CV_Luv2LBGR:         80
    CV_Luv2LRGB:         81
    CV_BGR2YUV:             82
    CV_RGB2YUV:             83
    CV_YUV2BGR:             84
    CV_YUV2RGB:             85
    CV_BayerBG2GRAY:         86
    CV_BayerGB2GRAY:         87
    CV_BayerRG2GRAY:         88
    CV_BayerGR2GRAY:         89
    ;YUV 4:    2:    0 formats family
    CV_YUV2RGB_NV12:         90
    CV_YUV2BGR_NV12:         91
    CV_YUV2RGB_NV21:         92
    CV_YUV2BGR_NV21:         93
    CV_YUV420sp2RGB:         CV_YUV2RGB_NV21
    CV_YUV420sp2BGR:         CV_YUV2BGR_NV21
    CV_YUV2RGBA_NV12:         94
    CV_YUV2BGRA_NV12:         95
    CV_YUV2RGBA_NV21:         96
    CV_YUV2BGRA_NV21:         97
    CV_YUV420sp2RGBA:         CV_YUV2RGBA_NV21
    CV_YUV420sp2BGRA:         CV_YUV2BGRA_NV21
    CV_YUV2RGB_YV12:         98
    CV_YUV2BGR_YV12:         99
    CV_YUV2RGB_IYUV:         100
    CV_YUV2BGR_IYUV:         101
    CV_YUV2RGB_I420:         CV_YUV2RGB_IYUV
    CV_YUV2BGR_I420:         CV_YUV2BGR_IYUV
    CV_YUV420p2RGB:         CV_YUV2RGB_YV12
    CV_YUV420p2BGR:         CV_YUV2BGR_YV12
    CV_YUV2RGBA_YV12:         102
    CV_YUV2BGRA_YV12:         103
    CV_YUV2RGBA_IYUV:         104
    CV_YUV2BGRA_IYUV:         105
    CV_YUV2RGBA_I420:         CV_YUV2RGBA_IYUV
    CV_YUV2BGRA_I420:         CV_YUV2BGRA_IYUV
    CV_YUV420p2RGBA:         CV_YUV2RGBA_YV12
    CV_YUV420p2BGRA:         CV_YUV2BGRA_YV12
    CV_YUV2GRAY_420:         106
    CV_YUV2GRAY_NV21:         CV_YUV2GRAY_420
    CV_YUV2GRAY_NV12:         CV_YUV2GRAY_420
    CV_YUV2GRAY_YV12:         CV_YUV2GRAY_420
    CV_YUV2GRAY_IYUV:         CV_YUV2GRAY_420
    CV_YUV2GRAY_I420:         CV_YUV2GRAY_420
    CV_YUV420sp2GRAY:         CV_YUV2GRAY_420
    CV_YUV420p2GRAY:         CV_YUV2GRAY_420
    ;YUV 4:    2:    2 formats family
    CV_YUV2RGB_UYVY:         107
    CV_YUV2BGR_UYVY:         108
    ;CV_YUV2RGB_VYUY:         109
    ;CV_YUV2BGR_VYUY:         110
    CV_YUV2RGB_Y422:         CV_YUV2RGB_UYVY
    CV_YUV2BGR_Y422:         CV_YUV2BGR_UYVY
    CV_YUV2RGB_UYNV:         CV_YUV2RGB_UYVY
    CV_YUV2BGR_UYNV:         CV_YUV2BGR_UYVY
    CV_YUV2RGBA_UYVY:         111
    CV_YUV2BGRA_UYVY:         112
    ;CV_YUV2RGBA_VYUY:         113
    ;CV_YUV2BGRA_VYUY:         114
    CV_YUV2RGBA_Y422:         CV_YUV2RGBA_UYVY
    CV_YUV2BGRA_Y422:         CV_YUV2BGRA_UYVY
    CV_YUV2RGBA_UYNV:         CV_YUV2RGBA_UYVY
    CV_YUV2BGRA_UYNV:         CV_YUV2BGRA_UYVY
    CV_YUV2RGB_YUY2:         115
    CV_YUV2BGR_YUY2:         116
    CV_YUV2RGB_YVYU:         117
    CV_YUV2BGR_YVYU:         118
    CV_YUV2RGB_YUYV:         CV_YUV2RGB_YUY2
    CV_YUV2BGR_YUYV:         CV_YUV2BGR_YUY2
    CV_YUV2RGB_YUNV:         CV_YUV2RGB_YUY2
    CV_YUV2BGR_YUNV:         CV_YUV2BGR_YUY2
    CV_YUV2RGBA_YUY2:         119
    CV_YUV2BGRA_YUY2:         120
    CV_YUV2RGBA_YVYU:         121
    CV_YUV2BGRA_YVYU:         122
    CV_YUV2RGBA_YUYV:         CV_YUV2RGBA_YUY2
    CV_YUV2BGRA_YUYV:         CV_YUV2BGRA_YUY2
    CV_YUV2RGBA_YUNV:         CV_YUV2RGBA_YUY2
    CV_YUV2BGRA_YUNV:         CV_YUV2BGRA_YUY2

    CV_YUV2GRAY_UYVY:         123
    CV_YUV2GRAY_YUY2:         124
    ;CV_YUV2GRAY_VYUY:         CV_YUV2GRAY_UYVY
    CV_YUV2GRAY_Y422:         CV_YUV2GRAY_UYVY
    CV_YUV2GRAY_UYNV:         CV_YUV2GRAY_UYVY
    CV_YUV2GRAY_YVYU:         CV_YUV2GRAY_YUY2
    CV_YUV2GRAY_YUYV:         CV_YUV2GRAY_YUY2
    CV_YUV2GRAY_YUNV:         CV_YUV2GRAY_YUY2
    ; alpha premultiplication
    CV_RGBA2mRGBA:         125
    CV_mRGBA2RGBA:         126
    CV_RGB2YUV_I420:         127
    CV_BGR2YUV_I420:         128
    CV_RGB2YUV_IYUV:         CV_RGB2YUV_I420
    CV_BGR2YUV_IYUV:         CV_BGR2YUV_I420
    CV_RGBA2YUV_I420:         129
    CV_BGRA2YUV_I420:         130
    CV_RGBA2YUV_IYUV:         CV_RGBA2YUV_I420
    CV_BGRA2YUV_IYUV:         CV_BGRA2YUV_I420
    CV_RGB2YUV_YV12:         131
    CV_BGR2YUV_YV12:         132
    CV_RGBA2YUV_YV12:         133
    CV_BGRA2YUV_YV12:         134
    ; Edge-Aware Demosaicing
    CV_BayerBG2BGR_EA:         135
    CV_BayerGB2BGR_EA:         136
    CV_BayerRG2BGR_EA:         137
    CV_BayerGR2BGR_EA:         138
    CV_BayerBG2RGB_EA:         CV_BayerRG2BGR_EA
    CV_BayerGB2RGB_EA:         CV_BayerGR2BGR_EA
    CV_BayerRG2RGB_EA:         CV_BayerBG2BGR_EA
    CV_BayerGR2RGB_EA:         CV_BayerGB2BGR_EA
    CV_COLORCVT_MAX:         139
]

#enum interpolation [
    CV_INTER_NN:       0
    CV_INTER_LINEAR:    1
    CV_INTER_CUBIC:    2
    CV_INTER_AREA:      3
    CV_INTER_LANCZOS4:  4
]

#enum warping [
    CV_WARP_FILL_OUTLIERS:  8
    CV_WARP_INVERSE_MAP:    16
]

#enum MorphShapes_c [
    CV_SHAPE_RECT:   	0
    CV_SHAPE_CROSS:   	1
    CV_SHAPE_ELLIPSE:	2
    CV_SHAPE_CUSTOM:   	100 ;!< custom structuring element
]

#enum morpho [
    CV_MOP_ERODE:     	0
    CV_MOP_DILATE:     	1
    CV_MOP_OPEN:     	2
    CV_MOP_CLOSE:     	3
    CV_MOP_GRADIENT:    4
    CV_MOP_TOPHAT:     	5
    CV_MOP_BLACKHAT:    6
]

;spatial and central moments
CvMoments!: alias struct!
[
	;/* spatial moments */ all values should be double
    m00                  [float!]
    m10                  [float!]
    m01                  [float!]
    m20                  [float!]
    m11                  [float!]
    m02                  [float!]
    m30                  [float!]
    m21                  [float!]
    m12                  [float!]
    m03                  [float!]
    ; /* central moments */ 
    mu20                  [float!]
    mu11                  [float!]
    mu02                  [float!]
    mu30                  [float!]
    mu21                  [float!]
    mu12                  [float!]
    mu03                  [float!]
    inv_sqrt_m00          [float!]; /* m00 != 0 ? 1/sqrt(m00)0 */
]

;Hu invariants
CvHuMoments!: alias struct! [
    hu1                 [float!] 
    hu2                 [float!] 
    hu3                 [float!] 
    hu4                 [float!] 
    hu5                 [float!] 
    hu6                 [float!] 
    hu7                 [float!] 
]


#enum matching [
    CV_TM_SQDIFF:           0
    CV_TM_SQDIFF_NORMED:    1
    CV_TM_CCORR:            2
    CV_TM_CCORR_NORMED:     3
    CV_TM_CCOEFF:           4
    CV_TM_CCOEFF_NORMED:    5  
]

#enum retrieval [
    CV_RETR_EXTERNAL:     0
    CV_RETR_LIST:         1
    CV_RETR_CCOMP:        2
    CV_RETR_TREE:         3
    CV_RETR_FLOODFILL:    4
]

#enum approximation [
    CV_CHAIN_CODE:              0
    CV_CHAIN_APPROX_NONE:     	1
    CV_CHAIN_APPROX_SIMPLE:     2
    CV_CHAIN_APPROX_TC89_L1:    3
    CV_CHAIN_APPROX_TC89_KCOS:	4
]

#define *CvContourScanner [byte-ptr!]
    
CvChainPtReader!: alias struct! [
    CV_SEQ_READER_FIELDS
    code        [integer!];
    pt          [CvPoint!]; 
    deltas      [int-ptr!] ;char      deltas[8][2];
]

;initializes 8-element array for fast access to 3x3 neighborhood of a pixel
CV_INIT_3X3_DELTAS: func [step [integer!] nch [integer!] return: [int-ptr!] /local deltas arraySize mem][
        arraySize: 8 * size? integer!
        mem: allocate arraySize
	deltas: as pointer! [integer!] mem
	deltas/1: nch
	deltas/2: negate step + nch
	deltas/3: negate step
	deltas/4: negate step - nch
	deltas/5: negate nch
	deltas/6: step - nch
	deltas/7: step
	deltas/8: step + nch
	return deltas
]

#define CV_POLY_APPROX_DP 0

#enum ShapeMatchModes [
    CV_CONTOURS_MATCH_I1:	1;!< \f[I_1(A,B) =  \sum _{i=1...7}  \left |  \frac{1}{m^A_i} -  \frac{1}{m^B_i} \right |\f]
    CV_CONTOURS_MATCH_I2:	2;!< \f[I_2(A,B) =  \sum _{i=1...7}  \left | m^A_i - m^B_i  \right |\f]
    CV_CONTOURS_MATCH_I3:	3;!< \f[I_3(A,B) =  \max _{i=1...7}  \frac{ \left| m^A_i - m^B_i \right| }{ \left| m^A_i \right| }\f]
]

#enum shapeOrientation [
    CV_CLOCKWISE:           1
    CV_COUNTER_CLOCKWISE:   2
]

;finds a sequence of convexity defects of given contour

CvConvexityDefect: alias struct! [
    start		[cvPoint!]	;point of the contour where the defect begins 
    end			[cvPoint!]	;point of the contour where the defect ends 
    depth_point	        [cvPoint!]	;the farthest from the convex hull point within the defect
    depth		[float!]	;distance between the farthest point and the convex hull
]

#enum histoComparison[
    CV_COMP_CORREL:    		0
    CV_COMP_CHISQR:     	1
    CV_COMP_INTERSECT:     	2
    CV_COMP_BHATTACHARYYA:	3
    CV_COMP_HELLINGER:     	CV_COMP_BHATTACHARYYA
    CV_COMP_CHISQR_ALT:     4
    CV_COMP_KL_DIV:     	5
]

#enum distanceTransform[
    CV_DIST_MASK_3:         3
    CV_DIST_MASK_5:         5
    CV_DIST_MASK_PRECISE:   0
]

CV_DIST_LABEL_CCOMP:  0
CV_DIST_LABEL_PIXEL: 1

#enum dtM [
    CV_DIST_USER:     	-1  ;< User defined distance */
    CV_DIST_L1:     	1   ;< distance :      |x1-x2| + |y1-y2| */
    CV_DIST_L2:     	2   ;< the simple euclidean distance */
    CV_DIST_C:     	3   ;< distance :      max(|x1-x2||y1-y2|) */
    CV_DIST_L12:    	4   ;< L1-L2 metric: distance :      2(sqrt(1+x*x/2) - 1)) */
    CV_DIST_FAIR:     	5   ;< distance :      c^2(|x|/c-log(1+|x|/c)) c :      1.3998 */
    CV_DIST_WELSCH:     6   ;< distance :      c^2/2(1-exp(-(x/c)^2)) c :      2.9846 */
    CV_DIST_HUBER:	7   ;< distance :      |x|<c ? x^2/2 : c(|x|-c/2) c:     1.345 */
]

#enum threshold [
    CV_THRESH_BINARY:     	0  ;< value :      value > threshold ? max_value : 0       */
    CV_THRESH_BINARY_INV:     	1  ;< value :      value > threshold ? 0 : max_value       */
    CV_THRESH_TRUNC:     	2  ;< value :      value > threshold ? threshold : value   */
    CV_THRESH_TOZERO:     	3  ;< value :      value > threshold ? value : 0           */
    CV_THRESH_TOZERO_INV:     	4  ;< value :      value > threshold ? 0 : value           */
    CV_THRESH_MASK:     	7
    CV_THRESH_OTSU:     	8 ;< use Otsu algorithm to choose the optimal threshold value;
    CV_THRESH_TRIANGLE:     	16  ;< use Triangle algorithm to choose the optimal threshold value;
] 
   
#enum AdaptativeThreshold [
    CV_ADAPTIVE_THRESH_MEAN_C:		0
    CV_ADAPTIVE_THRESH_GAUSSIAN_C:	1
]


CV_FLOODFILL_FIXED_RANGE: (1 << 16)
CV_FLOODFILL_MASK_ONLY: (1 << 17)
CV_CANNY_L2_GRADIENT: (1 << 31)  

#enum hough [
    CV_HOUGH_STANDARD:		0
    CV_HOUGH_PROBABILISTIC:	1
    CV_HOUGH_MULTI_SCALE:	2
    CV_HOUGH_GRADIENT:		3
]
    
;Fast search data structures 
{CvFeatureTree;
CvLSH;
CvLSHOperations;}

