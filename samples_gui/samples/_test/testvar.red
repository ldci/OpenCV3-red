Red [
Title:		"OpenCV Tests"
]

; some tests 
; the way to access global Red variables

i: 100 ; integer
f: 0.012345 ; float
s: "Hello Red" ; string

testint: routine [/local int][
	int: as red-integer! #get 'i
	print int/value
]


testFloat: routine [/local fl][
	fl: as red-float! #get 'f
	print fl/value
]

testStr: routine [/local st][
	st: as red-string! #get 's
	print as c-string! string/rs-head st
]


testStr2: does [
	s: "Second test"
	testStr
]


print "Test Integer " testint
print lf

print "Test Float " testFloat
print lf

print "Test String " testStr
print lf

print s
testStr2
print lf
print s 
print lf

print "done"
