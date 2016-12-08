Red/System [
	Title:		"OpenCV 3.0.0 Binding: videoio"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../libs/platforms.reds            ; lib path according to os
#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structuresñ


; OpenCV videoio C Functions

;#define videoio "/usr/local/lib32/opencv3/libopencv_videoio.dylib"
#switch OS [
    MacOSX  [#define videoio "/usr/local/lib32/opencv3/libopencv_world.dylib" #define importMode cdecl]
    ;Windows [#define videoio "c:\opencv3\build\x86\vc12\bin\opencv_world300.dll" #define importMode cdecl] ;stdcall in case of
    Windows [#define videoio "c:\opencv310\build\x86\mingw\libopencv_world310.dll" #define importMode cdecl]
    Linux   [#define videoio "/usr/local/lib/libopencv_world.so.3.0.0" #define importMode cdecl]
]

;The  opencv structure CvCapture! does not have public interface
;and is used only as a parameter for video capturing functions.
#define CvCapture! int-ptr!
#define CvVideoWriter! [double-int-ptr!]


#enum videocap [
    CV_CAP_ANY:                     0     ; autodetect
    CV_CAP_MIL:                     100   ; MIL proprietary drivers
    CV_CAP_VFW:                     200   ; platform native
    CV_CAP_V4L:                     200
    CV_CAP_V4L2:                    200
    CV_CAP_FIREWARE:                300   ; IEEE 1394 drivers
    CV_CAP_IEEE1394:                300
    CV_CAP_DC1394:                  300
    CV_CAP_CMU1394:                 300
    CV_CAP_STEREO:                  400   ;TYZX proprietary drivers
    CV_CAP_TYZX:                    400
    CV_TYZX_LEFT:                   400
    CV_TYZX_RIGHT:                  401
    CV_TYZX_COLOR:                  402
    CV_TYZX_Z:                      403
    CV_CAP_QT:                      500    ; QuickTime
    CV_CAP_UNICAP:                  600    ; Unicap drivers
    CV_CAP_DSHOW:                   700    ; DirectShow (via videoInput)
    CV_CAP_MSMF:                    1400   ; Microsoft Media Foundation (via videoInput)
    CV_CAP_PVAPI:                   800    ; PvAPI, Prosilica GigE SDK
    CV_CAP_OPENNI:                  900    ; OpenNI (for Kinect)
    CV_CAP_OPENNI_ASUS:             910    ; OpenNI (for Asus Xtion)
    CV_CAP_ANDROID:                 1000   ;Android - not used
    CV_CAP_ANDROID_BACK:            1099    ; Android back camera - not used
    CV_CAP_ANDROID_FRONT:           1098    ;Android front camera - not used
    CV_CAP_XIAPI:                   1100    ; XIMEA Camera API
    CV_CAP_AVFOUNDATION:            1200    ; AVFoundation framework for iOS (OS X Lion will have the same API)
    CV_CAP_GIGANETIX:               1300    ;Smartek Giganetix GigEVisionSDK
    CV_CAP_INTELPERC:               1500    ;Intel Perceptual Computing
    CV_CAP_OPENNI2:                 1600    ;OpenNI2 (for Kinect)
    CV_CAP_GPHOTO2:                 1700
    CV_CAP_GSTREAMER:				1800	;GStreamer
    CV_CAP_FFMPEG:					1900	;FFMPEG
    CV_CAP_IMAGES:					2000	;OpenCV Image Sequence (e.g. img_%02d.jpg)
]

#enum capmode [
    ; modes of the controlling registers (can be:auto manual auto single push absolute Latter allowed with any other mode)
    ; every feature can have only one mode turned on at a time
    CV_CAP_PROP_DC1394_OFF:                     -4  ;turn the feature off (not controlled manually nor automatically)
    CV_CAP_PROP_DC1394_MODE_MANUAL:		-3 ;set automatically when a value of the feature is set by the user
    CV_CAP_PROP_DC1394_MODE_AUTO:		-2
    CV_CAP_PROP_DC1394_MODE_ONE_PUSH_AUTO:	-1
    CV_CAP_PROP_POS_MSEC:               	0
    CV_CAP_PROP_POS_FRAMES:              	1
    CV_CAP_PROP_POS_AVI_RATIO:                  2
    CV_CAP_PROP_FRAME_WIDTH:               	3
    CV_CAP_PROP_FRAME_HEIGHT:                   4
    CV_CAP_PROP_FPS:               		5
    CV_CAP_PROP_FOURCC:               		6
    CV_CAP_PROP_FRAME_COUNT:               	7
    CV_CAP_PROP_FORMAT:               		8
    CV_CAP_PROP_MODE:               		9
    CV_CAP_PROP_BRIGHTNESS:               	10
    CV_CAP_PROP_CONTRAST:               	11
    CV_CAP_PROP_SATURATION:               	12
    CV_CAP_PROP_HUE:               		13
    CV_CAP_PROP_GAIN:               		14
    CV_CAP_PROP_EXPOSURE:               	15
    CV_CAP_PROP_CONVERT_RGB:                    16
    CV_CAP_PROP_WHITE_BALANCE_BLUE_U:		17
    CV_CAP_PROP_RECTIFICATION:                  18
    CV_CAP_PROP_MONOCHROME:                     19
    CV_CAP_PROP_SHARPNESS:                      20
    CV_CAP_PROP_AUTO_EXPOSURE:                  21 ; exposure control done by camera user can adjust refernce levelusing this feature
    CV_CAP_PROP_GAMMA:                          22
    CV_CAP_PROP_TEMPERATURE:                    23
    CV_CAP_PROP_TRIGGER:                        24
    CV_CAP_PROP_TRIGGER_DELAY:                  25
    CV_CAP_PROP_WHITE_BALANCE_RED_V:            26
    CV_CAP_PROP_ZOOM:                           27
    CV_CAP_PROP_FOCUS:                          28
    CV_CAP_PROP_GUID:                           29
    CV_CAP_PROP_ISO_SPEED:                      30
    CV_CAP_PROP_MAX_DC1394:                     31
    CV_CAP_PROP_BACKLIGHT:                      32
    CV_CAP_PROP_PAN:                            33
    CV_CAP_PROP_TILT:                           34
    CV_CAP_PROP_ROLL:                           35
    CV_CAP_PROP_IRIS:                           36
    CV_CAP_PROP_SETTINGS:                       37
    CV_CAP_PROP_BUFFERSIZE:                     38
    V_CAP_PROP_AUTOGRAB:                        1024 ; property for videoio class CvCapture_Android only
    CV_CAP_PROP_SUPPORTED_PREVIEW_SIZES_STRING: 1025 ; readonly tricky property returns cpnst char* indeed
    CV_CAP_PROP_PREVIEW_FORMAT:                 1026 ; readonly tricky property returns cpnst char* indeed
    ; OpenNI map generators
    CV_CAP_OPENNI_DEPTH_GENERATOR:              -2147483648 ; 1 << 31
    CV_CAP_OPENNI_IMAGE_GENERATOR:              1073741824 ;1 << 30
    CV_CAP_OPENNI_GENERATORS_MASK:              -1073741824
     ; Properties of cameras available through OpenNI interfaces
    CV_CAP_PROP_OPENNI_OUTPUT_MODE:             100
    CV_CAP_PROP_OPENNI_FRAME_MAX_DEPTH:         101 ; in mm
    CV_CAP_PROP_OPENNI_BASELINE:                102 ; in mm
    CV_CAP_PROP_OPENNI_FOCAL_LENGTH:            103 ; in pixels
    CV_CAP_PROP_OPENNI_REGISTRATION:            104 ; flag
    CV_CAP_PROP_OPENNI_REGISTRATION_ON:         CV_CAP_PROP_OPENNI_REGISTRATION
    CV_CAP_PROP_OPENNI_APPROX_FRAME_SYNC:       105
    CV_CAP_PROP_OPENNI_MAX_BUFFER_SIZE:         106
    CV_CAP_PROP_OPENNI_CIRCLE_BUFFER:           107
    CV_CAP_PROP_OPENNI_MAX_TIME_DURATION:       108
    CV_CAP_PROP_OPENNI_GENERATOR_PRESENT:       109
    CV_CAP_PROP_OPENNI2_SYNC:                   110
    CV_CAP_PROP_OPENNI2_MIRROR:                 111
    ;CV_CAP_OPENNI_IMAGE_GENERATOR_PRESENT:          CV_CAP_OPENNI_IMAGE_GENERATOR + CV_CAP_PROP_OPENNI_GENERATOR_PRESENT
    ;CV_CAP_OPENNI_IMAGE_GENERATOR_OUTPUT_MODE:      CV_CAP_OPENNI_IMAGE_GENERATOR + CV_CAP_PROP_OPENNI_OUTPUT_MODE
    ;CV_CAP_OPENNI_DEPTH_GENERATOR_BASELINE:         CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_BASELINE
    ;CV_CAP_OPENNI_DEPTH_GENERATOR_FOCAL_LENGTH:     CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_FOCAL_LENGTH
    ;CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION:     CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_REGISTRATION
    ;CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION_ON:  CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION
    ; Properties of cameras available through GStreamer interface
    CV_CAP_GSTREAMER_QUEUE_LENGTH:              200 ; default is 1
    ; PVAPI
    CV_CAP_PROP_PVAPI_MULTICASTIP:              300 ; ip for anable multicast master mode. 0 for disable multicast
    CV_CAP_PROP_PVAPI_FRAMESTARTTRIGGERMODE:    301 ; FrameStartTriggerMode:                              Determines how a frame is initiated
    CV_CAP_PROP_PVAPI_DECIMATIONHORIZONTAL:     302 ; Horizontal sub-sampling of the image
    CV_CAP_PROP_PVAPI_DECIMATIONVERTICAL:       303 ; Vertical sub-sampling of the image
    CV_CAP_PROP_PVAPI_BINNINGX:                 304 ; Horizontal binning factor
    CV_CAP_PROP_PVAPI_BINNINGY:                 305 ; Vertical binning factor
    CV_CAP_PROP_PVAPI_PIXELFORMAT:              306 ; Pixel format
     ; Properties of cameras available through XIMEA SDK interface
    CV_CAP_PROP_XI_DOWNSAMPLING:                400 ; Change image resolution by binning or skipping.
    CV_CAP_PROP_XI_DATA_FORMAT:                 401 ; Output data format.
    CV_CAP_PROP_XI_OFFSET_X:                    402 ; Horizontal offset from the origin to the area of interest (in pixels).
    CV_CAP_PROP_XI_OFFSET_Y:                    403 ; Vertical offset from the origin to the area of interest (in pixels).
    CV_CAP_PROP_XI_TRG_SOURCE:                  404 ; Defines source of trigger.
    CV_CAP_PROP_XI_TRG_SOFTWARE:                405 ; Generates an internal trigger. PRM_TRG_SOURCE must be set to TRG_SOFTWARE.
    CV_CAP_PROP_XI_GPI_SELECTOR:                406 ; Selects general purpose input
    CV_CAP_PROP_XI_GPI_MODE:                    407 ; Set general purpose input mode
    CV_CAP_PROP_XI_GPI_LEVEL:                   408 ; Get general purpose level
    CV_CAP_PROP_XI_GPO_SELECTOR:                409 ; Selects general purpose output
    CV_CAP_PROP_XI_GPO_MODE:                    410 ; Set general purpose output mode
    CV_CAP_PROP_XI_LED_SELECTOR:                411 ; Selects camera signalling LED
    CV_CAP_PROP_XI_LED_MODE:                    412 ; Define camera signalling LED functionality
    CV_CAP_PROP_XI_MANUAL_WB:                   413 ; Calculates White Balance(must be called during acquisition)
    CV_CAP_PROP_XI_AUTO_WB:                     414 ; Automatic white balance
    CV_CAP_PROP_XI_AEAG:                        415 ; Automatic exposure/gain
    CV_CAP_PROP_XI_EXP_PRIORITY:                416 ; Exposure priority (0.5 - exposure 50% gain 50%).
    CV_CAP_PROP_XI_AE_MAX_LIMIT:                417 ; Maximum limit of exposure in AEAG procedure
    CV_CAP_PROP_XI_AG_MAX_LIMIT:                418 ; Maximum limit of gain in AEAG procedure
    CV_CAP_PROP_XI_AEAG_LEVEL:                  419 ; Average intensity of output signal AEAG should achieve(in %)
    CV_CAP_PROP_XI_TIMEOUT:                     420 ; Image capture timeout in milliseconds
    ; Properties for Android cameras
    CV_CAP_PROP_ANDROID_FLASH_MODE:             8001
    CV_CAP_PROP_ANDROID_FOCUS_MODE:             8002
    CV_CAP_PROP_ANDROID_WHITE_BALANCE:          8003
    CV_CAP_PROP_ANDROID_ANTIBANDING:            8004
    CV_CAP_PROP_ANDROID_FOCAL_LENGTH:           8005
    CV_CAP_PROP_ANDROID_FOCUS_DISTANCE_NEAR:    8006
    CV_CAP_PROP_ANDROID_FOCUS_DISTANCE_OPTIMAL: 8007
    CV_CAP_PROP_ANDROID_FOCUS_DISTANCE_FAR:     8008
    CV_CAP_PROP_ANDROID_EXPOSE_LOCK:            8009
    CV_CAP_PROP_ANDROID_WHITEBALANCE_LOCK:      8010
    ; Properties of cameras available through AVFOUNDATION interface
    CV_CAP_PROP_IOS_DEVICE_FOCUS:               9001
    CV_CAP_PROP_IOS_DEVICE_EXPOSURE:            9002
    CV_CAP_PROP_IOS_DEVICE_FLASH:               9003
    CV_CAP_PROP_IOS_DEVICE_WHITEBALANCE:        9004
    CV_CAP_PROP_IOS_DEVICE_TORCH:               9005
    ; Properties of cameras available through Smartek Giganetix Ethernet Vision interface
    ;/* --- Vladimir Litvinenko (litvinenko.vladimir@gmail.com) --- */
    CV_CAP_PROP_GIGA_FRAME_OFFSET_X:            10001
    CV_CAP_PROP_GIGA_FRAME_OFFSET_Y:            10002
    CV_CAP_PROP_GIGA_FRAME_WIDTH_MAX:           10003
    CV_CAP_PROP_GIGA_FRAME_HEIGH_MAX:           10004
    CV_CAP_PROP_GIGA_FRAME_SENS_WIDTH:          10005
    CV_CAP_PROP_GIGA_FRAME_SENS_HEIGH:          10006

    CV_CAP_PROP_INTELPERC_PROFILE_COUNT:        11001
    CV_CAP_PROP_INTELPERC_PROFILE_IDX:          11002
    CV_CAP_PROP_INTELPERC_DEPTH_LOW_CONFIDENCE_VALUE:   11003
    CV_CAP_PROP_INTELPERC_DEPTH_SATURATION_VALUE:       11004
    CV_CAP_PROP_INTELPERC_DEPTH_CONFIDENCE_THRESHOLD:   11005
    CV_CAP_PROP_INTELPERC_DEPTH_FOCAL_LENGTH_HORZ:      11006
    CV_CAP_PROP_INTELPERC_DEPTH_FOCAL_LENGTH_VERT:      11007
    CV_CAP_INTELPERC_DEPTH_GENERATOR:                   536870912
    CV_CAP_INTELPERC_IMAGE_GENERATOR:                   268435456
    CV_CAP_INTELPERC_GENERATORS_MASK:                   805306368
]

#enum cameramode [
    CV_CAP_MODE_BGR:    0;BGR24 (default)
    CV_CAP_MODE_RGB:    1; RGB24
    CV_CAP_MODE_GRAY:   2;Y8
    CV_CAP_MODE_YUYV:   3;YUYV
]

#enum dg [
; Data given from depth generator.
    CV_CAP_OPENNI_DEPTH_MAP:            0 ; Depth values in mm (CV_16UC1)
    CV_CAP_OPENNI_POINT_CLOUD_MAP:      1 ; XYZ in meters (CV_32FC3)
    CV_CAP_OPENNI_DISPARITY_MAP:        2 ; Disparity in pixels (CV_8UC1)
    CV_CAP_OPENNI_DISPARITY_MAP_32F:    3 ; Disparity in pixels (CV_32FC1)
    CV_CAP_OPENNI_VALID_DEPTH_MASK:     4 ; CV_8UC1
    ; Data given from RGB image generator.
    CV_CAP_OPENNI_BGR_IMAGE:            5
    CV_CAP_OPENNI_GRAY_IMAGE:           6 
]

