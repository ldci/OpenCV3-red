Red/System [
	Title:		"OpenCV 3.0.0 Binding: highgui"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#define importMode cdecl 

#switch OS [
    MacOSX  [
        #define calib3d "/usr/local/lib32/opencv3/libopencv_world.dylib" 
        #define core "/usr/local/lib32/opencv3/libopencv_world.dylib" 
        #define highgui "/usr/local/lib32/opencv3/libopencv_world.dylib" 
        #define imgcodecs "/usr/local/lib32/opencv3/libopencv_world.dylib" 
        #define imgproc "/usr/local/lib32/opencv3/libopencv_world.dylib" 
        #define objdetect "/usr/local/lib32/opencv3/libopencv_world.dylib" 
        #define photo "/usr/local/lib32/opencv3/libopencv_world.dylib" 
        #define video "/usr/local/lib32/opencv3/libopencv_world.dylib" 
        #define videoio "/usr/local/lib32/opencv3/libopencv_world.dylib"
        #define videocapture "/usr/local/lib32/xcode/libcameraLib.dylib"
    ]
    Windows [
        #define highgui "c:\opencv310\build\x86\mingw\libopencv_world310.dll" 
        #define calib3d "c:\opencv310\build\x86\mingw\libopencv_world310.dll" 
        #define core "c:\opencv310\build\x86\mingw\libopencv_world310.dll" 
        #define imgcodecs "c:\opencv310\build\x86\mingw\libopencv_world310.dll" 
        #define imgproc "c:\opencv3\build\x86\vc12\bin\libopencv_world300.dll"
        #define objdetect "c:\opencv310\build\x86\mingw\libopencv_world310.dll" 
        #define photo "c:\opencv310\build\x86\mingw\libopencv_world310.dll" 
        #define video "c:\opencv310\build\x86\mingw\libopencv_world310.dll" 
        #define videoio "c:\opencv310\build\x86\mingw\libopencv_world310.dll" 
        #define videocapture "c:\opencv310\build\x86\mingw\cameraLib.dll"
    ]
    Linux   [
        #define highgui "/usr/local/lib/libopencv_world.so.3.0.0" 
        #define calib3d "/usr/local/lib/libopencv_world.so.3.0.0" 
        define core "/usr/local/lib/libopencv_world.so.3.0.0" 
        #define imgcodecs "/usr/local/lib/libopencv_world.so.3.0.0" 
        #define imgproc "/usr/local/lib/libopencv_world.so.3.0.0" 
        #define objdetect "/usr/local/lib/libopencv_world.so.3.0.0" 
        #define photo "/usr/local/lib/libopencv_world.so.3.0.0" 
        #define video "/usr/local/lib/libopencv_world.so.3.0.0" 
        #define videoio "/usr/local/lib/libopencv_world.so.3.0.0" 
        #define videocapture ""
    ]
]



