// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10
//state
`define Initial                   4'b0000
`define Instruction_Fetch          4'b0001
`define Instruction_Decode         4'b0010
`define Jump_Completion            4'b0011
`define Execution                4'b0100
`define Memory_Address_Computation 4'b0101
`define Branch_Completion        4'b0110 
`define Memory_Access_Load         4'b0111
`define Memory_Access_Store        4'b1000
`define MemRead_Completion         4'b1001
`define Rtype_Completion         4'b1010

//MemR
`define MemR_lw     3'b000
`define MemR_lh     3'b001
`define MemR_lhu    3'b010
`define MemR_lb     3'b011
`define MemR_lbu    3'b100

//MemWrBits
`define MemWr_sw    2'b00
`define MemWr_sh    2'b01
`define MemWr_sb    2'b10

// ALU control signal
`define ALU_NOP   5'b00000 
`define ALU_OR    5'b00001
`define ALU_ADD   5'b00010
`define ALU_AND   5'b00011
`define ALU_SLL   5'b00100
`define ALU_SRA   5'b00101 
`define ALU_SUB   5'b00110 
`define ALU_SLT   5'b00111
`define ALU_SRL   5'b01000
`define ALU_SGT   5'b01001
`define ALU_SLTU  5'b01100 
`define ALU_NOR   5'b01101
`define ALU_XOR   5'b01110
`define ALU_LUI   5'b01111
`define ALU_ORI   5'b10000
`define ALU_XORI  5'b10001
`define ALU_ANDI  5'b10010
`define ALU_BGTZ  5'b10011
`define ALU_BGEZ  5'b10100
`define ALU_BLEZ  5'b10101
`define ALU_BLTZ  5'b10110
`define ALU_BNE   5'b10111

//Control signal
`define OP_Rtype 6'b000000//
`define OP_lw    6'b100011//
`define OP_lb    6'b100000//
`define OP_lbu   6'b100100//
`define OP_lh    6'b100001//
`define OP_lhu   6'b100101//
`define OP_sw    6'b101011//
`define OP_sb    6'b101000//
`define OP_sh    6'b101001//
`define OP_j     6'b000010//
`define OP_jal   6'b000011//
`define OP_jalr  6'b000000//special func 001001
`define OP_jr    6'b000000//special func 001000
`define OP_addi  6'b001000//
`define OP_addiu 6'b001001//
`define OP_andi  6'b001100//
`define OP_lui   6'b001111//
`define OP_ori   6'b001101//
`define OP_slti  6'b001010//
`define OP_sltiu 6'b001011//
`define OP_xori  6'b001110//
`define OP_beq   6'b000100//
`define OP_bgez_bltz  6'b000001//重复
`define OP_bgtz  6'b000111//
`define OP_blez  6'b000110//
`define OP_bne   6'b000101//

//Funct field 16个
`define funct_add   6'b100000 //
`define funct_addu  6'b100001 //
`define funct_and   6'b100100 //
//`define funct_div   6'b011010
//`define funct_divu  6'b011011
//`define funct_mult  6'b011000
//`define funct_multu 6'b011001
`define funct_nor   6'b100111 //
`define funct_or    6'b100101 //
`define funct_sll   6'b000000 //
`define funct_sllv  6'b000100 //
`define funct_slt   6'b101010 //
`define funct_sltu  6'b101011 //
`define funct_sra   6'b000011 //
`define funct_srav  6'b000111 //
`define funct_srl   6'b000010 //
`define funct_srlv  6'b000110 //
`define funct_sub   6'b100010 //
`define funct_subu  6'b100011 //
`define funct_xor   6'b100110//
`define funct_jalr  6'b001001//
`define funct_jr    6'b001000//

//ALUOp
`define ALUOP_Rtype 4'b0010
`define ALUOP_LS    4'b0000
`define ALUOP_BEQ   4'b0001
`define ALUOP_ADDI  4'b0011
`define ALUOP_ANDI  4'b0100
`define ALUOP_ORI   4'b0101
`define ALUOP_NORI  4'b0110
`define ALUOP_XORI  4'b0111
`define ALUOP_SLTI  4'b1000
`define ALUOP_LUI   4'b1001
`define ALUOP_SGT   4'b1010
`define ALUOP_SLTIU 4'b1011
`define ALUOP_BNE   4'b1100