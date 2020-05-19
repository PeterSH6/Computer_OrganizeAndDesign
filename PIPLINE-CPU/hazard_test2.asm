	addi	$4, $0, 1
	addi	$4, $4, 1
	addi	$4, $4, 1

	addi	$5, $0, 20
	addi	$6, $0, 55
	addi	$7, $0, 60
	beq	$7, $6, loop

loop:	addi	$5, $5, 24
	jalr	$31, $5
	addi	$8, $0, 100
	j	end
	
	jr	$31

end:
	