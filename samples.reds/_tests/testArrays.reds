Red/System [	Title:		"OpenCV Tests: Tests"	Author:		"F. Jouen"	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"]print ["List" lf]list: [123 456 789]n: size? list     probe nsf: [512.0 255.0 127.0 64.0 32.0 16.0 8.0 4.0 2.0 1.0] n: size? sfprint "Pointer to array of floats"print newlineprint ["Size: " n lf]print ["All elements " lf]print "Address: "probe sfi: 1while [i <= n][    print [i ": " sf/i lf]    i: i + 1]