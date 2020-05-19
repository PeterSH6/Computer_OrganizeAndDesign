main: 	addi	$1, $0, 1
	beq	$0, $0, l2	#taken, state = 00
	addi	$1, $0, 2
l2:	addi	$2, $0, 1
	beq	$0, $0, l3	#taken, state = 01
	addi	$2, $0, 2
l3:	addi	$3, $0, 1
	beq	$0, $0, l4	#taken, state = 10
	addi	$3, $0, 2
l4:	addi	$4, $0, 1
	beq	$0, $0, l5	#taken, state = 11
	addi	$4, $0, 2
l5:	addi	$5, $0, 1
	beq	$0, $1, main	#not taken, state = 10
	addi	$5, $0, 2