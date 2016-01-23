# Red Binding for OpenCV 3.0 
## see http://www.red-lang.org and http://opencv.org


### This binding has been tested with Mac OSX 10.11.3 and Windows 10.

### This binding allows access about 600 basic OpenCV functions.
### This binding can used with 3.0 and higher version of opencv library.

###You must use 32-bit version of dynamically linked libraries. 

### NEW : January 2016
Camera problems with windows are solved! You'll find in /libs/cvapture/src/ a C++ code for a library allowing access to camera with C++ functions. Code must be compiled by yourself. Exported functions are declared in /libs/videoio/videoio.reds. 

Libs and samples are now compatible with Opencv 3.0.1. For versions < 3.0.0 you have to adapt the code according to OpenCV directories and C implementation.

images and movies used in samples are included in _images directory.

file /libs/plateforms.reds is easier to use according to your configuartion for libaraies access.

New samples are incuded. Enjoy! 

### NEW : December 2015 
Libs and samples are now compatible with red master branch! Better support for float! and block! types.

Linux support also added!

## Warning
The code is still under development and unstable. This software is provided 'as-is', without any express or implied warranty.

## Directories
### opencv3.0
This directory includes 32-bit compiled dynamic libraries for OSX and Windows. Linux version ASAP.
### libs
This directory includes different red/system files that are required to access opencv libs. You'll also find orginal C_Functions.

### samples
Several scripts which demonstrate how to use OpenCV with Red. Please adapt paths according to your needs. More samples to come :)


These scripts allow to play with camera and images.
All scrpits are now compiled with Red Master Branch 0.5.4 compiler and are fully functional under OSX and Windows. Tests required for Linux.
Windows 10 users: there is a unresolved problem with webcams.Cams are recognized and activated but we can't get images. To be tested!


### Red and Red/System code 
All scripts are Red scripts and intensively use routines to access Red/System code.

### required includes 

libs/red/types_r.reds           ; some specific structures for Red/S 

libs/core/types_c.reds          ; basic OpenCV types and structures

libs/core/core.reds             ; OpenCV core functions

### optional includes

libs/calib3d/calib3D.reds		 ; for using different cameras

libs/highgui/highgui.reds       ; highgui functions

libs/imgproc/types_c.reds       ; image processing types and structures

libs/imgcodecs/imgcodecs.reds   ; basic image functions

libs/imgproc/imgproc.reds		 ; image processing functions

libs/objdetect/objdetect.reds	 ; object detection with classifiers

libs/photo/photo.reds			 ; photo impainting

libs/video/video.reds       	 ; Motion Analysis and Motion Tracking 

libs/videoio/videoio.reds       ; Video and Movies functions

##enjoy:)