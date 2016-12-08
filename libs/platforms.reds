Red/System [
	Title:		"OpenCV 3.0.0 Binding"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015-2016 F.Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; cette version fonctionne avec Red-061 et master

#define importMode cdecl 

; adapt libraries paths for your own use :)
; this will be changed in future for relative paths

#switch OS [
    MacOSX  [
    	#define cvWorld "/usr/local/lib32/opencv3/libopencv_world.dylib"
    ]
    Windows [
    	#define cvWorld "c:\opencv310\build\x86\mingw\libopencv_world310.dll"
    ]
    Linux   [
    	#define cvWorld "/usr/local/lib/libopencv_world.so.3.1.0"  
    ]
]

; our OpenCV dynamic librairies access
#define cvCalib3d cvWorld
#define cvCore cvWorld
#define cvHighgui cvWorld
#define cvImgcodecs cvWorld
#define cvImgproc cvWorld
#define cvObjdetect cvWorld
#define cvPhoto cvWorld
#define cvVideo cvWorld
#define cvVideoio cvWorld
