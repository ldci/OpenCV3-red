Red/System []

#include %randomf.reds
#include %user.reds
random-seed 310952

print ["Random numbers test! Prints 111 random numbers!" lf]
m: 1
rval: 0.0
while [m <= 111][
    rval: int-to-float random / 6553600
    print ["Count: " m " generated random value: " rval lf]
    m: m + 1
]

print ["End of program." lf]
