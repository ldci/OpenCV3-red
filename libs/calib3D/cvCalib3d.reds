Red/System [
	Title:		"OpenCV 3.0.0 Binding: calib3d"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../libs/platforms.reds            ; lib path according to os
#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structures

#define CvPOSITObject! byte-ptr!
;Calculates fundamental matrix given a set of corresponding points
 CV_FM_7POINT: 1
 CV_FM_8POINT: 2
 CV_FM_LMEDS_ONLY:  4
 CV_FM_RANSAC_ONLY: 8
 CV_FM_LMEDS: 12
 CV_FM_RANSAC: 10
 CV_CALIB_CB_ADAPTIVE_THRESH:  1
 CV_CALIB_CB_NORMALIZE_IMAGE:  2
 CV_CALIB_CB_FILTER_QUADS:     4
 CV_CALIB_CB_FAST_CHECK:       8
 CV_CALIB_USE_INTRINSIC_GUESS:  1
 CV_CALIB_FIX_ASPECT_RATIO:     2
 CV_CALIB_FIX_PRINCIPAL_POINT:  4
 CV_CALIB_ZERO_TANGENT_DIST:    8
 CV_CALIB_FIX_FOCAL_LENGTH: 16
 CV_CALIB_FIX_K1:  32
 CV_CALIB_FIX_K2:  64
 CV_CALIB_FIX_K3:  128
 CV_CALIB_FIX_K4:  2048
 CV_CALIB_FIX_K5:  4096
 CV_CALIB_FIX_K6:  8192
 CV_CALIB_FIX_K3: 16384
 CV_CALIB_THIN_PRISM_MODEL: 32768
 CV_CALIB_FIX_S1_S2_S3_S4:  65536
 CV_CALIB_FIX_INTRINSIC:  256
 CV_CALIB_SAME_FOCAL_LENGTH: 512
 CV_CALIB_ZERO_DISPARITY: 1024
 CV_STEREO_BM_NORMALIZED_RESPONSE:  0
 CV_STEREO_BM_XSOBEL:               1
 CV_STEREO_BM_BASIC: 0
 CV_STEREO_BM_FISH_EYE: 1
 CV_STEREO_BM_NARROW: 2


; Block matching algorithm structure

CvStereoBMState!: alias struct! [
    preFilterType       [integer!]
    preFilterSize       [integer!]
    preFilterCap        [integer!]
    SADWindowSize       [integer!]
    minDisparity        [integer!]
    numberOfDisparities [integer!]
    textureThreshold    [integer!]
    uniquenessRatio     [integer!]
    speckleWindowSize   [integer!]
    speckleRange        [integer!]
    trySmallerWindows   [integer!]
    roi1_x              [integer!] ; CvRect
    roi1_y              [integer!]
    roi1_w              [integer!]
    roi1_h              [integer!]
    roi2_x              [integer!] ; CvRect
    roi2_y              [integer!]
    roi2_w              [integer!]
    roi2_h              [integer!]
    disp12MaxDiff       [integer!]
    preFilteredImg0     [CvMat!]
    preFilteredImg1     [CvMat!]
    slidingSumBuf       [CvMat!]
    cost                [CvMat!]
    disp                [CvMat!]
]

 
#enum fmat [
    CV_ITERATIVE:   0
    CV_EPNP:        1   ; F.Moreno-Noguer, V.Lepetit and P.Fua "EPnP: Efficient Perspective-n-Point Camera Pose Estimation"
    CV_P3P:         2   ; X.S. Gao, X.-R. Hou, J. Tang, H.-F. Chang; "Complete Solution Classification for the Perspective-Three-Point Problem"
    CV_DLS:         3   ; Joel A. Hesch and Stergios I. Roumeliotis. "A Direct Least-Squares (DLS) Method for PnP"
]      
        
