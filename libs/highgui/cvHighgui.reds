Red/System [
	Title:		"OpenCV 3.0.0 Binding: highgui"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../../libs/platforms.reds            ; lib path according to os
#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structuresÒ


; OpenCV Highgui C Functions

;/****************************************************************************************\
;*                                  Basic GUI functions                                   *
;\****************************************************************************************


; for callback ; this corresponds to function prototyped as void position(int) OK
#define CvTrackbarCallback! [function! [position [integer!]]]
#define CvTrackbarCallback2! [function! [position [integer!] userdata [byte-ptr!]]]
#define CvOpenGlDrawCallback! [function! [userdata [byte-ptr!]]]



;for mouse events: OK 
#define CvMouseCallback! [function! [
        event 	        [integer!] 
        x 				[integer!]
        y 				[integer!]
        flags	        [integer!]
        param           [byte-ptr!]
    ]
]


;///-----------New for Qt
;/* For font */

#enum QTFonts [
    CV_FONT_LIGHT:      25;QFont::Light,
    CV_FONT_NORMAL:     50;QFont::Normal,
    CV_FONT_DEMIBOLD:   63;QFont::DemiBold,
    CV_FONT_BOLD:       75;QFont::Bold,
    CV_FONT_BLACK:      87;QFont::Black
]

#enum QTStyles [
    CV_STYLE_NORMAL:    0;QFont::StyleNormal,
    CV_STYLE_ITALIC:    1;QFont::StyleItalic,
    CV_STYLE_OBLIQUE:   2;QFont::StyleOblique,
]

#enum QTControls [
    CV_PUSH_BUTTON:     0;
    CV_CHECKBOX:        1;
    CV_RADIOBOX:        2;
]
; end for QT

#enum wFlags [
    ; These flags are used by cvSet/GetWindowProperty
    CV_WND_PROP_FULLSCREEN:		0  ; to change/get window's fullscreen property
    CV_WND_PROP_AUTOSIZE:		1  ; to change/get window's autosize property
    CV_WND_PROP_ASPECTRATIO:	2  ; to change/get window's aspectratio property
    CV_WND_PROP_OPENGL:			3  ; to change/get window's opengl support

    ; These 2 flags are used by cvNamedWindow and cvSet/GetWindowProperty
    CV_WINDOW_NORMAL:			00000000h   ;the user can resize the window (no constraint)  / also use to switch a fullscreen window to a normal size
    CV_WINDOW_AUTOSIZE:			00000001h   ;the user cannot resize the window, the size is constrainted by the image displayed
    CV_WINDOW_OPENGL:			00001000h   ;window with opengl support

    ; Those flags are only for Qt
    CV_GUI_EXPANDED: 			00000000h  ;status bar and tool bar
    CV_GUI_NORMAL:          	00000010h;  //old fashious way

    ;These 3 flags are used by cvNamedWindow and cvSet/GetWindowProperty;
    CV_WINDOW_FULLSCREEN:		1           ; change the window to fullscreen
    CV_WINDOW_FREERATIO:		00000100h   ; the image expends as much as it can (no ratio raint)
    CV_WINDOW_KEEPRATIO:		00000000h   ; the ratio image is respected.;  
]

#enum mouseEvents [
    CV_EVENT_MOUSEMOVE: 		0
    CV_EVENT_LBUTTONDOWN: 		1
    CV_EVENT_RBUTTONDOWN: 		2
    CV_EVENT_MBUTTONDOWN: 		3
    CV_EVENT_LBUTTONUP: 		4
    CV_EVENT_RBUTTONUP: 		5
    CV_EVENT_MBUTTONUP: 		6
    CV_EVENT_LBUTTONDBLCLK: 	        7
    CV_EVENT_RBUTTONDBLCLK: 	        8
    CV_EVENT_MBUTTONDBLCLK: 	        9
    CV_EVENT_MOUSEWHEEL:                10
    CV_EVENT_MOUSEHWHEEL:               11    
]

#enum eventFlags[
    CV_EVENT_FLAG_LBUTTON: 		1
    CV_EVENT_FLAG_RBUTTON: 		2
    CV_EVENT_FLAG_MBUTTON: 		4
    CV_EVENT_FLAG_CTRLKEY: 		8
    CV_EVENT_FLAG_SHIFTKEY: 	16
    CV_EVENT_FLAG_ALTKEY: 		32
]

CV_GET_WHEEL_DELTA: func [flags [integer!] return: [integer!]][
    ;// upper 16 bits
    (flags >> 16) AND FFFFh
]


