Red/System [
	Title:		"OpenCV 3.0.0 Binding: core"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../libs/plateforms.reds            ; lib path according to os
#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structures


; OpenCV core C Functions



CV_AUTOSTEP:             7FFFFFFFh
CV_MAX_ARR:              10
CV_NO_DEPTH_CHECK:       1
CV_NO_CN_CHECK:          2
CV_NO_SIZE_CHECK:        4
CV_CMP_EQ:   0
CV_CMP_GT:   1
CV_CMP_GE:   2
CV_CMP_LT:   3
CV_CMP_LE:   4
CV_CMP_NE:   5
CV_CHECK_RANGE:    1
CV_CHECK_QUIET:    2
CV_RAND_UNI:      0
CV_RAND_NORMAL:   1
CV_SORT_EVERY_ROW: 0
CV_SORT_EVERY_COLUMN: 1
CV_SORT_ASCENDING: 0
CV_SORT_DESCENDING: 16
CV_GEMM_A_T: 1
CV_GEMM_B_T: 2
CV_GEMM_C_T: 4
CV_SVD_MODIFY_A:   1
CV_SVD_U_T:        2
CV_SVD_V_T:        4
CV_LU:  0
CV_SVD: 1
CV_SVD_SYM: 2
; Calculates covariation matrix for a set of vectors transpose([v1-avg, v2-avg,...]) * [v1-avg,v2-avg,...] 
CV_COVAR_SCRAMBLED:   0
; [v1-avg, v2-avg,...] * transpose([v1-avg,v2-avg,...]) 
CV_COVAR_NORMAL:    1
; do not calc average (i.e. mean vector) - use the input vector instead (useful for calculating covariance matrix by parts) 
CV_COVAR_USE_AVG:   2
; scale the covariance matrix coefficients by number of the vectors 
 CV_COVAR_SCALE:    4
; all the input vectors are stored in a single matrix, as its rows 
CV_COVAR_ROWS:      8
; all the input vectors are stored in a single matrix, as its columns 
CV_COVAR_COLS:     16
CV_PCA_DATA_AS_ROW: 0 
CV_PCA_DATA_AS_COL: 1
CV_PCA_USE_AVG: 2
CV_C:           1
CV_L1:           2
CV_L2:           4
CV_NORM_MASK:    7
CV_RELATIVE:     8
CV_DIFF:         16
CV_MINMAX:       32
CV_DIFF_C:       (CV_DIFF or CV_C)
CV_DIFF_L1:      (CV_DIFF or CV_L1)
CV_DIFF_L2:      (CV_DIFF or CV_L2)
CV_RELATIVE_C:   (CV_RELATIVE or CV_C)
CV_RELATIVE_L1:  (CV_RELATIVE or CV_L1)
CV_RELATIVE_L2:  (CV_RELATIVE or CV_L2)
CV_REDUCE_SUM: 0
CV_REDUCE_AVG: 1
CV_REDUCE_MAX: 2
CV_REDUCE_MIN: 3
CV_DXT_FORWARD:  0
CV_DXT_INVERSE:  1
CV_DXT_SCALE:    2 ; divide result by size of array 
CV_DXT_INV_SCALE: (CV_DXT_INVERSE + CV_DXT_SCALE)
CV_DXT_INVERSE_SCALE: CV_DXT_INV_SCALE
CV_DXT_ROWS:     4 ;transform each row individually 
CV_DXT_MUL_CONJ: 8 ;conjugate the second argument of cvMulSpectrums
CV_FRONT: 1
CV_BACK: 0
CV_GRAPH_VERTEX:        1
CV_GRAPH_TREE_EDGE:     2
CV_GRAPH_BACK_EDGE:     4
CV_GRAPH_FORWARD_EDGE:  8
CV_GRAPH_CROSS_EDGE:    16
CV_GRAPH_ANY_EDGE:      30
CV_GRAPH_NEW_TREE:      32
CV_GRAPH_BACKTRACKING:  64
CV_GRAPH_OVER:          -1
CV_GRAPH_ALL_ITEMS:    -1

;flags for graph vertices and edges */
CV_GRAPH_ITEM_VISITED_FLAG:  		1 << 30
CV_GRAPH_SEARCH_TREE_NODE_FLAG:   	1 << 29
CV_GRAPH_FORWARD_EDGE_FLAG:       	1 << 28

CvNArrayIterator!: alias struct! [
    count       	[integer!]
    dims        	[integer!]
    size_w      	[integer!]; CvSize
    size_h      	[integer!]
    ptr         	[byte-ptr!] ;ptr[CV_MAX_ARR]
    stack       	[integer!]
    ;hdr         	[CvMatND!]
    hdr_type        [integer!]              ;CvMatND signature (CV_MATND_MAGIC_VAL), element type and flags
	hdr_dims		[integer!]              ;number of array dimensions
	hdr_refcount	[int-ptr!]              ;underlying data reference counter (a integer pointer)
	hdr_refcount2  	[integer!]
	hdr_data		[float-ptr!]                ; in C an union [ uchar* ptr;short* s;int* i;float* fl;double* db;]
	hdr_dim			[struct! [
                            hdr_size [integer!]
                            hdr_step [integer!]
                    	]
                    ]
]

CvGraphScanner!: alias struct! [
    ;vtx         		[CvGraphVtx!]
    vtx_flags			[integer!]
    vtx_next			[int-ptr!] 
    ;dst         		[CvGraphVtx!]
    dst_flags			[integer!]
    dst_next			[int-ptr!] 
    ;edge        		[CvGraphEdge!] 
    edge_flags			[integer!];        
    edge_weight			[integer!];    
    edge_next			[int-ptr!] ; pointer struct CvGraphEdge*  
    edge_vtx			[int-ptr!] ; pointer struct CvGraphVtx* 
    graph       		[CvGraph!] ; TBTested
    ;stack_       		[CvSeq!]
    stack_flags			[integer!]    ;micsellaneous flags    
    stack_header_size	[integer!]    ;size of sequence header 
	stack_h_prev		[int-ptr!]    ;struct previous sequence     
    stack_h_next		[int-ptr!]    ;struct next sequence
    stack_v_prev		[int-ptr!]    ;struct 2nd previous sequence 
    stack_v_next		[int-ptr!]    ;struct 2nd next sequence
    stack_total			[integer!]    ;total number of elements
    stack_elem_size		[integer!]    ;size of sequence element in bytes 
    stack_block_max		[byte-ptr!]   ; maximal bound of the last block
    stack_ptr			[byte-ptr!]   ;current write pointer
    stack_delta_elems	[integer!]    ;how many elements allocated when the seq grows
    stack_storage		[int-ptr!]    ;where the seq is stored
    stack_free_blocks	[int-ptr!]    ;free blocks list 
    stack_first			[int-ptr!]    ;pointer to the first sequence block 
    stack_index       	[integer!]
    stack_mask        	[integer!] 
]

CvTreeNodeIterator!: alias struct! [
    node        [byte-ptr!]
    level       [integer!]
    max_level   [integer!]
]

#import [
    core importMode [
        cvCreateImageHeader: "cvCreateImageHeader"[
        "Allocates and initializes IplImage header"
            width 		[integer!] ;CvSize/width
            height 		[integer!] ;CvSize/height
            depth		[integer!]
            channels            [integer!]
            return:             [IplImage!] 
        ]
        
        cvInitImageHeader: "cvInitImageHeader" [
        "Inializes IplImage header"
            image		[IplImage!] ;structure considered as pointer
            width 		[integer!] ;CvSize/width
            height 		[integer!] ;CvSize/height
            depth		[integer!]
            channels	        [integer!]
            origin		[integer!];CV_DEFAULT(0)
            align		[integer!];CV_DEFAULT(4)
            return:             [IplImage!]  
        ]
        
        cvCreateImage: "cvCreateImage" [
        "Creates IPL image (header and data). Can  be used by highgui!!!"
            width 		[integer!] ;CvSize/width
            height 		[integer!] ;CvSize/height
            depth 		[integer!]
            channels 	        [integer!]
            return: 	        [IplImage!] ; returns an iplImage structure
        ]
        
        cvReleaseImageHeader: "cvReleaseImageHeader" [
        "Releases (i.e. deallocates) IPL image header"
            image		[double-byte-ptr!]
        ]
        cvReleaseImage: "cvReleaseImage" [
        "Releases IPL image header and data"
            image	[double-byte-ptr!] ;IplImage** image (use as byte-ptr! IplImage since IplImage is still a pointer ( a struct))
        ]
        
        cvCloneImage: "cvCloneImage" [
        "Creates a copy of IPL image (widthStep may differ) "
            image		[IplImage!]
            return: 	        [IplImage!] 
        ]
        
        cvSetImageCOI: "cvSetImageCOI" [
        "Sets a Channel Of Interest (only a few functions support COI) - use cvCopy to extract the selected channel and/or put it back"
            image		[IplImage!]
            coi			[integer!]
        ]
        cvGetImageCOI: "cvGetImageCOI" [
        "Retrieves image Channel Of Interest"
            image		[IplImage!]
            return: 	[integer!] 
        ]
        
        cvSetImageROI: "cvSetImageROI" [
        "Sets image ROI (region of interest) (COI is not changed)"
            image		[IplImage!]
            rect_x		[integer!]  ; CvRect not a pointer
            rect_y		[integer!]
            rect_w		[integer!]
            rect_h		[integer!]
        ]
        cvResetImageROI: "cvResetImageROI" [
        "Resets image ROI and COI"
            image		[IplImage!]
        ]
        cvGetImageROI:"cvGetImageROI" [
            image		[IplImage!]    
            return: 	        [CvRect!] ; not a pointer 
        ]
        
        cvCreateMatHeader: "cvCreateMatHeader" [
        "Allocates and initalizes CvMat header"
            rows	[integer!]
            cols	[integer!]
            type	[integer!]
            return:	[CvMat!] 
        ]
        
        cvInitMatHeader: "cvInitMatHeader" [
        "Initializes CvMat header"
            mat	        [CvMat!]
            rows	[integer!]
            cols	[integer!]
            type	[integer!]
            data        [byte-ptr!] ; void null 
            step	[integer!] ; CV_DEFAULT(CV_AUTOSTEP)
        ]
        
        cvCreateMat: "cvCreateMat"[
        "Allocates and initializes CvMat header and allocates data"
            rows	[integer!]
            cols	[integer!]
            type 	[integer!]
            return:	[CvMat!]
        ]
        
        cvReleaseMat: "cvReleaseMat" [
        "Releases CvMat header and deallocates matrix data (reference counting is used for data)"
            **mat	[double-byte-ptr!] ;use a byte-ptr CVmat! double pointer
        ]
        
        cvCloneMat: "cvCloneMat" [
        "Creates an exact copy of the input matrix (except, may be, step value)"
            mat	        [CvMat!]
            return:	[CvMat!]
        ]
        
        cvGetSubRect: "cvGetSubRect" [
        "Makes a new matrix from <rect> subrectangle of input array No data is copied"
            arr			[CvArr!] ; cvArr* : pointer to generic array
            submat		[CvMat!]
            rect_x		[integer!]  ; CvRect not a pointer
    	    rect_y		[integer!]
    	    rect_w		[integer!]
    	    rect_h		[integer!]
            return:	        [CvMat!]    
        ]
        
        cvGetRows: "cvGetRows" [
        "Selects row span of the input array: arr(start_row:delta_row:end_row (end_row is not included into the span)"
            arr			[CvArr!] ; cvArr* : pointer to generic array
            submat		[CvMat!]
            start_row           [integer!]
            end_row		[integer!]
            delta_row	        [integer!] ; CV_DEFAULT(1)
            return:	        [CvMat!]     
        ]
        cvGetCols: "cvGetCols" [
            arr			[CvArr!] ; cvArr* : pointer to generic array
            submat		[CvMat!]
            start_col           [integer!]
            end_col		[integer!]
            return:	        [CvMat!]     
        ]
        
        cvGetDiag: "cvGetDiag" [
        {Select a diagonal of the input array. (diag = 0 means the main diagonal, >0 means a diagonal above the main one,
        <0 - below the main one). The diagonal will be represented as a column (nx1 matrix)}    
            arr			[CvArr!] ; cvArr* : pointer to generic array
            submat		[CvMat!]
            diag		[integer!];CV_DEFAULT(0)
            return:	        [CvMat!] 
        ]
        
        cvScalarToRawData: "cvScalarToRawData" [
        "low-level scalar <-> raw data conversion functions"
            scalar		[CvScalar!]	
            data		[byte-ptr!]; *void
            type		[integer!]
            extend_to_12	[integer!];CV_DEFAULT(0)
        ]
        cvRawDataToScalar: "cvRawDataToScalar"[
        "low-level raw data conversion <-> scalar  functions"
            data		[byte-ptr!]; *void
            type		[integer!]
            scalar		[CvScalar!]
        ]
        
        cvCreateMatNDHeader: "cvCreateMatNDHeader" [
        "Allocates and initializes CvMatND header"
            dims		[integer!]
            sizes		[int-ptr!] ;int* sizes
            type		[integer!]
            return:		[CvMatND!]
        ]
        cvCreateMatND: "cvCreateMatND" [
        "Allocates and initializes CvMatND header and allocates data"
            dims		[integer!]
            sizes		[int-ptr!] ;int* sizes
            type		[integer!]
            return:		[CvMatND!]
        ]
        cvInitMatNDHeader: "cvInitMatNDHeader" [
        "Initializes preallocated CvMatND header"
            mat			[CvMatND!]
            dims		[integer!]
            sizes		[int-ptr!] ;int* sizes
            type		[integer!]
            data		[byte-ptr!]; *void  CV_DEFAULT(NULL)
            return:		[CvMatND!]
        ]
        
        cvCloneMatND: "cvCloneMatND" [
        "Creates a copy of CvMatND (except, may be, steps)"
            mat		         [CvMatND!]
            return:	         [CvMatND!]
        ]
        
        cvCreateSparseMat: "cvCreateSparseMat" [
        "Allocates and initializes CvSparseMat header and allocates data"
            dims		 [integer!]
            sizes		 [int-ptr!] ;int* sizes
            type		 [integer!]
            return:		 [CvSparseMat!]
        ]
        
        cvReleaseSparseMat: "cvReleaseSparseMat" [
        "Releases CvSparseMat"
            mat                 [double-byte-ptr!] ;CvSparseMat** mat double pointer
        ]
        
        cvCloneSparseMat: "cvCloneSparseMat" [
        "Creates a copy of CvSparseMat (except, may be, zero items)"
            mat 	        [CvSparseMat!]
            return:             [CvSparseMat!]
        ]
        
        cvInitSparseMatIterator: "cvInitSparseMatIterator" [
        "Initializes sparse array iterator (returns the first node or NULL if the array is empty)"
            mat 		    [CvSparseMat!]
            mat_iterator	    [CvSparseMatIterator!]
            return: 		    [CvSparseNode!]
        ]
        
        cvInitNArrayIterator: "cvInitNArrayIterator" [
        {Initializes iterator that traverses through several arrays simulteneously.
        (the function together with cvNextArraySlice is used for N-ari element-wise operations)}
            count		        [integer!]
            arrs			[CvArr!] ; double pointer
            mask			[CvArr!] ;; double pointer
            stubs			[CvMatND!]
            array_iterator	        [CvNArrayIterator!];CvNArrayIterator!
            flags			[integer!] ;CV_DEFAULT(0)
            return:			[integer!] 
        ]
        
        cvNextNArraySlice: "cvNextNArraySlice" [
        "Returns zero value if iteration is finished, non-zero (slice length) otherwise"
            array_iterator	        [CvNArrayIterator!]
            return:			[integer!] 
        ]
        
        cvGetElemType: "cvGetElemType" [
        "Returns type of array elements: CV_8UC1 ... CV_64FC4 ... "
            arr			[CvArr!]
            return:		[integer!]
        ]
        
        cvGetDims: "cvGetDims" [
        "Retrieves number of an array dimensions and optionally sizes of the dimensions"
            arr			[CvArr!]
            sizes		[int-ptr!] ;CV_DEFAULT(NULL) 
            return:		[integer!]   
        ]
        
        cvGetDimSize: "cvGetDimSize" [
        {Retrieves size of a particular array dimension.
        For 2d arrays cvGetDimSize(arr,0) returns number of rows (image height) and cvGetDimSize(arr,1) returns number}
            arr			[CvArr!]
            index		[int-ptr!]; CV_DEFAULT(NULL)
            return:		[integer!]
        ]
        
        cvPtr1D: "cvPtr1D" [
            arr			[CvArr!]
            idx0		[integer!]; 
            type		[int-ptr!]; CV_DEFAULT(NULL)
            return:		[byte-ptr!]
        ]
        
        cvPtr2D: "cvPtr2D" [
            arr			[CvArr!]
            idx0		[integer!]; 
            idx1		[integer!];
            type		[int-ptr!]; CV_DEFAULT(NULL)
            return:		[byte-ptr!]           
        ]
        cvPtr3D: "cvPtr3D" [
            arr			[CvArr!]
            idx0		[integer!]; 
            idx1		[integer!];
            idx2		[integer!];
            type		[int-ptr!]; CV_DEFAULT(NULL) 
            return:		[byte-ptr!]           
        ]
        
        cvPtrND: "cvPtrND" [
        {For CvMat or IplImage number of indices should be 2
        (row index (y) goes first, column index (x) goes next).
        For CvMatND or CvSparseMat number of infices should match number of <dims> and
        indices order should match the array dimension order}
            arr			[CvArr!]
            idx			[integer!]; 
            type                [int-ptr!]; CV_DEFAULT(NULL) 
            create_node		[int-ptr!];CV_DEFAULT(1)
            precalc_hashval	[int-ptr!]; CV_DEFAULT(NULL)
            return:		[byte-ptr!] 
        ]
        
        ;value = arr(idx0,idx1,...)
        cvGet1D: "cvGet1D" [
            arr		        [CvArr!]
            idx0		[integer!]
            ;return:		[CvScalar!] ; not a pointer
			return:		[byte-ptr!]
        ]
        cvGet2D: "cvGet2D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            return:		[CvScalar!] ; not a pointer	          
        ]
        cvGet3D: "cvGet3D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            idx2		[integer!]
            return:		[CvScalar!] ; not a pointer	          
        ]
        cvGetND: "cvGetND" [
            arr		        [CvArr!]
            idx 		[pointer! [integer!]] 
            return:		[CvScalar!] ; not a pointer	
        ]
        
        ;for 1-channel arrays
        cvGetReal1D: "cvGetReal1D" [
            arr		        [CvArr!]
            idx0			[integer!]
            return:         [float!]
        ]
        
        cvGetReal2D: "cvGetReal2D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            return:             [float!]
        ]
        cvGetReal3D: "cvGetReal3D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            idx2		[integer!]
            return:             [float!]
        ]
        cvGetRealND: "cvGetRealND" [
            arr		        [CvArr!]
            idx 		[pointer! [integer!]] 
            return:		[float!]	
        ]
        ;arr(idx0,idx1,...) = value
        cvSet1D: "cvSet1D" [
            arr		        [CvArr!]
            idx0		[integer!]
            v0                  [float!]  ;CvScalar!
            v1                  [float!]
            v2                  [float!]
            v3                  [float!] 
        ]
        
        cvSet2D: "cvSet2D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            v0                  [float!]  ;CvScalar!
            v1                  [float!]
            v2                  [float!]
            v3                  [float!] 
        ]
        cvSet3D: "cvSet3D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            idx2		[integer!]
            v0                  [float!]  ;CvScalar!
            v1                  [float!]
            v2                  [float!]
            v3                  [float!] 
        ]
        cvSetND: "cvSetND" [
            arr		        [CvArr!]
            idx 		[int-ptr!] 
            v0                  [float!]  ;CvScalar!
            v1                  [float!]
            v2                  [float!]
            v3                  [float!] 	
        ]
        
        cvSetReal1D: "cvSetReal1D" [
            arr		        [CvArr!]
            idx0		[integer!]
            value		[float!]
        ]
        cvSetReal2D: "cvSetReal2D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            value		[float!]
        ]
        cvSetReal3D: "cvSetReal3D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            idx2		[integer!]
            value		[float!]
        ]
        cvSetRealND: "cvSetRealND" [
            arr		        [CvArr!]
            idx 		[int-ptr!] 
            value		[float!]
        ]
        
        cvClearND: "cvClearND" [
        "clears element of ND dense array, in case of sparse arrays it deletes the specified node"
            arr		        [CvArr!]
            idx 		[int-ptr!]
        ]
        
        cvGetMat: "cvGetMat" [
        "Converts CvArr (IplImage or CvMat,...) to CvMat."
            arr		        [CvArr!]
            header		[CvMat!]
            coi			[int-ptr!];CV_DEFAULT(NULL)
            allowND		[integer!];CV_DEFAULT(0)
            return: 	        [CvMat!]
        ]
        
        cvGetImage: "cvGetImage" [
        "Converts CvArr (IplImage or CvMat) to IplImage"
            arr		        [CvArr!]
            image_header 	[IplImage!]
            return: 		[IplImage!]	
        ]
        cvReshapeMatND: "cvReshapeMatND" [
        "Changes a shape of multi-dimensional array."
            arr		        [CvArr!]
            sizeof_header	[integer!]
            header		[CvArr!]
            new_cn		[integer!]
            new_dims		[integer!]
            new_sizes		[int-ptr!]
            return: 		[CvArr!]
        ]
        
        cvReshape: "cvReshape" [
            arr		        [CvArr!]
            header		[CvMat!]
            new_cn		[integer!]
            new_rows		[integer!];CV_DEFAULT(0)
            return: 		[CvMat!]   
        ]
        
        cvRepeat: "cvRepeat" [
        "Repeats source 2d array several times in both horizontal and vertical direction to fill destination array"
            src		        [CvArr!]
            dest		[CvArr!]
        ]
        
        cvCreateData: "cvCreateData" [
            arr		 [CvArr!]
        ]
        
        
        cvReleaseData: "cvReleaseData" [
	"releases array data"
	    arr		[double-byte-ptr!] ;  pointer to CvArr!
	]
        
         cvSetData: "cvSetData" [
        "Attaches user data to the array header"
            arr		        [CvArr!]
            data	        [byte-ptr!];void* pointer 
            step	        [integer!]
        ]
        
        ;Retrieves raw data of CvMat, IplImage or CvMatND.
        ;In the latter case the function raises an error if the array can not be represented as a matrix
        
        cvGetRawData: "cvGetRawData" [
        "Retrieves raw data of CvMat, IplImage or CvMatND"
            arr		        [CvArr!]
            data	        [byte-ptr!];uchar** pointer 
            step	        [int-ptr!] ;CV_DEFAULT(NULL)
            roi_size            [CvSize!]
            ;roi_size_w		[integer!];CV_DEFAULT(NULL) ; CvSize/width
            ;roi_size_h		[integer!];CV_DEFAULT(NULL) ; CvSize/height
        ]
        
        cvGetSize: "cvGetSize" [
        "Returns width and height of array in elements"
            arr		        [CvArr!]
            return:         [CvSize!] ; not a pointer
        ]
        
        
         cvCopy: "cvCopy" [
        "Copies source array to destination array"
            src		    [CvArr!]
            dest		[CvArr!]
            mask		[CvArr!]   
        ]
        
        cvSet: "cvSet" [
        "Sets all or masked elements of input array to the same value"
            arr			[CvArr!]
            v0			[float!]; CvScalar not a pointer
            v1			[float!]
            v2			[float!]
            v3			[float!]
            mask		[CvArr!] ; CV_DEFAULT(NULL) 
        ]
        
        cvSetZero: "cvSetZero" [
        "Clears all the array elements (sets them to 0)"
            arr			[CvArr!]
        ]
        
        cvZero: "cvSetZero" [
        "Clears all the array elements (sets them to 0)"
            arr			[CvArr!]
        
        ]
        
        cvSplit: "cvSplit" [
        "Splits a multi-channel array into the set of single-channel arrays or extracts particular [color] plane"
            src			[CvArr!]
            dst0		[CvArr!]
            dst1		[CvArr!]
            dst2		[CvArr!]
            dst3		[CvArr!]       
        ]
        
        cvMerge: "cvMerge" [
        "Merges a set of single-channel arrays into the single multi-channel array or inserts one particular [color] plane to the array"
            src0		[CvArr!]
            src1		[CvArr!]
            src2		[CvArr!]
            src3		[CvArr!]
            dst 		[CvArr!] 
        ]
        
        cvMixChannels: "cvMixChannels" [
        "Copies several channels from input arrays to certain channels of output arrays"
            src			[CvArr!] 
            src_count	        [integer!]
            dst			[CvArr!] 
            dst_count	        [integer!]
            from_to		[int-ptr!]
            pair_count 	        [integer!]	   
        ]
        
        ;Performs linear transformation on every source array element: dst(x,y,c) = scale*src(x,y,c)+shift.
        ;Arbitrary combination of input and output array depths are allowed (number of channels must be the same), thus the function can be used for type conversion
        
        cvConvertScale: "cvConvertScale" [
        "Performs linear transformation on every source array element"
            src			[CvArr!] 
            dst			[CvArr!] 
            scale		[float!];CV_DEFAULT(1)
            shift		[float!];CV_DEFAULT(0)
        ]
        
        cvCvtScale: "cvConvertScale" [
        "Performs linear transformation on every source array element"
            src			[CvArr!] 
            dst			[CvArr!] 
            scale		[float!];CV_DEFAULT(1)
            shift		[float!];CV_DEFAULT(0)
        ]
        cvScale: "cvConvertScale" [
        "Performs linear transformation on every source array element"
            src			[CvArr!] 
            dst			[CvArr!] 
            scale		[float!];CV_DEFAULT(1)
            shift		[float!];CV_DEFAULT(0)
        ]
        
       
        cvConvertScaleAbs: "cvConvertScaleAbs" [
        "Performs linear transformation on every source array element"
            src			[CvArr!] 
            dst			[CvArr!] 
            scale		[float!];CV_DEFAULT(1)
            shift		[float!];CV_DEFAULT(0)
        ]
        
        cvCvtScaleAbs: "cvConvertScaleAbs" [
        "Performs linear transformation on every source array element"
            src			[CvArr!] 
            dst			[CvArr!] 
            scale		[float!];CV_DEFAULT(1)
            shift		[float!];CV_DEFAULT(0)
        ]
        
       
        
        cvCheckTermCriteria: "cvCheckTermCriteria" [
        "Checks termination criteria validity and sets eps to default_eps (if it is not set)."
            criteria			[CvTermCriteria!]
            default_eps			[float!]
            default_max_iters 	        [integer!]
            return: 			[CvTermCriteria!]  
        ]
        
        cvAdd:"cvAdd" [
        "dst(mask) = src1(mask) + src2(mask)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        
        cvAddS: "cvAddS" [
        "dst(mask) = src(mask) + value"
            src 			[CvArr!]
           ; value			[_CvScalar]
           v0               [float!]    
           v1               [float!]
           v2               [float!]
           v3               [float!]
           dst				[CvArr!]
           mask				[CvArr!];CV_DEFAULT(NULL)  
        ]
        cvSub: "cvSub" [
        "dst(mask) = src1(mask) - src2(mask)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        
        cvSubRS: "cvSubRS" [
        "dst(mask) = value - src(mask)"
            src 			[CvArr!]
            v0              [float!]    
            v1              [float!]
            v2              [float!]
            v3              [float!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)  
        ]
        
        cvMul: "cvMul" [
        "dst(idx) = src1(idx) * src2(idx) * scale (scaled element-wise multiplication of 2 arrays)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            scale			[float!];CV_DEFAULT(1)
        ]
        
        cvDiv: "cvDiv" [
        "element-wise division/inversion with scaling: dst(idx) = src1(idx) * scale / src2(idx) or dst(idx) = scale / src2(idx) if src1 == 0"    
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            scale			[float!];CV_DEFAULT(1)   
        ]
        
        cvScaleAdd: "cvScaleAdd" [
        "dst = src1 * scale + src2"
            src1			[CvArr!]
            ;scale			[_CvScalar]
            v0                          [float!]    
            v1                          [float!]
            v2                          [float!]
            v3                          [float!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        
        cvAddWeighted: "cvAddWeighted" [
        "dst = src1 * alpha + src2 * beta + gamma"
            src1			[CvArr!]
            alpha			[float!]
            src2			[CvArr!]
            beta		        [float!]
            gamma			[float!]
            dst				[CvArr!]
        ]
        cvDotProduct: "cvDotProduct" [
        "result = sum_i(src1(i) * src2(i)) (results for all channels are accumulated together)"
            src1			[CvArr!]
            src 			[CvArr!]
            return:                     [float!]
        ]
        
        cvAnd: "cvAnd" [
        "dst(idx) = src1(idx) & src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvAndS: "cvAndS" [
        "dst(idx) = src(idx) & value"
            src1			[CvArr!]
            v0              [float!]  ;CvScalar  
            v1              [float!]
            v2              [float!]
            v3              [float!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvOr: "cvOr" [
        "dst(idx) = src1(idx) | src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvOrS: "cvOrS" [
        "dst(idx) = src(idx) | value"
            src1			[CvArr!]
            v0              [float!]  ;CvScalar  
            v1              [float!]
            v2              [float!]
            v3              [float!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvxOr: "cvXor" [
        "dst(idx) = src1(idx) ^ src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvXorS: "cvXorS" [
        "dst(idx) = src(idx) ^ value"
            src1			[CvArr!]
            v0              [float!]  ;CvScalar  
            v1              [float!]
            v2              [float!]
            v3              [float!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvNot: "cvNot" [
        "dst(idx) = ~src(idx)"
            src		                [CvArr!]
            dst				[CvArr!]
        ]
        
        cvInRange: "cvInRange" [
        "dst(idx) = lower <= src(idx) < upper"
            src		                [CvArr!]
            lower                       [CvArr!]
            upper                       [CvArr!]
            dst				[CvArr!]    
        ]
        
        cvInRangeS: "cvInRangeS" [
        "dst(idx) = lower <= src(idx) < upper"
            src		                [CvArr!]
            ;lower                      [_CvScalar]
            lower_v0                    [float!]    
            lower_v1                    [float!]
            lower_v2                    [float!]
            lower_v3                    [float!]
            ;upper                      [_CvScalar]
            upper_v0                    [float!]    
            upper_v1                    [float!]
            upper_v2                    [float!]
            upper_v3                    [float!]
            dst				[CvArr!]    
        ]
        
         cvCmp: "cvCmp" [
        "The comparison operation support single-channel arrays only. Destination image should be 8uC1 or 8sC1 dst(idx) = src1(idx) _cmp_op_ src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            cmp_op			[integer!]
        ]
        
        cvCmpS: "cvCmpS" [
        "dst(idx) = src1(idx) _cmp_op_ value"
            src 			[CvArr!]
            value			[float!]
            dst				[CvArr!]
            cmp_op			[integer!]
        ]
        
        cvMin: "cvMin" [
        "dst(idx) = min(src1(idx),src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        
        cvMax: "cvMax" [
        "dst(idx) = max(src1(idx),src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        
        cvMinS: "cvMinS" [
        "dst(idx) = min(src(idx),value)"
            src 			[CvArr!]
            value			[float!]
            dst				[CvArr!]
        ]
        
        cvMaxS: "cvMaxS" [
        "dst(idx) = max(src(idx),value)"
            src 			[CvArr!]
            value			[float!]
            dst				[CvArr!]
        ]
        
        cvAbsDiff: "cvAbsDiff" [
        "dst(x,y,c) = abs(src1(x,y,c) - src2(x,y,c)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        
        cvAbsDiffS: "cvAbsDiffS" [
        "dst(x,y,c) = abs(src(x,y,c) - value(c)"
            src 			[CvArr!]
            dst				[CvArr!]
            v0              [float!]  ;CvScalar  
            v1              [float!]
            v2              [float!]
            v3              [float!]
        ]
        
        cvCartToPolar: "cvCartToPolar" [
        " ;Does cartesian->polar coordinates conversion. Either of output components (magnitude or angle) is optional"
            x					[CvArr!]
            y					[CvArr!]
            magnitude			[CvArr!]
            angle				[CvArr!]; CV_DEFAULT(NULL)
            angle_in_degrees	[integer!]; CV_DEFAULT(0)   
        ]
        
        cvPolarToCart: "cvPolarToCart" [
        "Does polar->cartesian coordinates conversion.Either of output components (magnitude or angle) is optional.If magnitude is missing it is assumed to be all 1's"
            magnitude			[CvArr!]
            angle				[CvArr!]
            x					[CvArr!]
            y					[CvArr!]
            angle_in_degrees	[integer!]; CV_DEFAULT(0) 
        ]
        
        cvPow: "cvPow" [
        "Does powering: dst(idx) = src(idx)^power"
            src		            [CvArr!]
            dst					[CvArr!]  
            _power				[float!]
        ]
        
        ;WARNING: Overflow is not handled yet. Underflow is handled. Maximal relative error is ~7e-6 for single-precision input
        cvExp: "cvExp" [
        "Does exponention: dst(idx) = exp(src(idx))."
            src		        [CvArr!]
            dst				[CvArr!]  
            
        ]
        
        cvLog: "cvLog" [
        "Calculates natural logarithms: dst(idx) = log(abs(src(idx)))."
            src		        [CvArr!]
            dst				[CvArr!]  
        ]
        
        cvFastArctan: "cvFastArctan" [
        "Fast arctangent calculation"
            y	                    [float!]
            x	[                   float!]
            return:                 [float!]
        ]
        cvCbrt: "cvCbrt" [
        "Fast cubic root calculation"
            value	            [float!]
        ]
        
        cvCheckArr: "cvCheckArr" [
            arr			[CvArr!]
            flags		[integer!] ;CV_DEFAULT(0)
            min_val 	[float!]; CV_DEFAULT(0) 
            max_val 	[float!];CV_DEFAULT(0))
		]
		
		cvCheckArray: "cvCheckArr" [
            arr			[CvArr!]
            flags		[integer!] ;CV_DEFAULT(0)
            min_val 	[float!]; CV_DEFAULT(0) 
            max_val 	[float!];CV_DEFAULT(0))
		]
        
        cvRandArr: "cvRandArr" [
            rng			   	[byte-ptr!] ; function pointer to CvRNG funct
            arr				[CvArr!]
            dist_type		[integer!]
            ;param1			[_CvScalar]
            param1_v0       [float!]    
            param1_v1                    [float!]
            param1_v2                    [float!]
            param1_v3                    [float!]
            ;param2			[_CvScalar]
            param2_v0                    [float!]    
            param2_v1                    [float!]
            param2_v2                    [float!]
            param2_v3                    [float!]
        ]
        cvRandShuffle: "cvRandShuffle" [
            mat				[CvArr!]		
            rng				[byte-ptr!] ; function pointer to CvRNG funct
            iter_factor		        [float!]; CV_DEFAULT(1.0)
        ]
        
        cvSort: "cvSort" [
            src             [CvArr!]
            dst             [CvArr!]
            idxmat          [CvArr!]
            flags           [integer!]
            
        ]
        
        cvSolveCubic: "cvSolveCubic" [
        "Finds real roots of a cubic equation"
            coeffs			[CvMat!]
            roots			[CvMat!]
            return: 		[integer!]
        ]
        
        cvSolvePoly: "cvSolvePoly" [
        "Finds real roots of a cubic equation"
            coeffs		[CvMat!]
            roots2		[CvMat!]
            maxiter             [integer!]; CV_DEFAULT(20)
            fig                 [integer!];CV_DEFAULT(100)
        ]
        
         cvCrossProduct: "cvCrossProduct" [
        "Calculates cross product of two 3d vectors"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        
        cvGEMM: "cvGEMM" [
        "Extended matrix transform: dst = alpha*op(A)*op(B) + beta*op(C), where op(X) is X or X^T"
            src1			[CvArr!]
            src2			[CvArr!]
            alpha			[float!]
            src3			[CvArr!]
            beta			[float!]
            dst				[CvArr!]
            tABC			[integer!];CV_DEFAULT(0)	
        ]
        
        cvMatMulAddEx: "cvGEMM" [
        "Extended matrix transform: dst = alpha*op(A)*op(B) + beta*op(C), where op(X) is X or X^T"
            src1			[CvArr!]
            src2			[CvArr!]
            alpha			[float!]
            src3			[CvArr!]
            beta			[float!]
            dst				[CvArr!]
            tABC			[integer!];CV_DEFAULT(0)	
        ]
        
        
        cvTransform: "cvTransform" [
        "transforms each element of source array and stores resultant vectors in destination array"
            src			[CvArr!]
            dst			[CvArr!]
            transmat	[CvMat!]
            shiftvec	[CvMat!] ;CV_DEFAULT(NULL)
        ]
        
        cvMatMulAddS: "cvTransform" [
        "transforms each element of source array and stores resultant vectors in destination array"
            src			[CvArr!]
            dst			[CvArr!]
            transmat	[CvMat!]
            shiftvec	[CvMat!] ;CV_DEFAULT(NULL)
        ]
        
        cvPerspectiveTransform: "cvPerspectiveTransform" [
        "Does perspective transform on every element of input array "
            src			[CvArr!]
            dst			[CvArr!]
            mat			[CvMat!]
        ]
        
        cvMulTransposed: "cvMulTransposed" [
        "Calculates (A-delta)*(A-delta)^T (order=0) or (A-delta)^T*(A-delta) (order=1)"
            src			[CvArr!]
            dst			[CvArr!]
            order		[integer!]
            delta		[CvArr!] ;CV_DEFAULT(NULL)
            scale		[float!];CV_DEFAULT(1.)
        ]
        
        cvTranspose: "cvTranspose" [
        "Tranposes matrix. Square matrices can be transposed in-place"
            src			[CvArr!]
            dst			[CvArr!]
        ]
        
        cvT: "cvTranspose" [
        "Tranposes matrix. Square matrices can be transposed in-place"
            src			[CvArr!]
            dst			[CvArr!]
        ]
        
        cvFlip: "cvFlip" [
        "cvFlip(src) flips images vertically and sequences horizontally (inplace)"
            src			[CvArr!]
            dst			[CvArr!] ;CV_DEFAULT(NULL)
            flip_mode	        [integer!]
        ]
        
        cvMirror: "cvFlip" [
        "cvFlip(src) flips images vertically and sequences horizontally (inplace)"
            src			[CvArr!]
            dst			[CvArr!] ;CV_DEFAULT(NULL)
            flip_mode	        [integer!]
        ]
       
        cvSVD: "cvSVD" [
        "Performs Singular Value Decomposition of a matrix"
            A			[CvArr!]
            W			[CvArr!]
            U			[CvArr!]
            V			[CvArr!]
            flags		[integer!]
        ]
        
        cvSVBkSb: "cvSVBkSb" [
        "Performs Singular Value Back Substitution (solves A*X = B): flags must be the same as in cvSVD"
            W			[CvArr!]
            U			[CvArr!]
            V			[CvArr!]
            B			[CvArr!]
            flags		[integer!]
        ]
        
        cvInvert: "cvInvert"[
        "Inverts matrix"
            src			[CvArr!]
            dst			[CvArr!]
            method		[integer!]
            return: 	[float!];CV_DEFAULT(CV_LU)
        ]
        cvSolve: "cvSolve" [
        "Solves linear system (src1)*(dst) = (src2) (returns 0 if src1 is a singular and CV_LU method is used)"
            src1		[CvArr!]
            src2		[CvArr!]
            dst			[CvArr!]
            method		[integer!];CV_DEFAULT(CV_LU)
            return: 	[integer!]
        ]
        
        cvDet: "cvDet" [
        "Calculates determinant of input matrix"
            mat			[CvArr!]
            return: 	[float!]
        ]
        
        cvTrace: "cvTrace" [
        "Calculates trace of the matrix (sum of elements on the main diagonal)"
            mat			[CvArr!]
            return: 	[CvScalar!] ; not a pointer but 4 decimal
        ]
        
        cvEigenVV: "cvEigenVV" [
        "Finds eigen values and vectors of a symmetric matrix"
            mat			[CvArr!]
            evects		[CvArr!]
            evals		[CvArr!]
            eps			[float!];CV_DEFAULT(0)
        ]
        
        cvSetIdentity: "cvSetIdentity" [
        "Makes an identity matrix (mat_ij = i == j)"
            mat			[CvArr!]
            v0          [float!]  ;CvScalar  CV_DEFAULT(cvRealScalar 1 
            v1          [float!]
            v2          [float!]
            v3          [float!] ;
        ]
        
        cvRange: "cvRange" [
        "Fills matrix with given range of numbers"
            mat			[CvMat!]
            start		[float!]
            end			[float!]
        ]
        
        cvCalcCovarMatrix: "cvCalcCovarMatrix" [
            vects		[CvArr!]
            count		[integer!]
            cov_mat		[CvArr!]
            avg			[CvArr!]
            flags		[integer!]
        ]
        
         cvCalcPCA: "cvCalcPCA" [
            data		[CvArr!]
            mean		[CvArr!]
            eigenvals	        [CvArr!]
            eigenvects	        [CvArr!]
            flags		[integer!]
        ]
        
        cvProjectPCA: "cvProjectPCA" [
            data		[CvArr!]
            mean		[CvArr!]
            eigenvects	        [CvArr!]
            result	        [CvArr!]
        ]
        
        cvBackProjectPCA: "cvBackProjectPCA" [
            proj		[CvArr!]
            mean		[CvArr!]
            eigenvects	        [CvArr!]
            result	        [CvArr!]
        ]
        
        cvMahalanobis: "cvMahalanobis" [
        "Calculates Mahalanobis(weighted) distance"
            vec1		[CvArr!]
            vec2		[CvArr!]
            mat			[CvArr!]
            return: 	        [float!]
        ]
        
        cvSum: "cvSum" [
        " Finds sum of array elements "
            arr		[CvArr!]
            return:	[CvScalar!] ; not a pointer 
        ]
        
        cvCountNonZero: "cvCountNonZero" [
        "Calculates number of non-zero pixels"
            arr		[CvArr!]
            return:	[integer!]
        ]
        
        cvAvg: "cvAvg" [
        "Calculates mean value of array elements"
            arr		[CvArr!]
            mask	[CvArr!];CV_DEFAULT(NULL)
            return:	[CvScalar!] ; not a pointer 
        ]
        
        cvAvgSdv: "cvAvgSdv" [
        "Calculates mean and standard deviation of pixel values"
            arr		[CvArr!]
            mean	[CvScalar!]
            std_dev     [CvScalar!]
            mask	[CvArr!];CV_DEFAULT(NULL)
        ]
        
         cvMinMaxLoc: "cvMinMaxLoc" [
        " Finds global minimum, maximum and their positions"
            arr			[CvArr!]
            min_val		[float-ptr!]
            max_val		[float-ptr!]
            min_loc		[CvPoint!];CV_DEFAULT(NULL)
            max_loc		[CvPoint!];CV_DEFAULT(NULL)
            mask	 	[CvArr!];CV_DEFAULT(NULL)
        ]
        
        cvNorm: "cvNorm" [
        " Finds norm, difference norm or relative difference norm for an array (or two arrays)"
            arr1			[CvArr!]
            arr2			[CvArr!];CV_DEFAULT(NULL)
            norm_type 		[integer!]; CV_DEFAULT(CV_L2
            mask	 		[CvArr!];CV_DEFAULT(NULL)
            return:			[float!]
        ]
        
        cvNormalize: "cvNormalize" [
            src			        [CvArr!]
            dst			        [CvArr!]
            a			        [float!];CV_DEFAULT(1.)
            b			        [float!];CV_DEFAULT(0.)
            norm_type	        [integer!];CV_DEFAULT(CV_L2)
            mask	 	        [CvArr!];CV_DEFAULT(NULL)
        ]
        
        cvReduce: "cvReduce" [
            src			[CvArr!]
            dst			[CvArr!]
            dim 		[integer!];CV_DEFAULT(-1)
            op 			[integer!];CV_DEFAULT(CV_REDUCE_SUM) )
        ]
        
        cvDFT: "cvDFT" [
        "Discrete Fourier Transform: complex->complex,real->ccs (forward),ccs->real (inverse)"
            src				[CvArr!]
            dst				[CvArr!]
            flags			[integer!]
            nonzero_rows 	        [integer!];CV_DEFAULT(0)
        ]
        
        cvFFT: "cvDFT" [
        "Discrete Fourier Transform: complex->complex,real->ccs (forward),ccs->real (inverse)"
            src				[CvArr!]
            dst				[CvArr!]
            flags			[integer!]
            nonzero_rows 	        [integer!];CV_DEFAULT(0)
        ]
        
       
        cvMulSpectrums: "cvMulSpectrums" [
        "Multiply results of DFTs: DFT(X)*DFT(Y) or DFT(X)*conj(DFT(Y))"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            flags			[integer!]
        ]
        
        cvGetOptimalDFTSize: "cvGetOptimalDFTSize"[
        "Finds optimal DFT vector size >= size0"
            size0		[integer!]
            return:		[integer!]
        ]
        
        cvDCT: "cvDCT" [
        "Discrete Cosine Transform"
            src				[CvArr!]
            dst				[CvArr!]
            flags			[integer!]
        ]
        
         cvSliceLength: "cvSliceLength" [
        "Calculates length of sequence slice (with support of negative indices)"
            slice_start_index         [integer!] ;_CvSlice
            slice_end_index           [integer!]
            seq			      [CvSeq!]
            return:		      [integer!]
        ]
        
        cvCreateMemStorage: "cvCreateMemStorage" [
        "Creates new memory storage. block_size == 0 means that default,somewhat optimal size, is used (currently, it is 64K)"
            block_size 		[integer!];CV_DEFAULT(0)
            return:		    [CvMemStorage!]
        ]
        
        cvCreateChildMemStorage: "cvCreateChildMemStorage"  [
        "Creates a memory storage that will borrow memory blocks from parent storage"
            parent	 		[CvMemStorage!]
            return:			[CvMemStorage!]
        ]
        
        cvReleaseMemStorage: "cvReleaseMemStorage" [
        {Releases memory storage. All the children of a parent must be released before the parent.
        A child storage returns all the blocks to parent when it is released"}
            storage	 		[double-byte-ptr!] ;CvMemStorage** (address?)
        ]
        
        cvClearMemStorage: "cvClearMemStorage" [
        {Clears memory storage. This is the only way(!!!) (besides cvRestoreMemStoragePos)
        to reuse memory allocated for the storage - cvClearSeq,cvClearSet ...
        do not free any memory.A child storage returns all the blocks to the parent when it is cleared}
            storage	 		[CvMemStorage!] ;CvMemStorage*
        ]
        
        
        cvSaveMemStoragePos: "cvSaveMemStoragePos" [
        "Remember a storage free memory position"
            storage	 		[CvMemStorage!] 
            pos		 		[CvMemStorage!]
        ]
        
        cvRestoreMemStoragePos: "cvRestoreMemStoragePos" [
         "Restore a storage free memory position"
            storage	 		[CvMemStorage!]
            pos		 		[CvMemStorage!]
        ]
        
        cvMemStorageAlloc: "cvMemStorageAlloc" [
        "Allocates continuous buffer of the specified size in the storage"
            storage	 		[CvMemStorage!]
            t_size		 	[integer!] 
        ]
        
        cvMemStorageAllocString: "cvMemStorageAllocString" [
            storage	 		[CvMemStorage!] 
            ptr		 	        [byte-ptr!] ; pointer
            len				[integer!];CV_DEFAULT(-1)
            return:			[c-string!]
        ]
        
        cvCreateSeq: "cvCreateSeq" [
        "Creates new empty sequence that will reside in the specified storage "
            seq_flags		        [integer!]	
            header_size		        [integer!]
            elem_size		        [integer!]
            storage			[CvMemStorage!]
            return: 		        [CvSeq!]
        ]
        cvSetSeqBlockSize: "cvSetSeqBlockSize" [
        "changes default size (granularity) of sequence blocks. The default size is ~1Kbyte"
            seq				[CvSeq!]
            delta_elems		        [integer!]
        ]
        
        cvSeqPush: "cvSeqPush" [
        "Adds new element to the end of sequence. Returns pointer to the element"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            return: 		        [byte-ptr!]
        ]
        
        cvSeqPushFront: "cvSeqPushFront" [
        "Adds new element to the beginning of sequence. Returns pointer to it"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            return: 		        [byte-ptr!]
        ]
        
        cvSeqPop: "cvSeqPop" [
        "Removes the last element from sequence and optionally saves it"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
        ]
        
        cvSeqPopFront: "cvSeqPopFront" [
        "Removes the first element from sequence and optioanally saves it"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
        ]
        
        cvSeqPushMulti: "cvSeqPushMulti" [
        "Adds several new elements to the end of sequence"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            count			[integer!]
            in_front		        [integer!]; CV_DEFAULT(0)
        ]
        
        cvSeqPopMulti: "cvSeqPopMulti" [
        "Removes several elements from the end of sequence and optionally saves them"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            count			[integer!]
            in_front		        [integer!]; CV_DEFAULT(0)
        ]
        
        cvSeqInsert: "cvSeqInsert" [
        "Inserts a new element in the middle of sequence.cvSeqInsert(seq,0,elem) == cvSeqPushFront(seq,elem)"
            seq				[CvSeq!]
            before_index	        [integer!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            return: 		        [byte-ptr!]
        ]
        
        cvSeqRemove: "cvSeqRemove" [
        "Removes specified sequence element"
            seq				[CvSeq!]
            index			[integer!]
        ]
        
        cvClearSeq: "cvClearSeq" [
        "Removes all the elements from the sequence."
            seq				[CvSeq!]
        ]
        
        cvGetSeqElem: "cvGetSeqElem" [
        {Retrives pointer to specified sequence element.Negative indices are supported and mean
        counting from the end (e.g -1 means the last sequence element)}
            seq				[CvSeq!]
            index			[integer!]
            return:			[byte-ptr!]
        ]
        
        cvSeqElemIdx: "cvSeqElemIdx" [
        "Calculates index of the specified sequence element. Returns -1 if element does not belong to the sequence "
            seq				[CvSeq!]
            element			[byte-ptr!] ; pointer to void*
            return:			[CvSeqBlock!]; CV_DEFAULT(NULL) address?
        ]
        
        cvStartAppendToSeq: "cvStartAppendToSeq" [
        "Initializes sequence writer. The new elements will be added to the end of sequence"
            seq				[CvSeq!]
	    writer			[CvSeqWriter!]
        ]
        
        CvStartWriteSeq: "CvStartWriteSeq" [
        "Combination of cvCreateSeq and cvStartAppendToSeq"
            seq_flags		        [integer!]
            header_size		        [integer!]
            elem_size		        [integer!]
            storage			[CvMemStorage!]
            writer			[CvSeqWriter!]
        ]
        
        cvEndWriteSeq: "cvEndWriteSeq" [
        {Closes sequence writer, updates sequence header and returns pointer to the resultant sequence
        (which may be useful if the sequence was created using cvStartWriteSeq))}
            writer			[CvSeqWriter!]
            return: 		        [CvSeq!]
        ]
        
        cvFlushSeqWriter: "cvFlushSeqWriter" [
        " Updates sequence header. May be useful to get access to some of previously written elements via cvGetSeqElem or sequence reader"
           writer			[CvSeqWriter!]
        ]
        
        cvStartReadSeq: "cvStartReadSeq" [
        "Initializes sequence reader. The sequence can be read in forward or backward direction"
            seq				[CvSeq!]
            reader			[CvSeqReader!]
            _reverse                    [integer!];CV_DEFAULT(0)
        ]
        
        cvGetSeqReaderPos: "cvGetSeqReaderPos" [
        "Returns current sequence reader position (currently observed sequence element)"
            reader			[CvSeqReader!]
            return:			[integer!]
        ]
        cvSetSeqReaderPos: "cvSetSeqReaderPos" [
        "Changes sequence reader position. It may seek to an absolute or to relative to the current position"
            reader			[CvSeqReader!]
            index			[integer!]
            is_relative 	        [integer!];CV_DEFAULT(0))
        ]
        
        cvCvtSeqToArray: "cvCvtSeqToArray" [
        "Copies sequence content to a continuous piece of memory "
            seq				[CvSeq!]
            elements		        [byte-ptr!]; pointer
            slice		 	[CvSlice!];CV_DEFAULT(CV_WHOLE_SEQ)
        ] 
        ;Creates sequence header for array.
        ;After that all the operations on sequences that do not alter the conten can be applied to the resultant sequence
        
        cvMakeSeqHeaderForArray: "cvMakeSeqHeaderForArray" [
            seq_type			[integer!]
            header_size		 	[integer!]
            elem_size		 	[integer!]
            elements			[byte-ptr!]; pointer
            total			[integer!]
            seq				[CvSeq!]
            block			[CvSeqBlock!]
            return:			[CvSeq!]
        ]
        
        cvSeqSlice: "cvSeqSlice" [
        "Extracts sequence slice (with or without copying sequence elements)"
            seq				[CvSeq!]
            slice_start                 [integer!]
            slice_end                   [integer!]
            storage			[CvMemStorage!];CV_DEFAULT(NULL)
            copy_data			[integer!];CV_DEFAULT(NULL)
        ]
        
        cvSeqRemoveSlice: "cvSeqRemoveSlice" [
        "Removes sequence slice"
            seq				[CvSeq!]
            slice_start_index           [integer!] ;_CvSlice
            slice_end_index             [integer!]
        ]
        
        cvSeqInsertSlice: "cvSeqInsertSlice" [
        "Inserts a sequence or array into another sequence"
            seq				[CvSeq!]
            before_index		[integer!]
            from_arr			[CvArr!]
        ]
        
        cvSeqSort: "cvSeqSort" [
        "Sorts sequence in-place given element comparison function"
            seq				[CvSeq!]
            CvCmpFunc			[byte-ptr!] ;CvCmpFunc func
            userdata			[byte-ptr!];CV_DEFAULT(NULL)
        ]
        
        cvSeqSearch: "cvSeqSearch" [
        "Finds element in a sorted or not sequence"
            seq				[CvSeq!]
            elem			[byte-ptr!]
            CvCmpFunc			[byte-ptr!] ; CvCmpFunc func
            is_sorted			[integer!]
            elem_idx			[int-ptr!]
            userdata			[byte-ptr!];CV_DEFAULT(NULL)
        ]
        
        cvSeqInvert: "cvSeqInvert" [
        "Reverses order of sequence elements in-place"
            seq				[CvSeq!]
        ]
        
        cvSeqPartition: "cvSeqPartition" [
            seq				[CvSeq!]
            storage			[CvMemStorage!]
            labels			[CvSeq!];  use &CvSeq! (CvSeq**)
            is_equal			[integer!]
            userdata			[byte-ptr!] ; void*
            return:			[integer!]
        ]
        
        cvChangeSeqBlock: "cvChangeSeqBlock" [
            reader			[byte-ptr!];void*
            direction			[integer!]
        ]
        cvCreateSeqBlock: "cvCreateSeqBlock" [
            writer			[CvSeqWriter!]
        ]
        
         cvCreateSet: "cvCreateSet" [
        "Creates a new set"
            set_flags			[integer!]
            header_size			[integer!]
            elem_size			[integer!]
            storage			[CvMemStorage!]
            return:			[CvSet!]
        ]
        
        cvSetAdd: "cvSetAdd" [
        "Adds new element to the set and returns pointer to it"
            set_header			[CvSet!]
            elem			[CvSetElem!]; V_DEFAULT(NULL)
            inserted_elem 		[CvSetElem!] ; double pointer CvSetElem** V_DEFAULT(NULL)
            return:			[integer!]
        ]
        cvSetRemove: "cvSetRemove" [
        "Removes element from the set by its index"
            set_header		        [CvSet!]
            index 			[integer!]
        ]
        
        cvClearSet: "cvClearSet" [
        "Removes all the elements from the set"
            set_header		        [CvSet!]
        ]
        
         cvGraphAddVtx: "cvGraphAddVtx" [
        "Adds new vertex to the graph"
            graph			[CvGraph!]
            vtx				[CvGraphVtx!];CV_DEFAULT(NULL)
            inserted_vtx	        [CvGraphVtx!]; double pointer address? CV_DEFAULT(NULL)
            return:			[integer!]
        ]
        
        cvGraphRemoveVtx: "cvGraphRemoveVtx" [
        "Removes vertex from the graph together with all incident edges"
            graph			[CvGraph!]
            index			[integer!]
            return:			[integer!]
        ]
        
        cvGraphRemoveVtxByPtr: "cvGraphRemoveVtxByPtr" [
        "non documented"
            graph			[CvGraph!]
            vtx				[CvGraphVtx!];CV_DEFAULT(NULL)
            return:			[integer!]
        ]
        
        cvGraphAddEdge: "cvGraphAddEdge" [
        "Functions return 1 if a new edge was created, 0 otherwise"
            graph			[CvGraph!]
            start_idx		        [integer!]
            end_idx			[integer!]
            edge			[CvGraphEdge!];CV_DEFAULT(NULL)
            inserted_edge	        [CvGraphEdge!];double pointer address CV_DEFAULT(NULL)
            return:			[integer!]
        ]
        
        cvGraphAddEdgeByPtr: "cvGraphAddEdgeByPtr" [
            graph			[CvGraph!]
            start_vtx		        [CvGraphVtx!]
            end_vtx			[CvGraphVtx!]
            edge			[CvGraphEdge!];CV_DEFAULT(NULL)
            inserted_edge	        [CvGraphEdge!];double pointer address CV_DEFAULT(NULL)
            return:			[integer!]
        ]
        
        cvGraphRemoveEdge: "cvGraphRemoveEdge" [
        "Remove edge connecting two vertices"
            graph			[CvGraph!]
            start_idx		        [integer!]
            end_idx			[integer!]
        ]
        
        cvGraphRemoveEdgeByPtr: "cvGraphRemoveEdgeByPtr" [
            graph			[CvGraph!]
            start_vtx		        [CvGraphVtx!]
            end_vtx			[CvGraphVtx!]
        ]
        
        cvFindGraphEdge: "cvFindGraphEdge" [
        "Find edge connecting two vertices"
            graph			[CvGraph!]
            start_idx		        [integer!]
            end_idx			[integer!]
            return:			[CvGraphEdge!]
        ]
        
        cvGraphFindEdge: "cvFindGraphEdge" [
        "Find edge connecting two vertices"
            graph			[CvGraph!]
            start_idx		        [integer!]
            end_idx			[integer!]
            return:			[CvGraphEdge!]
        ]
        
        cvFindGraphEdgeByPtr: "cvFindGraphEdgeByPtr" [
            graph			[CvGraph!]
            start_idx		        [CvGraphVtx!]
            end_idx			[CvGraphVtx!]
            return:			[CvGraphEdge!]
        ]
        
        cvGraphFindEdgeByPtr: "cvFindGraphEdgeByPtr" [
            graph			[CvGraph!]
            start_idx		        [CvGraphVtx!]
            end_idx			[CvGraphVtx!]
            return:			[CvGraphEdge!]
        ]
       
        cvClearGraph: "cvClearGraph" [
        "Remove all vertices and edges from the graph "
            graph			[CvGraph!]
        ]
        
        cvGraphVtxDegree: "cvGraphVtxDegree" [
        "Count number of edges incident to the vertex"
            graph			[CvGraph!]
            vtx_idx			[integer!]
            return:			[integer!]
        ]
        cvGraphVtxDegreeByPtr: "cvGraphVtxDegreeByPtr" [
            graph			[CvGraph!]
            vtx				[CvGraphVtx!]
            return:			[integer!]
        ]
        
         cvCreateGraphScanner: "cvCreateGraphScanner" [
        "Creates new graph scanner."
            graph			[CvGraph!]
            vtx 			[CvGraphVtx!] ;CV_DEFAULT(NULL)
            mask			[integer!];V_DEFAULT(CV_GRAPH_ALL_ITEMS))
            return:			[CvGraphScanner!]
        ]
        
        cvReleaseGraphScanner: "cvReleaseGraphScanner" [
        "Releases graph scanner"
            scanner		        [double-byte-ptr!] ; double pointer CvGraphScanner** 
        ]
        
        cvNextGraphItem: "cvNextGraphItem" [
        "Get next graph element "
            scanner		[CvGraphScanner!]
            return:		[integer!]
        ]
        
        cvCloneGraph: "cvCloneGraph" [
        "creates a copy of graph"
            graph		[CvGraph!]
            storage		[CvMemStorage!]
            return: 	        [CvGraph!]
        ]
        
        cvLUT: "cvLUT" [
        "Does look-up transformation"
            src     [CvArr!]
            dst     [CvArr!]
            lut     [CvArr!]
        ]
        
        cvInitTreeNodeIterator: "cvInitTreeNodeIterator"  [
        tree_iterator                   [CvTreeNodeIterator!]
        first                           [byte-ptr!]
        max_level                       [integer!]
    ]
    cvNextTreeNode: "cvInitTreeNodeIterator" [tree_iterator [CvTreeNodeIterator!]]
    cvPrevTreeNode: "cvInitTreeNodeIterator" [tree_iterator [CvTreeNodeIterator!]]
    
    ;Inserts sequence into tree with specified "parent" sequence. If parent is equal to frame (e.g. the most external contour),
    ;then added contour will have null pointer to parent.
    
    cvInsertNodeIntoTree: "cvInsertNodeIntoTree" [
    "Inserts sequence into tree with specified parent sequence."
        node                            [byte-ptr!] ;*void
        parent                          [byte-ptr!] ;*void
        frame                           [byte-ptr!] ;*void
    ]
    
    cvRemoveNodeFromTree: "cvRemoveNodeFromTree" [
    "Removes contour from tree (together with the contour children)."
        node                            [byte-ptr!] ;*void
        frame                           [byte-ptr!] ;*void
    ]
    
    cvTreeToNodeSeq: "cvTreeToNodeSeq" [
    "Gathers pointers to all the sequences, accessible from the first, to the single sequence "
        first                           [byte-ptr!]
        header_size                     [integer!]
        storage                         [CvMemStorage!]
        return:                         [CvSeq!]  
    ]
    
    cvKMeans2: "cvKMeans2" [
        samples                         [CvArr!]
        cluster_count                   [integer!]
        labels                          [CvArr!]
        termcrit                        [CvTermCriteria!]  
    ]  
    ]; end core
    
    
] ;end import


; inline functions

;Decrements CvMat data reference counter and deallocates the data if it reaches 0
cvDecRefData: func [arr [CvArr!] /local v mat matnd ptr] [
    mat: declare CvMAt! arr
    matnd: declare CvMatND! arr
    if CV_IS_MAT mat [ v: 0
            mat/data: 0
            if mat/refcount <> null [v: v + 1]
            if mat/refcount/value = 0 [v: v + 1] ;pointeur
            ptr: as double-byte-ptr! mat/refcount
            if v = 2 [ptr: _none]
    ]
    
    if CV_IS_MATND matnd [ v: 0
            mat/data: 0
            if mat/refcount <> null [v: v + 1]
            if mat/refcount/value = 0 [v: v + 1] ;pointeur
            ptr: as double-byte-ptr! mat/refcount
            if v = 2 [ptr: _none]
    ]
]

;increments CvMat data reference counter
cvIncRefData: func [arr [CvArr!] return: [integer!] /local refcount mat matnd ] [
    mat: declare CvMAt! arr
    matnd: declare CvMatND! arr
    refcount: 0
    if CV_IS_MAT mat [ if mat/refcount <> null [refcount: refcount + mat/refcount/value]]
    if CV_IS_MATND matnd [ if mat/refcount <> null [refcount: refcount + mat/refcount/value]]
    refcount       
]

cvGetRow: func [arr [CvArr!] submat [CvMat!] row [integer!]] [cvGetRows arr submat row row + 1 1]
cvGetCol: func [arr [CvArr!] submat [CvMat!] col [integer!]] [cvGetCols arr submat col col + 1]

;returns next sparse array node (or NULL if there is no more nodes)
;function uses CvSparseMatIterator! as parameter and returns  CvSparseNode! 

cvGetNextSparseNode: func [mat_iterator [CvSparseMatIterator!] return: [CvSparseNode!] /local node idx]
[
    node: declare CvSparseNode! mat_iterator
    either (mat_iterator/node/next <> null) [mat_iterator/node: mat_iterator/node/next]
    [
        
        print ["to be done" lf]
    ]
    node
]

; red/S version
_cvSubS: func [src [CvArr!] value [CvScalar!] dst [CvArr!] mask [CvArr!] /local cvalue]  [
    cvalue: declare CvScalar!
    cvalue/v0: 0.0 - value/v0
    cvalue/v1: 0.0 - value/v1
    cvalue/v2: 0.0 - value/v2
    cvalue/v3: 0.0 - value/v3
    cvAddS src cvalue/v0 cvalue/v1 cvalue/v2 cvalue/v3 dst mask
]

; to be coherent with structure use
cvSubS: func [src [CvArr!] 
		   v0	[float!]    
           v1	[float!]
           v2	[float!]
           v3	[float!] 
           dst [CvArr!] 
           mask [CvArr!] /local cvalue]  [
    cvAddS src v0 v1 v2 v3 dst mask
]

cvAbs: func [src [CvArr!] dst [CvArr!]][
	 cvAbsDiffS src dst 0.0 0.0 0.0 0.0
]


cvConvert: func [src [CvArr!] dst [CvArr!]][
	cvConvertScale src dst 1.0 0.0
]

cvReshapeND: func [arr [CvArr!] header [CvArr!] new_cn [integer!]  new_dims [integer!] new_sizes [int-ptr!]] [
	cvReshapeMatND arr size? header header new_cn new_dims new_sizes
]

cvAXPY: func [	A [CvArr!] 
				v0 [float!]
				v1 [float!]
				v2 [float!]
				v3 [float!]
				B [CvArr!] 
				C [CvArr!]] [
	cvScaleAdd A v0 v1 v2 v3 B C
]

;Matrix transform: dst = A*B + C, C is optional */
cvMatMulAdd: func [ src1 [CvArr!] src2 [CvArr!] src3 [CvArr!] dst [CvArr!]] [
	cvGEMM src1 src2 1.0 src3 1.0 dst 0
]

cvMatMul: func [src1 [CvArr!] src2 [CvArr!] dst [CvArr!]] [
	cvMatMulAdd src1 src2 null dst
]

; TB TESTED
; Retrieves index of a graph vertex given its pointer */
#define cvGraphVtxIdx( graph vtx ) [(vtx/flags & CV_SET_ELEM_IDX_MASK)]      
;Retrieves index of a graph edge given its pointer
#define cvGraphEdgeIdx( graph edge ) [(edge/flags & CV_SET_ELEM_IDX_MASK)]
#define cvGraphGetVtxCount( graph ) [(graph/active_count)]
#define cvGraphGetEdgeCount( graph ) [(graph/edges/active_count)]
#define  CV_IS_GRAPH_VERTEX_VISITED(vtx) [(CvGraphVtx!/vtx/flags & CV_GRAPH_ITEM_VISITED_FLAG)]
#define  CV_IS_GRAPH_EDGE_VISITED(edge) [(CvGraphEdge!/edge/flags & CV_GRAPH_ITEM_VISITED_FLAG)]

; end TEST

;
        
;not in lib but interesting for us

;ATTENTION in OpenCV BGRA values are bit: -128 .. 127 0..255 in OpenCV for 32-bit images
; we use a func to transform r fg b a 0..255 to use with red/system

tocvRGB: func [vr [float!] vg [float!] vb [float!] va  [float!] return: [CvScalar!]/local r g b a val]
[ val: vr / 255.0 either val > 0.5 [b: val * 127.0] [b: -1.0 * (val * 128.0)]
  val: vg / 255.0 either val > 0.5 [g: val * 127.0] [g: -1.0 * (val * 128.0)]
  val: vb / 255.0 either val > 0.5 [r: val * 127.0] [r: -1.0 * (val * 128.0)]
  if va = 0.0 [a: 0.0]
  if va <> 0.0 [val: va / 255.0 either val > 0.5 [a: val * 127.0] [a: -1.0 * (val * 128.0)]]
  cvScalar b g r a
]
; a shortcut for image release
releaseImage: func [image [byte-ptr!] /local &image] [
	&image: declare double-byte-ptr!;  C function needs a double pointer
	&image/ptr: image
	cvReleaseImage &image
]

releaseMat: func [mat [byte-ptr!] /local &mat] [
	&mat: declare double-byte-ptr!;  C function needs a double pointer
	&mat/ptr: mat
	cvReleaseMat &mat
]

        
   
; temporary functions waiting for struct improvments
; e.g. cvGetSize
; WARNING ONLY FOR target = 'IA32
getSizeW: func [arr [CvArr!] return: [integer!]][
	cvGetSize arr
	system/cpu/eax
]

getSizeH: func [arr [CvArr!] return: [integer!]][
	cvGetSize arr
	system/cpu/edx
]

getSize: func [arr [CvArr!] return: [CvSize!] /local sz][
	sz: declare CvSize!
        cvGetSize arr
	sz/width: system/cpu/eax
	cvGetSize arr
	sz/height: system/cpu/edx
	sz
]
   
   
;idem for scalar!
get1D: func [arr [CvArr!] idx0 [integer!] return: [integer!]][
	cvGet1D arr idx0
	system/cpu/eax
]
 
