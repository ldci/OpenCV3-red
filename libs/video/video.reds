Red/System [
	Title:		"OpenCV 3.0.0 Binding: video"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../libs/plateforms.reds            ; lib path according to os
#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structures


;NO backward compatibility!!!

CvKalman!: alias struct! [
    MP                      [integer!]
    DP                      [integer!]
    CP                      [integer!]
    state_pre               [CvMat!]
    state_post              [CvMat!]
    transition_matrix       [CvMat!]
    control_matrix          [CvMat!]
    measurement_matrix      [CvMat!]
    process_noise_cov       [CvMat!]
    measurement_noise_cov   [CvMat!]
    error_cov_pre           [CvMat!]
    gain                    [CvMat!]
    error_cov_post          [CvMat!]
    temp1                   [CvMat!]
    temp2                   [CvMat!]
    temp3                   [CvMat!]
    temp4                   [CvMat!]
    temp5                   [CvMat!]
]



;****************************************************************************************
;*                            Motion Analysis and Motion Tracking                       *
;****************************************************************************************


CV_LKFLOW_PYR_A_READY:       1
CV_LKFLOW_PYR_B_READY:       2
CV_LKFLOW_INITIAL_GUESSES:   4
CV_LKFLOW_GET_MIN_EIGENVALS: 8

#import [
    video importMode [
            cvCalcOpticalFlowPyrLK: "cvCalcOpticalFlowPyrLK" [
            "Calculates optical flow between two images"
                prev 			[CvArr!] 
                curr 			[CvArr!]
                prevPyr 		[CvArr!]
                currPyr 		[CvArr!]
                prevFeatures	        [CvArr!]	
                currFeatures	        [CvArr!]
                count			[integer!]
                w			[integer!]
                h			[integer!]
                level			[integer!]
                status			[c-string!]
                track_error		[float-ptr!]
                criteria		[byte-ptr!]
                flags			[integer!]
            ]
            
            cvCalcAffineFlowPyrLK: "cvCalcAffineFlowPyrLK" [
            "Modification of a previous sparse optical flow algorithm to calculate affine flow"
                prev 			[CvArr!] 
                curr 			[CvArr!]
                prevPyr 		[CvArr!]
                currPyr 		[CvArr!]
                prevFeatures	        [CvArr!]	
                currFeatures	        [CvArr!]
                matrices                [float-ptr!]
                count			[integer!]
                w			[integer!]
                h			[integer!]
                level			[integer!]
                status			[c-string!]
                track_error		[float-ptr!]
                criteria		[byte-ptr!]
                flags			[integer!]
            ]
            
            cvEstimateRigidTransform: "cvEstimateRigidTransform" [
            "Estimate rigid transformation between 2 images or 2 point sets"
                A			[CvArr!]
                B			[CvArr!]
                M			[CvMat!]
                full_affine		[integer!]
                return:			[integer!]
            ]
            
            cvCalcOpticalFlowFarneback: "cvCalcOpticalFlowFarneback" [
            "Estimate optical flow for each pixel using the two-frame G. Farneback algorithm"
                prev 			[CvArr!] 
                curr 			[CvArr!]
                flow 			[CvArr!]
                pyr_scale		[float!]
                levels			[integer!]
                winsize			[integer!]
                iterations		[integer!]
                poly_n			[integer!]
                poly_sigma		[float!]
                flags			[integer!]    
            ]
            
            cvUpdateMotionHistory: "cvUpdateMotionHistory" [
            "Updates motion history image given motion silhouette"
                silhouette		[CvArr!]
                mhi			[CvArr!]
                timestamp		[float!]
                duration		[float!]
            ]
            
            cvCalcMotionGradient: "cvCalcMotionGradient" [
            "Calculates gradient of the motion history image and fills"
                mhi			[CvArr!]
                mask			[CvArr!]
                orientation		[CvArr!]
                delta1			[float!]
                delta2			[float!]
                aperture_size	[integer!] ; CV_DEFAULT(3)    
            ]
            
            cvCalcGlobalOrientation: "cvCalcGlobalOrientation" [
            "Calculates average motion direction within a selected motion region"
                orientation		[CvArr!]
                mask			[CvArr!]
                mhi			[CvArr!]
                timestamp		[float!]
                duration		[float!]
                return:			[float!]    
            ]
            
            ;(e.g. left hand, right hand)
            cvSegmentMotion: "cvSegmentMotion" [
            "Splits a motion history image into a few parts corresponding to separate independent motions"
                mhi			[CvArr!]
                seg_mask		[CvArr!]
                storage			[CvMemStorage!]	;CvMemStorage*
                timestamp		[float!]
                seg_thresh		[float!]
                return:			[CvSeq!] 	; CvSeq*
            ]
            
            cvCamShift: "cvCamShift" [
            "Implements CAMSHIFT algorithm"
                prob_image	[CvArr!]
                window_x	[integer!]              ; cvRect (structure)
                window_y	[integer!]
                window_w	[integer!]
                window_h	[integer!]              ; end cvRect
                ctype		[integer!] 	        ; CvTermCriteria structure
                max_iter	[integer!]	
                epsilon		[float!]	        ; end CvTermCriteria
                comp		[CvConnectedComp!]	; CvConnectedComp*
                box		[CvBox2D!]		; CvBox2D*
                return:		[integer!]  
            ]
            
            cvMeanShift: "cvMeanShift" [
            "Implements MeanShift algorithm"
                prob_image	[CvArr!]
                window_x	[integer!]	    ; cvRect (structure)
                window_y	[integer!]
                window_w	[integer!]
                window_h	[integer!]          ; end cvRect
                ctype		[integer!] 	    ; CvTermCriteria structure
                max_iter	[integer!]	
                epsilon		[float!]	    ; end CvTermCriteria
                comp		[CvConnectedComp!]  ; CvConnectedComp*
                return:		[integer!]
            ]
            
            cvCreateKalman: "cvCreateKalman" [
            "Creates Kalman filter and sets A, B, Q, R and state to some initial values"
                dynam_params		[integer!]
                measure_params		[integer!]
                control_params		[integer!]	;CV_DEFAULT(0)
                return:			[CvKalman!]     ;CvKalman*
            ]
            
            cvReleaseKalman: "cvReleaseKalman" [
            "Releases Kalman filter state"
                kalman      [struct! [ptr [CvKalman!]]] ; pointer of pointer (CvKalman**) 
            ]
            
            cvKalmanPredict: "cvKalmanPredict" [
            "Updates Kalman filter by time (predicts future state of the system)"
                kalman			[CvKalman!]	
                control			[CvMat!]	;CvMat CV_DEFAULT(NULL)		
                return:			[CvMat!]	
            ]
            
            cvKalmanUpdateByTime: "cvKalmanPredict" [
            "Updates Kalman filter by time (predicts future state of the system)"
                kalman			[CvKalman!]	
                control			[CvMat!]	;CvMat CV_DEFAULT(NULL)		
                return:			[CvMat!]	
            ]
            
            cvKalmanCorrect: "cvKalmanCorrect" [
            "Updates Kalman filter by measurement (corrects state of the system and internal matrices)"
                kalman			[CvKalman!]	
                measurement		[CvMat!]
                return:			[CvMat!]	
            ] 
            
            cvKalmanUpdateByMeasurement: "cvKalmanCorrect" [
            "Updates Kalman filter by measurement (corrects state of the system and internal matrices)"
                kalman			[CvKalman!]	
                measurement		[CvMat!]
                return:			[CvMat!]	
            ] 
    ] ;end video
] ;end import


