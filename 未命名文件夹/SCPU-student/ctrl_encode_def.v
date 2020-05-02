// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10


// ALU control signal
`define ALU_NOP   3'b000 //TODO
`define ALU_ADD   4'b0010
`define ALU_SUB   4'b0110 
`define ALU_AND   4'b0000 //可能要改一下
`define ALU_OR    4'b0001
`define ALU_SLT   4'b0111
`define ALU_SLTU  4'b110 //TODO

//Control signal
`define OP_Rtype 6'b000000
`define OP_lw    6'b100011
`define OP_lb    6'b100000
`define OP_lbu   6'b100100
`define OP_lh    6'b100001
`define OP_lhu   6'b100101
`define OP_sw    6'b101011
`define OP_sb    6'b101000
`define OP_sh    6'b101001
`define OP_j     6'b000010
`define OP_jal   6'b000011
`define OP_jalr  6'b000000//special func 001001
`define OP_jr    6'b000000//special func 001000
`define OP_addi  6'b001000
`define OP_addiu 6'b001001
`define OP_andi  6'b001100
`define OP_lui   6'b001111
`define OP_ori   6'b001101
`define OP_slti  6'b001010
`define OP_sltiu 6'b001011
`define OP_xori  6'b001110
`define OP_beq   6'b000100
`define OP_bgez  6'b000001
`define OP_bgtz  6'b000111
`define OP_blez  6'b000110
`define OP_bltz  6'b000001 //重复
`define OP_bne   6'b000101

//Funct field
`define funct_add   6'b100000
`define funct_addu  6'b100001
`define funct_and   6'b100100
//`define funct_div   6'b011010
//`define funct_divu  6'b011011
//`define funct_mult  6'b011000
//`define funct_multu 6'b011001
`define funct_nor   6'b100111
`define funct_or    6'b100101
`define funct_sll   6'b000000
`define funct_sllv  6'b000100
`define funct_slt   6'b101010
`define funct_sltu  6'b101011
`define funct_sra   6'b000011
`define funct_srav  6'b000111
`define funct_srl   6'b000010
`define funct_srlv  6'b000110
`define funct_sub   6'b100010
`define funct_subu  6'b100011
`define funct_xor   6'b100110