#enum nimodes[
    CV_CAP_OPENNI_VGA_30HZ:     0
    CV_CAP_OPENNI_SXGA_15HZ:    1
    CV_CAP_OPENNI_SXGA_30HZ:    2
    CV_CAP_OPENNI_QVGA_30HZ:    3
    CV_CAP_OPENNI_QVGA_60HZ:    4
]

#enum interperc[
    CV_CAP_INTELPERC_DEPTH_MAP:     0 ; Each pixel is a 16-bit integer. The value indicates the distance from an object to the camera's XY plane or the Cartesian depth.
    CV_CAP_INTELPERC_UVDEPTH_MAP:   1 ; Each pixel contains two 32-bit floating point values in the range of 0-1 representing the mapping of depth coordinates to the color coordinates.
    CV_CAP_INTELPERC_IR_MAP:        2 ; Each pixel is a 16-bit integer. The value indicates the intensity of the reflected laser beam.
    CV_CAP_INTELPERC_IMAGE:         3
]

#enum gPhoto2[
    CV_CAP_PROP_GPHOTO2_PREVIEW:            17001 ; Capture only preview from liveview mode.
    CV_CAP_PROP_GPHOTO2_WIDGET_ENUMERATE:   17002 ; Readonly returns (const char *).
    CV_CAP_PROP_GPHOTO2_RELOAD_CONFIG:      17003 ; Trigger only by set. Reload camera settings.
    CV_CAP_PROP_GPHOTO2_RELOAD_ON_CHANGE:   17004 ; Reload all settings on set.
    CV_CAP_PROP_GPHOTO2_COLLECT_MSGS:       17005 ; Collect messages with details.
    CV_CAP_PROP_GPHOTO2_FLUSH_MSGS:         17006 ; Readonly returns (const char *).
    CV_CAP_PROP_SPEED:                      17007 ; Exposure speed. Can be readonly depends on camera program.
    CV_CAP_PROP_APERTURE:                   17008 ; Aperture. Can be readonly depends on camera program.
    CV_CAP_PROP_EXPOSUREPROGRAM:            17009 ; Camera exposure program.
    CV_CAP_PROP_VIEWFINDER:                 17010  ; Enter liveview mode.
]

