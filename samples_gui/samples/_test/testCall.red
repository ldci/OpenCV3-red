Red [
	Title:		"OpenCV Tests: random functions"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2016 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;#include %system/library/call/call.red 
;prog: "open ~/Pictures/*.jpg"
;call reduce [prog]


#system-global[
  ;??? TBA Nenad
]
 print ["Red Version: "system/version]
 print ["Compiled: " system/build]
 print ["on: " system/platform]

rand: func [n [integer!]][random n] ; by default return an integer

#system [
   v: 1000 			; global Red/S variable to be used inside routines 
   #call [rand v]
   int: as red-integer! stack/arguments
   print ["System " int/value lf]
   
]

; test with a routine
alea: routine [][
	#call [rand v]
	int: as red-integer! stack/arguments
	int/value
]

v: 64 ; this a red variable not the Red/S variable
; red can directly call the randRS function
print [v " Red Function " rand v]
print [v " Red Function " rand v]
print [v " Red Function " rand v]



print ["Routine " alea ]
print ["Routine " alea ]
print ["Routine " alea ]


