set hex 0x5FABFF01
puts "Initial hex : $hex"

# Get second byte using right-shift to 8th bit 
# Bitwise AND with 0xFF to get 8 required bits of shifted value and set the rest to 0
set param1 [expr {($hex >> 8) & 0xFF}]

# Same bit extraction model. 
# To invert bit uses bitwise NOT '!' 
set bit7 [expr {($hex >> 7) & 1}]
set param2 [expr {!$bit7}]

# Same bit extraction model. 
# It has '& 0xF' to get exact 4 bits from hex
set bits17to20 [expr {($hex >> 16) & 0xF}]
set param3 [expr {((($bits17to20 & 1) << 3) | (($bits17to20 & 2) << 1) | (($bits17to20 & 4) >> 1) | (($bits17to20 & 8) >> 3))}]

puts "First additional param : $param1"
puts "Second additional param : $param2"
puts "Third additional param : $param3" 