;inline functions
; great with Red 0.31 we can define macros!!!
#define CV_FOURCC(c1 c2 c3 c4) [(((((as integer! c1)) and 255) + (((as integer! c2) and 255) << 8) + (((as integer! c3) and 255) << 16) + (((as integer! c4) and 255) << 24)))]

CV_FOURCC_PROMPT:        -1  ; Open Codec Selection Dialog (Windows only) */
CV_FOURCC_DEFAULT:       -1  ;CV_FOURCC('I' 'Y' 'U' 'V') ; Use default codec for specified filename (Linux only) */

#import [
    cvVideoio importMode [
        cvCreateFileCapture: "cvCreateFileCapture" [
        "start capturing frames from video file."
			filename        [c-string!]
			return:         [CvCapture!]
		]
		
		cvCaptureFromFile: "cvCreateFileCapture" [
		"start capturing frames from video file."
			filename        [c-string!]
			return:         [CvCapture!]
		] 
		
		cvCaptureFromAVI: "cvCreateFileCapture" [
        "start capturing frames from video file."
			filename        [c-string!]
			return:         [CvCapture!]
		] 
		
        cvCreateCameraCapture: "cvCreateCameraCapture" [
        "start capturing frames from camera: index = camera_index + domain_offset (CV_CAP_*)"
			index           [integer!]
			return:         [CvCapture!] ;an implicit pointer in Red     
		]
		
		cvCaptureFromCAM: "cvCreateCameraCapture" [
        "start capturing frames from camera: index = camera_index + domain_offset (CV_CAP_*)"
			index           [integer!]
			return:         [CvCapture!] ;an implicit pointer in Red     
		]
	
        cvGrabFrame: "cvGrabFrame" [
        "grab a frame, ATTENTION return 1 on success, 0 on fail"
			capture         [CvCapture!]
			return:         [integer!]
		]
        
        ;!!!DO NOT RELEASE or MODIFY the retrieved frame!!!
        cvRetrieveFrame: "cvRetrieveFrame" [
        "get the frame grabbed with cvGrabFrame(..). This function may apply some frame processing like frame decompression, flipping etc."
			capture         [CvCapture!]
			return:         [IplImage!]
		]
        
        cvQueryFrame: "cvQueryFrame" [
        "Just a combination of cvGrabFrame and cvRetrieveFrame."
			capture         [CvCapture!]
			return:         [IplImage!]
		]
        
        cvReleaseCapture: "cvReleaseCapture" [
			capture		[double-int-ptr!]
			return:         [integer!]
		]
        
        cvGetCaptureProperty: "cvGetCaptureProperty" [
        "retrieve or set capture properties."
			capture         [CvCapture!] 
			property_id     [integer!]
			return:         [float!] ; double in c (64-bit)
		]
        
        cvSetCaptureProperty: "cvSetCaptureProperty" [
        "retrieve or set capture properties."
			capture         [CvCapture!]
			property_id     [integer!]
			value           [float!] ; double in c (64-bit)
			return:         [integer!]
		]
        
        cvGetCaptureDomain: "cvGetCaptureDomain" [
            capture         [CvCapture!]
            return:         [integer!]   
        ]
        
        cvCreateVideoWriter: "cvCreateVideoWriter" [
        "initialize video file writer"
			filename        [c-string!]
			fourcc          [integer!]
			pfs             [float!] ; double in c (32-bit)
			;frame-size      [cvSize!] ; use 2 integers rather cvSize! structure!
            width           [integer!]
            height          [integer!]
			is_color        [integer!] ;CV_DEFAULT(1))
			return:         [CvVideoWriter!]
		]
	
	cvCreateAVIWriter: "cvCreateVideoWriter" [
        "initialize video file writer"
			filename        [c-string!]
			fourcc          [integer!]
			pfs             [float!] ; double in c (32-bit)
			;frame-size      [cvSize!] ; use 2 integers rather cvSize! structure!
            width           [integer!]
            height          [integer!]
			is_color        [integer!] ;CV_DEFAULT(1))
			return:         [CvVideoWriter!]
	]
        
	cvWriteFrame: "cvWriteFrame" [
        ";write frame to video file."
	    writer          [CvVideoWriter!]
	    image           [IplImage!]
        return:         [integer!]
	]
	
	cvWriteToAVI: "cvWriteFrame" [
        "write frame to video file."
	    writer          [CvVideoWriter!]
	    image           [IplImage!]
        return:         [integer!]
	]
	
        
	cvReleaseVideoWriter: "cvReleaseVideoWriter" [
        "close video file writer."
        writer**          [double-byte-ptr!]
	]
    ] ;end videoio
    
    ; specific C++ access for windows Users (see libs/cvcapture for details)
    cvVideocapture importMode [
    	openCamera: "openCamera"[
    	"Open Camera"
    	    index   [integer!]
    	    return: [integer!]
        ]
        releaseCamera: "releaseCamera" [
        "Release Camera"
        ]
        setCameraProperty: "setCameraProperty" [
        "Set Camera property"
            propId  [integer!]
            value   [float!]
            return: [integer!]
        ]
        
        getCameraProperty: "getCameraProperty" [
        "Get Camera property"
            propId  [integer!]
            return: [float!]
        ]
        
        readCamera: "readCamera"[
        "Read camera frame"
            return: [integer!] ; return image address
        ]
        grabFrame: "grabFrame" [
        "Grab frame"
            return: [integer!]
        ]
        retrieveFrame: "retrieveFrame"[
        "Retrieve grabbed image"
            flag    [integer!]  ;int=0
            return: [integer!]  ;return image address
        ]
        
        openFile: "openFile" [
        "Open video file"
            filename    [c-string!]
            return:     [integer!]
        ]
        
        openFileApi: "openFileApi"[
        "Open video file and force encoding"
            filename        [c-string!]
            apiPreference   [integer!]
            return:         [integer!]
        ]
        
    ]; end cvVideocapture
    
] ; end import


; a shortcut for capture release if using CvCapture! black box.

releaseCapture: func [capture [CvCapture!] /local &capture] [
	&capture: declare double-int-ptr!;  C function needs a double pointer
	&capture/ptr: capture
	cvReleaseCapture &capture
]







