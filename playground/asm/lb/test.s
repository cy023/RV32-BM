# Load Byte (Signed)
# Format:
#	LB RD, IMM(RS1)
# Description:
#	An 8-bit value is fetched from memory and moved into register RD. The
#	memory address is formed by adding the offset(IMM) to the contents of RS1.
#	The 8-bit value is sign-extended to the full length of the register.
# Note: 
#	Due to IMM is 12 bits width, the target location given by the 
#	offset(IMM) must be within the range of -2,048 .. 2,047 relative to the
#	value in RS1.

.text				# Define beginning of text section
.global	_start		# Define entry _start

_start:
	la x5, _array	# char *x5 = &(array[0])
	lb x6, 0(x5)	# char x6 = *x5
	lb x7, 1(x5)	# char x7 = *(x5 + 1)

stop:
	j stop			# Infinite loop to stop execution

_array:	
	.byte 0x11
	.byte 0xff

.end				# End of file
