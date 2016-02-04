Red/System[
	Title: "user.reds" 
	Author: "Boleslav Brezovsky" 
	Date: "12-7-2012"
]

; --- definitions

pi: 3.14159265358979
type-int16!: 10001

; --- math 

abs: func[
	x [integer!]
	return: [integer!]
][
	(x xor (x >> 31)) - (x >> 31)
]

fabs: func [
	x			[float!]
	return:	[float!]
][
	x: either x < 0.0 [0.0 - x][x]
	x
]

float-to-int: func [
	number 	[float!]
	return:	[integer!]
	/local magic-number data ptr
][
	magic-number: 68719476736.0 * 1.5
	data: declare struct! [
		float [float!]
	]
	data/float: number + magic-number
	; TODO: simplify this!
	ptr: as byte-ptr! data
	val1: as integer! ptr/3
	val2: as integer! ptr/4
	val3: as integer! ptr/5
	val4: as integer! ptr/6
	(16777216 * val4) + (65536 * val3) + (256 * val2) + val1
]

int-to-float: func [
	n [integer!]
	return: [float!]
	/local sign shifts less?
][
	sign: 0
	shifts: 0
	less?: true

;    1. If N is negative, negate it in two's complement. Set the high bit (2^31) of the result.
	if n < 0 [
		; note: FIXME: once bug #224 is fixed
		n: 0 or not n - 1
		sign: 1 << 31
	]

;    2. If N < 2^23, left shift it (multiply by 2) until it is greater or equal to.
	while [n < 00800000h] [
		less?: true
		shifts: shifts + 1
		n: n << 1
	]

;    3. If N >= 2^24, right shift it (unsigned divide by 2) until it is less.
	while [n >= 01000000h] [
		less?: false
		shifts: shifts + 1
		n: n >> 1
	]

;    4. Bitwise AND with ~2^23 (one's complement).
	n: n and not 00800000h

;    5. If it was less, subtract the number of left shifts from 150 (127+23).
	if all [less? 0 < shifts][
		shifts: 150 - shifts
	]

;    6. If it was more, add the number of right shifts to 150.
	if all [not less? 0 < shifts][
		shifts: 150 + shifts
	]
;    7. This new number is the exponent. Left shift it by 23 and add it to the number from step 3.
	shifts: shifts << 23
;	n + shifts
	
;	hack to convert float32! to float64!
	0.0 + as float32! sign or n + shifts
]


**: func [
	[infix]
	number	[integer!]
	power	[integer!]
	return:	[integer!]
	/local i result
][
	i: 0
	result: 1
	while [i < power][
		result: result * number
		i: i + 1
	]
	result
]

; --- strings

equal?: func [
	; compare two strings
	string1	[c-string!]
	string2	[c-string!]
	return:	[logic!]
	/local i l s1 s2
][
	l: length? string1
	either l = (length? string2) [
		i: 0
		while [i < l][
			s1: string1 + i
			s2: string2 + i
			unless s1/1 = s2/1 [return false]
			i: i + 1
		]
		true
	][
		false
	]
]

find: func[
	string	[c-string!]
	match	[c-string!]
	return:	[c-string!]	; return index 
	/local substring match?
][
	out: string
	substring: string
	match?: false
	until [
		if match/1 = string/1 [
			match?: true
			substring: string
			until [
				if match/1 <> substring/1 [match?: false]
				match: match + 1
				substring: substring + 1
				null-byte = match/1
			]
			if match? [
				return string
			]
		]
		string: string + 1
		string/1 = null-byte
	]
	return ""
]

; --- test

