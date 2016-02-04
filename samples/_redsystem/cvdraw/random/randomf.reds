Red/System []
#include %random-taocp.reds

random-type: "s"


random-seed: function [seed [integer!]][
    random-taocp/ran_start seed
]

random: function [return: [integer!]][
    random-taocp/ran_arr_next 
]