#import [
    cvCalib3d importMode [
        cvCreatePOSITObject: "cvCreatePOSITObject" [
        "Allocates and initializes CvPOSITObject structure before doing cvPOSIT"
            points                  [CvPoint2D32f!]
            point_count             [integer!]
            return:                 [CvPOSITObject!]
        ]
        
        cvPOSIT: "cvPOSIT" [
        "Runs POSIT (POSe from ITeration) algorithm for determining 3d position of an object given its model and projection in a weak-perspective case"
            posit_object            [CvPOSITObject!]
            image_points            [CvPoint2D32f!]
            focal_length            [float!]
            criteria                [CvTermCriteria!]
            rotation_matrix         [float!]  ; old CvMatr32f
            translation_vector      [float!]  ; old CvMatr32f
        ]
        
        cvReleasePOSITObject: "cvReleasePOSITObject" [
            posit_object            [double-byte-ptr!]     ;CvPOSITObject**
        ]
        
        cvRANSACUpdateNumIters: "cvRANSACUpdateNumIters" [
        "updates the number of RANSAC iterations"
            p                   [float!]
            err_prob            [integer!]
            model_points        [integer!]
            max_iters           [float!]
            return:             [integer!]
        ]
        
        cvConvertPointsHomogenious: "cvConvertPointsHomogenious" [
            src                     [CvMat!]
            dst                     [CvMat!] 
        ]
        
        cvFindFundamentalMat: "cvFindFundamentalMat" [
        "Calculates fundamental matrix given a set of corresponding points"
            points1                 [CvMat!]
            points2                 [CvMat!]
            fundamental_matrix      [CvMat!]
            method                  [integer!]  ; CV_DEFAULT(CV_FM_RANSAC)
            param1                  [float!]    ; CV_DEFAULT(1.)
            param2                  [float!]    ; CV_DEFAULT(0.99)
            status                  [CvMat!]
            return:                 [integer!]
        ]
        
        cvComputeCorrespondEpilines: "cvComputeCorrespondEpilines" [
        "For each input point on one of images computes parameters of the corresponding epipolar line on the other image"
            points                  [CvMat!]
            which_image             [integer!]
            fundamental_matrix      [CvMat!]
            correspondent_lines     [CvMat!]
        ]
        
        cvTriangulatePoints: "cvTriangulatePoints" [
        "Triangulation functions"
            projMatr1           [CvMat!]
            projMatr2           [CvMat!]
            projPoints1         [CvMat!]
            projPoints2         [CvMat!]
            points4D            [CvMat!]
        ]
        
         cvGetOptimalNewCameraMatrix: "cvGetOptimalNewCameraMatrix" [
            camera_matrix               [CvMat!]
            dist_coeffs                 [CvMat!]
            image_size_w                [integer!]
            image_size_h                [integer!]
            alpha                       [float!]
            new_camera_matrix           [CvMat!]       
            nimage_size_w               [integer!]  ;CV_DEFAULT(cvSize(0,0))
            nimage_size_h               [integer!]  
            valid_pixel_ROI             [CvRect!]   ;CV_DEFAULT(0)
            center_principal_point      [integer!]  ;CV_DEFAULT(0)
        ]
        
        cvRodrigues2: "cvRodrigues2" [
        "converts rotation vector to rotation matrix or vice versa"
            src                     [CvArr!]
            dst                     [CvMat!]
            jacobian                [CvMat!] ; CV_DEFAULT(0)
            return:                 [integer!]
        ]
        
        cvFindHomography: "cvFindHomography" [
        "finds perspective transformation between the object plane and image (view) plane"
            src_points                [CvMat!]
            dst_points                [CvMat!]
            homography                [CvMat!]
            method                    [integer!]    ;0
            ransacReprojThreshold     [float!]      ;3.0
            mask                      [CvMat!]      ;0
            maxIters                  [integer!]    ;2000
            confidence                [float!]      ; 0.995
        ]
        
        cvRQDecomp3x3: "cvRQDecomp3x3" [
        "Computes RQ decomposition for 3x3 matrices"
            matrixM                 [CvMat!]
            matrixR                 [CvMat!]
            matrixQ                 [CvMat!]
            matrixQx                [CvMat!]
            matrixQy                [CvMat!]
            matrixQz                [CvMat!]
            eulerAngle              [CvPoint3D64f!]
        ]
        
        cvDecomposeProjectionMatrix: "cvDecomposeProjectionMatrix" [
        "Computes projection matrix decomposition"
            rotMatr                 [CvMat!]
            posVect                 [CvMat!]
            rotMatrX                [CvMat!]
            rotMatrY                [CvMat!]
            rotMatrZ                [CvMat!]
            eulerAngle              [CvPoint3D64f!]
        ]
        
        cvCalcMatMulDeriv: "cvCalcMatMulDeriv" [
        "Computes d(AB)/dA and d(AB)/dB" 
            A                 [CvMat!]
            B                 [CvMat!]
            dABdA             [CvMat!]
            dABdAB            [CvMat!]
        ]
        
        cvComposeRT: "cvComposeRT" [
            _rvec1              [CvMat!]
            _rvec2              [CvMat!]
            _tvec1              [CvMat!]
            _tvec2              [CvMat!]
            _rvec3              [CvMat!]
            _tvec3              [CvMat!]
            dr3dr1              [CvMat!]
            dr3dt1              [CvMat!]
            dr3dr2              [CvMat!]
            dr3dt2              [CvMat!]
            dt3dr1              [CvMat!]
            dt3dt1              [CvMat!]
            dt3dr2              [CvMat!]
            dt3dt2              [CvMat!]   
        ]
        
        cvProjectPoints2: "cvProjectPoints2" [
        "projects object points to the view plane using the specified extrinsic and intrinsic camera parameters"
            object_points               [CvMat!]
            rotation_vector             [CvMat!]
            translation_vector          [CvMat!]
            intrinsic_matrix            [CvMat!]
            distortion_coeffs           [CvMat!]
            image_points                [CvMat!]
            dpdrot                      [CvMat!] ;CV_DEFAULT(NULL)
            dpdt                        [CvMat!] ;CV_DEFAULT(NULL)
            dpdf                        [CvMat!] ;CV_DEFAULT(NULL)
            dpdc                        [CvMat!] ;CV_DEFAULT(NULL)
            dpddist                     [CvMat!] ;CV_DEFAULT(NULL)          
        ]
        
        cvFindExtrinsicCameraParams2: "cvFindExtrinsicCameraParams2" [
        "Finds extrinsic camera parameters from a few known corresponding point pairs and intrinsic parameters"
            object_points               [CvMat!]
            image_points                [CvMat!]
            intrinsic_matrix            [CvMat!]
            distortion_coeffs           [CvMat!]
            rotation_vector             [CvMat!]
            translation_vector          [CvMat!]
        ]
        
        cvFindExtrinsicCameraParams2D: "cvFindExtrinsicCameraParams2" [
        "Computes initial estimate of the intrinsic camera parameters in case of planar calibration target (e.g. chessboard)"
            object_points               [CvMat!]
            image_points                [CvMat!]
            npoints                     [CvMat!]
            image_size_w                [integer!]
            image_size_h                [integer!]
            camera_matrix               [CvMat!]
            aspect_ratio                [float!]    ;1.0
        ]
        
        cvCheckChessboard: "cvCheckChessboard" [
        "Performs a fast check if a chessboard is in the input image"
            src         [IplImage!]
            size_w      [integer!]
            size_h      [integer!]
            return:     [integer!]
        ]
        
        cvFindChessboardCorners: "cvFindChessboardCorners" [
        "Detects corners on a chessboard calibration pattern"
            image                   [byte-ptr!]   ; *void
            pattern_size_w          [integer!]    ; _CvSize
            pattern_size_h          [integer!]    ; _CvSize
            corners                 [CvPoint2D32f!]
            corner_count            [int-ptr!] ;CV_DEFAULT(NULL)
            flags                   [integer!] ;CV_DEFAULT(CV_CALIB_CB_ADAPTIVE_THRESH)
        ]
        
        cvDrawChessboardCorners: "cvDrawChessboardCorners" [
        "Draws individual chessboard corners or the whole chessboard detected"
            image                   [CvArr!]   ; 
            pattern_size_w          [integer!]    ; _CvSize
            pattern_size_h          [integer!]    ; _CvSize
            corners                 [CvPoint2D32f!]
            count                   [integer!]
            pattern_was_found       [integer!]
        ]
        
        cvCalibrateCamera2: "cvCalibrateCamera2" [
        "Finds intrinsic and extrinsic camera parameters from a few views of known calibration pattern"
            object_points               [CvMat!]
            image_points                [CvMat!]
            point_counts                [CvMat!]
            image_size_w                [integer!] ;_CvSize
            image_size_h                [integer!] ; _CvSize
            intrinsic_matrix            [CvMat!]
            distortion_coeffs           [CvMat!]
            rotation_vectors            [CvMat!]   ;CV_DEFAULT(NULL)
            translation_vectors         [CvMat!]   ;CV_DEFAULT(NULL)
            flags                       [integer!] ;CV_DEFAULT(0)    
        ]
        
        cvCalibrationMatrixValues: "cvCalibrationMatrixValues" [
        "Computes various useful characteristics of the camera from the data computed by cvCalibrateCamera2"
            camera_matrix           [CvMat!]
            image_size_w            [integer!]
            image_size_h            [integer!]
            aperture_width          [float!]
            aperture_height         [float!]
            fovx                    [float-ptr!]
            fovy                    [float-ptr!]
            focal_length            [float-ptr!]
            principal_point         [CvPoint2D64f!]
            pixel_aspect_ratio      [float-ptr!]
        ]
        
        cvStereoCalibrate: "cvStereoCalibrate" [
        {Computes the transformation from one camera coordinate system to another one
   		from a few correspondent views of the same calibration target. Optionally, calibrates
   		both cameras}
   			object_points		[CvMat!]
   			image_points1		[CvMat!]
   			image_points2		[CvMat!]
   			npoints				[CvMat!]
   			camera_matrix1  	[CvMat!]
   			dist_coeffs1    	[CvMat!]
   			camera_matrix2  	[CvMat!]
   			dist_coeffs2    	[CvMat!]
   			image_size_w        [integer!]
            image_size_h        [integer!]
            R                   [CvMat!]
            T                   [CvMat!]
            E                   [CvMat!]
            F                   [CvMat!]
            flags               [integer!]
            term_cri			[CvTermCriteria!]
   			return: 			[float!]
        ]
        
        cvStereoRectify: "cvStereoRectify" [
        {Computes 3D rotations (+ optional shift) for each camera coordinate system to make both
        views parallel (=> to make all the epipolar lines horizontal or vertical)}
            camera_matrix1      [CvMat!]
            camera_matrix2      [CvMat!]
            dist_coeffs1        [CvMat!]
            dist_coeffs2        [CvMat!]
            image_size_w        [integer!]
            image_size_h        [integer!]
            R                   [CvMat!]
            T                   [CvMat!]
            R1                  [CvMat!]
            R2                  [CvMat!]
            P1                  [CvMat!]
            P2                  [CvMat!]
            Q                   [CvMat!]
            flags               [integer!]
            alpha               [float!]
            nimage_size_w       [integer!]
            nimage_size_h       [integer!]
            valid_pix_ROI1      [CvRect!]
            valid_pix_ROI2      [CvRect!]
        ]
        
        cvStereoRectifyUncalibrated: "cvStereoRectifyUncalibrated" [
        "Computes rectification transformations for uncalibrated pair of images using a set of point correspondences"
            points1             [CvMat!]
            points2             [CvMat!]
            F                   [CvMat!]
            image_size_w        [integer!]
            image_size_h        [integer!]
            H1                  [CvMat!]
            H2                  [CvMat!]
            threshold           [float!]
        ]
        
        cvCreateStereoBMState: "cvCreateStereoBMState" [
            preset                  [integer!]
            numberOfDisparities     [integer!] 
            return:                 [CvStereoBMState!]
        ]
        
        cvReleaseStereoBMState: "cvReleaseStereoBMState" [
            state       [double-byte-ptr!]
        ]
        
        cvFindStereoCorrespondenceBM: "cvFindStereoCorrespondenceBM" [
            left            [CvArr!]
            right           [CvArr!]
            disparity       [CvArr!]
            state           [CvStereoBMState!]
        ]
        
        cvGetValidDisparityROI: "cvGetValidDisparityROI" [
            roi1_x              [integer!] ; CvRect
            roi1_y              [integer!]
            roi1_w              [integer!]
            roi1_h              [integer!]
            roi2_x              [integer!] ; CvRect
            roi2_y              [integer!]
            roi2_w              [integer!]
            roi2_h              [integer!]
            minDisparity        [integer!]
            numberOfDisparities [integer!]
            SADWindowSize       [integer!]
            return:             [CvRect!] ; not a pointer
        ]
        
        cvValidateDisparity: "cvValidateDisparity" [
            disparity           [CvArr!]
            cost                [CvArr!]
            minDisparity        [integer!]
            numberOfDisparities [integer!]
            disp12MaxDiff       [integer!] 
        ]
        
        cvReprojectImageTo3D: "cvReprojectImageTo3D" [
            disparity           [CvArr!]
            _3dImage            [CvArr!]
            Q                   [CvArr!]
            handleMissingValues [integer!] 
        ]   
    ] ; end calib3d
] ; end import