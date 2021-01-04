Red/System [
	Title:		"OpenCV Tests: tests matrices"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../libs/include.reds ; all OpenCV  functions
;64-bit matrix
mat1: declare CvMat!;
mat1: cvCreateMat 2 2  CV_64FC1  
print ["Is matrix? " CV_IS_MAT mat1 lf]
print ["CV_IS_MAT_HDR? " CV_IS_MAT_HDR mat1 lf]
print ["CV_IS_MAT_HDR_Z ? " CV_IS_MAT_HDR_Z mat1 lf]
print ["Is mask Array: " CV_IS_MASK_ARR Mat1 lf]
print ["mat/rows XOR mat/cols = 1: " CV_IS_MAT_CONST mat1 lf]
;print ["Depth: " cvCvToIplDepth CV_64FC1 lf] ; ???

print ["All matric values = 0.0" lf]
cvZero as int-ptr! mat1	 ;met la matrice à 0 avant le cvmset ligne par ligne

print ["Now reading data with cvmGet" lf]
print [ "0x0 " cvmGet mat1 0 0 lf] 		;row 0 col 0
print [ "0x1 " cvmGet mat1 0 1 lf] 		;row 0 col 0
print [ "1x0 " cvmGet mat1 1 0 lf] 		;row 0 col 0
print [ "1x1 " cvmGet mat1 1 1 lf] 		;row 0 col 0
releaseMat as int-ptr! mat1

mat1: cvCreateMat 2 2   CV_64FC1 ; CV_32FC1;
print ["Setting CV_64FC1 mat values with cvmSet" lf]
cvmSet mat1 0 0  10.0						;row 0 col 0
cvmSet mat1 0 1  200.0						;row 0 col 1
cvmSet mat1 1 0  3000.0						;row 1 col 0
cvmSet mat1 1 1  40000.0 				    ;row 1 col 1

print ["Now reading data with cvmGet" lf]
print [ "0x0 " cvmGet mat1 0 0 lf] 		;row 0 col 0
print [ "0x1 " cvmGet mat1 0 1 lf] 		;row 0 col 0
print [ "1x0 " cvmGet mat1 1 0 lf] 		;row 0 col 0
print [ "1x1 " cvmGet mat1 1 1 lf] 		;row 0 col 0

releaseMat as int-ptr! mat1

;32-bit matrix
mat1: cvCreateMat 3 3  CV_32FC1;
print ["Setting CV_32FC1 mat values with cvmSet" lf]
cvmSet mat1 0 0  1.0						;row 0 col 0
cvmSet mat1 0 1  2.0						;row 0 col 1
cvmSet mat1 0 2  3.0
cvmSet mat1 1 0  4.0						
cvmSet mat1 1 1  5.0 				    	
cvmSet mat1 1 2  6.0
cvmSet mat1 2 0  7.0						
cvmSet mat1 2 1  8.0 				    	
cvmSet mat1 2 2  9.0


print ["Now reading data with cvmGet" lf]
print [ "0x0 " cvmGet mat1 0 0 lf] 		
print [ "0x1 " cvmGet mat1 0 1 lf] 		
print [ "0x2 " cvmGet mat1 0 2 lf]
print [ "1x0 " cvmGet mat1 1 0 lf] 		
print [ "1x1 " cvmGet mat1 1 1 lf] 		
print [ "1x2 " cvmGet mat1 1 2 lf]
print [ "2x0 " cvmGet mat1 2 0 lf] 		
print [ "2x1 " cvmGet mat1 2 1 lf] 		
print [ "2x2 " cvmGet mat1 2 2 lf]

releaseMat as int-ptr! mat1

;Matrices comparaison

mat1: cvCreateMat 2 2  CV_64FC1
cvZero as int-ptr! mat1
mat2: cvCloneMat mat1

mat3: cvCreateMat 3 3  CV_32FC1 
print ["Matrix comparaison" lf]
print ["CV_ARE_TYPES_EQ ? " CV_ARE_TYPES_EQ mat1 mat2 lf]
print ["CV_ARE_CNS_EQ ? " CV_ARE_CNS_EQ mat1 mat2 lf]
print ["CV_ARE_DEPTHS_EQ ? " CV_ARE_DEPTHS_EQ mat1 mat2 lf]
print ["CV_ARE_SIZES_EQ ? " CV_ARE_SIZES_EQ mat1 mat2 lf]


print ["Matrix comparaison" lf]
print ["CV_ARE_TYPES_EQ ? " CV_ARE_TYPES_EQ mat1 mat3 lf]
print ["CV_ARE_CNS_EQ ? " CV_ARE_CNS_EQ mat1 mat3 lf]
print ["CV_ARE_DEPTHS_EQ ? " CV_ARE_DEPTHS_EQ mat1 mat3 lf]
print ["CV_ARE_SIZES_EQ ? " CV_ARE_SIZES_EQ mat1 mat3 lf]

releaseMat as int-ptr! mat1
releaseMat as int-ptr! mat2
releaseMat as int-ptr! mat3

; test cvMat

mat1: cvMat 3 3 CV_8UC1 null








