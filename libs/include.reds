Red/System [
	Title:		"OpenCV 3.0.0 Binding"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015-2016 F.Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %red/types_r.reds           	; some specific structures for Red/S 
#include %core/types_c.reds          	; basic OpenCV types and structures
#include %core/cvCore.reds             	; OpenCV core functions
#include %calib3d/cvCalib3D.reds		; for using different cameras
#include %highgui/cvHighgui.reds       	; highgui functions
#include %imgcodecs/cvImgcodecs.reds   	; basic image functions
#include %imgproc/types_c.reds       	; image processing types and structures
#include %imgproc/cvImgproc.reds		; image processing functions
#include %objdetect/cvObjdetect.reds	; object detection with classifiers
#include %photo/cvPhoto.reds			; photo impainting
#include %video/cvVideo.reds       		; motion analysis and motion tracking 
#include %videoio/cvVideoio.reds       	; video and movies functions


; to get an image and a movie. Adapt according to your paths and images
#switch OS [
	MacOSX  [picture: "/Users/fjouen/Pictures/lena.tiff" movie: "/Users/fjouen/Movies/skate.mp4"]
	Windows [picture: "c:\Users\palm\Pictures\lena.tif" movie: "c:\Users\palm\Videos\skate.mp4"]
	Linux  	[picture: "/home/fjouen/Images/lena.tiff" movie: "/home/fjouen/Vidéos/skate.mp4"]
]