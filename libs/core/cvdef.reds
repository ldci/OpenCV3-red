Red/System [
	Title:		"OpenCV Red Defs"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2015 F. Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

{****************************************************************************************\
*                                  Matrix type (CvMat)                                   *
\****************************************************************************************/}

; due to some limitations, original macros for matrices are replaced by functions if necessary
#define size_t 4

 CV_CN_MAX:     	    64
 CV_CN_SHIFT:			3
 CV_DEPTH_MAX:  	    (1 << CV_CN_SHIFT) ; ok 8
 CV_8U:   		        0
 CV_8S:   		        1
 CV_16U:  		        2
 CV_16S:  		        3
 CV_32S:  		        4
 CV_32F:  		        5
 CV_64F:  		        6
 CV_USRTYPE1: 	        7


 CV_MAT_DEPTH_MASK:               (CV_DEPTH_MAX - 1)


CV_MAT_DEPTH: func [flags [integer!] return: [integer!]][
    flags AND CV_MAT_DEPTH_MASK    
]


CV_MAKETYPE: func [depth [integer!] cn [integer!] return: [integer!] /local d][
    CV_MAT_DEPTH depth + ((cn - 1) << CV_CN_SHIFT)
]

; macros
#define CV_MAKE_TYPE                    [CV_MAKETYPE]
#define CV_8UC1	                        [CV_MAKETYPE CV_8U 1]
#define CV_8UC1                         [CV_MAKETYPE CV_8U 1]
#define CV_8UC2                         [CV_MAKETYPE CV_8U 2]
#define CV_8UC3                         [CV_MAKETYPE CV_8U 3]
#define CV_8UC4                         [CV_MAKETYPE CV_8U 4]
#define CV_8UC(n)                       [CV_MAKETYPE CV_8U (n)] ; example print [ CV_8UC(5) lf ]  -> 32
#define CV_8SC1                         [CV_MAKETYPE CV_8S 1]
#define CV_8SC2                         [CV_MAKETYPE CV_8S 2]
#define CV_8SC3                         [CV_MAKETYPE CV_8S 3]
#define CV_8SC4                         [CV_MAKETYPE CV_8S 4]
#define CV_8SC(n)                       [CV_MAKETYPE CV_8S (n)]
#define CV_16UC1                        [CV_MAKETYPE CV_16U 1]
#define CV_16UC2                        [CV_MAKETYPE CV_16U 2]
#define CV_16UC3                        [CV_MAKETYPE CV_16U 3]
#define CV_16UC4                        [CV_MAKETYPE CV_16U 4]
#define CV_16UC(n)                      [CV_MAKETYPE CV_16U (n)]
#define CV_16SC1                        [CV_MAKETYPE CV_16S 1]
#define CV_16SC2                        [CV_MAKETYPE CV_16S 2]
#define CV_16SC3                        [CV_MAKETYPE CV_16S 3]
#define CV_16SC4                        [CV_MAKETYPE CV_16S 4]
#define CV_16SC(n)                      [CV_MAKETYPE CV_16S(n)]
#define CV_32SC1                        [CV_MAKETYPE CV_32S 1]
#define CV_32SC2                        [CV_MAKETYPE CV_32S 2]
#define CV_32SC3                        [CV_MAKETYPE CV_32S 3]
#define CV_32SC4                        [CV_MAKETYPE CV_32S 4]
#define CV_32SC(n)                      [CV_MAKETYPE CV_32S (n)]
#define CV_32FC1                        [CV_MAKETYPE CV_32F 1]
#define CV_32FC2                        [CV_MAKETYPE CV_32F 2]
#define CV_32FC3                        [CV_MAKETYPE CV_32F 3]
#define CV_32FC4                        [CV_MAKETYPE CV_32F 4]
#define CV_32FC(n)                      [CV_MAKETYPE CV_32F (n)]
#define CV_64FC1                        [CV_MAKETYPE CV_64F 1]
#define CV_64FC2                        [CV_MAKETYPE CV_64F 2]
#define CV_64FC3                        [CV_MAKETYPE CV_64F 3]
#define CV_64FC4                        [CV_MAKETYPE CV_64F 4]
#define CV_64FC(n)                      [CV_MAKETYPE CV_64F (n)]

#define CV_MAT_CN_MASK                  [(CV_CN_MAX - 1 << CV_CN_SHIFT)]
#define CV_MAT_TYPE_MASK                [(CV_DEPTH_MAX * CV_CN_MAX - 1)]
#define CV_MAT_CONT_FLAG_SHIFT          14
#define CV_MAT_CONT_FLAG                [1 << CV_MAT_CONT_FLAG_SHIFT]
#define CV_SUBMAT_FLAG_SHIFT            15
#define CV_MAT_TEMP_FLAG_SHIFT          15
#define CV_MAT_TEMP_FLAG                [1 << CV_MAT_TEMP_FLAG_SHIFT]
#define CV_IS_SUBMAT(flags)             [((flags) & CV_MAT_SUBMAT_FLAG)]

; Macros to Func
CV_MAT_CN: func [flags [integer!] return: [integer!]][
    flags AND CV_MAT_CN_MASK >> CV_CN_SHIFT + 1     
]

CV_MAT_TYPE: func [flags [integer!] return: [integer!]][
    flags AND CV_MAT_TYPE_MASK   
]

CV_IS_MAT_CONT: func [flags [integer!] return: [integer!]][
    flags AND CV_MAT_CONT_FLAG   
]

CV_IS_TEMP_MAT: func [flags [integer!] return: [integer!]][
    flags AND CV_MAT_TEMP_FLAG  
]

;* size of each channel item 0x124489 = 1000 0100 0100 0010 0010 0001 0001 ~ array of sizeof(arr_type_elem) */
CV_ELEM_SIZE1: func [type [integer!] return: [integer!] /local tmp l ] [
    tmp: CV_MAT_CN type
    l: (size? integer!) << (28 or 138682897)
    l >> (CV_MAT_DEPTH type * 4) AND 15
]

;* 0x3a50 = 11 10 10 01 01 00 00 ~ array of log2(sizeof(arr_type_elem)) */
CV_ELEM_SIZE: func [type [integer!] return: [integer!] /local tmp tmp2 l][
	tmp: CV_MAT_CN type
        tmp2: size? size_t / 4 + 1
	l: CV_MAT_CN type << (tmp2 * 16384) OR 14928
	l >> (CV_MAT_DEPTH type * 2) AND 3
]

