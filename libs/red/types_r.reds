Red/System [
	Title:		"OpenCV Red Types"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2015 F. Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]




;****************** we need some specific structures for talking to OPenCV  **************

#define size_t 4; 32-bits library

; * pointers
;int-ptr! is defined by red
;byte-ptr is defined by red
#define float32-ptr!        [pointer! [float32!]]
#define float-ptr!          [pointer! [float!]]

;** pointers
#define double-byte-ptr!    [struct! [ptr [byte-ptr!]]]    ; equivalent to C's byte **
#define double-int-ptr!     [struct! [ptr [int-ptr!]]]     ; equivalent to C's int **
#define double-float-ptr!   [struct! [ptr [float-ptr!]]]   ; equivalent to C's double **
#define p-buffer!           [struct! [buffer [c-string!]]] ; equivalent to C's char **

dbptr!: alias struct! [
	ptr [byte-ptr!]
]

diptr!: alias struct! [
	ptr [int-ptr!]
]


#define _none					null
#define none?					[_none = ]

{This is the "metatype" used *only* as a function parameter.
It denotes that the function accepts arrays of multiple types, such as IplImage*, CvMat* or even
CvSeq* sometimes. The particular array type is determined at runtime by analyzing the first 4
bytes of the header.}
#define CvArr! byte-ptr!