#import [
    cvHighgui importMode [
        cvInitSystem: "cvInitSystem" [
        "This function is used to set some external parameters in case of X Window"
	    argc 	[integer!]
	    char** 	[c-string!]
	    return: [integer!]
		]
        ;Start a separated window thread that will manage mouse events inside the windows. Status : OK  
        cvStartWindowThread: "cvStartWindowThread" []
        
        cvNamedWindow: "cvNamedWindow" [
        "create window :flags CV_DEFAULT(CV_WND_PROP_AUTOSIZE) )"
			name 	[c-string!]
			flags 	[integer!]
			return: [integer!]
		]
        
        cvSetWindowProperty: "cvSetWindowProperty" [
        "Set Property of the window"
             name 	[c-string!]
             prop_id 	[integer!]
             prop_value [float!]
        ]
        
        cvGetWindowProperty: "cvGetWindowProperty" [
        "Get Property of the window"
             name 		[c-string!]
             prop_id 	[integer!]
        ]
        
        cvShowImage:"cvShowImage" [
        "display image within window (highgui windows remember their content)"
            name            [c-string!]
			image           [CvArr!] ; 
		]
        
        cvResizeWindow: "cvResizeWindow" [
        "resize window"
			name 	[c-string!]
			width 	[integer!]
			height 	[integer!]
		]	
        
        cvMoveWindow: "cvMoveWindow" [
        "move window"
			name    [c-string!]
			x 	    [integer!]
			y 	    [integer!]
		]
        
        cvDestroyWindow: "cvDestroyWindow" [
        "destroy window and all the trackers associated with it"
			name [c-string!]
		]
        cvDestroyAllWindows: "cvDestroyAllWindows" [
        ]
        
        cvGetWindowHandle: "cvGetWindowHandle" [
        "get native window handle (HWND in case of Win32 and Widget in case of X Window)"
			name 	[c-string!]
			return:     [int-ptr!] ; handle: void*  
		]
        
        cvGetWindowName: "cvGetWindowName" [
        "get name of highgui window given its native handle"
			window_handle 	[int-ptr!]; void*
			return: 	        [c-string!]
		]
        
        cvCreateTrackbar: "cvCreateTrackbar" [
        "create trackbar and display it on top of given window, set callback"
            trackbar_name   [c-string!]
			window_name     [c-string!]
			value           [int-ptr!] ; a pointer int* value
			count           [integer!]
			on_change       [CvTrackbarCallback!] ; Pointer to the function; can be null (none)
            return: 	    [integer!]	
		]
        
        cvCreateTrackbar2: "cvCreateTrackbar2" [
        "create trackbar and display it on top of given window, set callback"
            trackbar_name   [c-string!]
			window_name     [c-string!]
			value           [int-ptr!] ; a pointer int* value
			count           [integer!]
			on_change       [CvTrackbarCallback!] ; Pointer to the function; can be null (none)
            userdata        [byte-ptr!]; CV_DEFAULT(0)
            return: 	    [integer!]	
		]
        
        cvGetTrackbarPos: "cvGetTrackbarPos" [
        "retrieve trackbar position"
			trackbar_name   [c-string!]
			window_name     [c-string!]
			return:         [integer!]
		]
        
        cvSetTrackbarPos: "cvSetTrackbarPos" [
        "set trackbar position"
			trackbar_name   [c-string!]
			window_name     [c-string!]
            pos             [integer!]
		]
        cvSetTrackbarMax: "cvSetTrackbarMax" [
        "set max value for trackbar"
			trackbar_name   [c-string!]
			window_name     [c-string!]
            maxval          [integer!]
		]
        
        cvSetMouseCallback: "cvSetMouseCallback" [
        "assign callback for mouse events"
			window_name     [c-string!]
			on_mouse        [CvMouseCallback!] ; pointer sur une fonction
            param	    [byte-ptr!] ; must be null
        ]
        
        cvWaitKey: "cvWaitKey" [
        "wait for key event infinitely (delay<=0) or for delay milliseconds"
			delay           [integer!]
			return:         [integer!]
		]
        
        cvSetOpenGlDrawCallback: "cvSetOpenGlDrawCallback" [
        "OpenGL support"
            window_name     [c-string!]
            glCallback       [CvOpenGlDrawCallback!]
            userdata        [byte-ptr!]
        ]
        
        cvSetOpenGlContext: "cvSetOpenGlContext" [
        "OpenGL support"
            window_name     [c-string!]  
        ]
        
        cvUpdateWindow: "cvUpdateWindow" [
        "OpenGL support"
            window_name     [c-string!]  
        ]
    
    ] ; end cedl  
]  ; end import



