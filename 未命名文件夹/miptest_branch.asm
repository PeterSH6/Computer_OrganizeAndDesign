# following code test blez instruction
blez:   addi $2, $0, 1      # initialize $2 = 1
        addi $3, $0, 1      # initialize $3 = 1
        addi $7, $0, 3      # initialize $7 = 1
loop1:  add  $8, $2, $3	    # $8 <= $2 + $3
	add  $2, $0, $3     # $2 <= $3
	add  $3, $0, $8     # $3 <= $8
	addi $7, $7, 1      # $7 <= $7 + 1
	addi $6, $7, -10     
	blez $6, loop1 
# the result after sw should be $8 = 0x37

# following code test bgez instruction
bgez:   addi $2, $0, 1      # initialize $2 = 1
        addi $3, $0, 1      # initialize $3 = 1
        addi $7, $0, 10     # initialize $7 = 10
loop2:  add  $8, $2, $3	    # $8 <= $2 + $3
	add  $2, $0, $3     # $2 <= $3
	add  $3, $0, $8     # $3 <= $8
	addi $7, $7, -1     # $7 <= $7 - 1
	addi $6, $7, -3     
	bgez $6, loop2 
# the result after sw should be $8 = 0x37

# following code test bgtz instruction
bgtz:   addi $2, $0, 1      # initialize $2 = 1
        addi $3, $0, 1      # initialize $3 = 1
        addi $7, $0, 11     # initialize $7 = 11
loop3:  add  $8, $2, $3	    # $8 <= $2 + $3
	add  $2, $0, $3     # $2 <= $3
	add  $3, $0, $8     # $3 <= $8
	addi $7, $7, -1     # $7 <= $7 - 1
	addi $6, $7, -3     
	bgtz $6, loop3 
# the result after sw should be $8 = 0x37

# following code test blez instruction
bltz:   addi $2, $0, 1      # initialize $2 = 1
        addi $3, $0, 1      # initialize $3 = 1
        addi $7, $0, 3      # initialize $7 = 1
loop4:  add  $8, $2, $3	    # $8 <= $2 + $3
	add  $2, $0, $3     # $2 <= $3
	add  $3, $0, $8     # $3 <= $8
	addi $7, $7, 1      # $7 <= $7 + 1
	addi $6, $7, -11     
	bltz $6, loop4 
# the result after sw should be $8 = 0x37

end:	addi $8, $0, -1     # end

