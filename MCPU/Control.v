`include "ctrl_encode_def.v"
module Control(clk,rst,OP,Funct,Rt,PCWrite,PCWriteCond,PCSrc,IRWrite,RegDst,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc_A,ALUSrc_B,RegWrite,MemWrBits,MemRBits);
    input clk;
    input rst;
    input [5:0] OP;
    input [4:0] Rt; //Instr[20:16]
    input [5:0] Funct;
    output reg PCWrite,PCWriteCond,IRWrite,MemRead,MemWrite,RegWrite;
    output reg [4:0] ALUOp;
    output reg [2:0] MemRBits;
    output reg [1:0] MemWrBits;
    output reg [1:0] MemtoReg;
    output reg [1:0] ALUSrc_A;
    output reg [1:0] ALUSrc_B;
    output reg [1:0] RegDst;
    output reg [1:0] PCSrc;

    reg [3:0] state;

    initial 
    begin
        state <= 4'b0000;
        {PCWrite,PCWriteCond,IRWrite,MemRead,MemWrite,RegWrite} <= 6'b0;
        ALUOp <= 4'b0;
        MemRBits <= 3'b0;
        MemWrBits <= 2'b0;
        MemtoReg <= 2'b0;
        ALUSrc_A <= 2'b0;
        ALUSrc_B <= 2'b0;
        RegDst <= 2'b0;
        PCSrc <= 2'b00;
    end
          
    always@(posedge clk)
    begin
        case(state)
            `Initial:
            begin
                state <= `Instruction_Fetch;
            end
            `Instruction_Fetch:
            begin
                PCWrite <= 1'b1;
                PCWriteCond <= 1'b0;
                RegWrite <= 1'b0;
                ALUSrc_A <= 2'b01; //PC
                ALUSrc_B <= 2'b01; //4
                IRWrite <= 1'b1;
                ALUOp <= `ALU_ADD; //PC+4
                MemWrite <= 1'b0;
                PCSrc <= 2'b00 ; //PC+4
                state <= `Instruction_Decode;
            end
            `Instruction_Decode:
            begin
                PCWriteCond <= 1'b0;
                PCWrite <= 1'b0;
                ALUOp <= `ALU_ADD; //PC + sign-extend << 2
                ALUSrc_A <= 2'b01; //PC
                ALUSrc_B <= 2'b11; // sign-extend << 2
                IRWrite <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b0;
                case(OP)
                    `OP_Rtype,`OP_jalr,`OP_jalr:
                    begin
                        case(Funct)
                            `funct_jalr,
                            `funct_jr: //jr的[15:11]为0,写入RF仍为0，所以不用特殊处理
                            begin
                                state <= `Jump_Completion;
                            end
                            default:
                            begin
                                state <= `Execution;
                            end
                        endcase
                    end
                    `OP_lh,`OP_lhu,`OP_lw,
                    `OP_lb,`OP_lbu,`OP_sb,
                    `OP_sh,`OP_sw:
                    begin
                        state <= `Memory_Address_Computation;
                    end
                    `OP_beq,`OP_bgez_bltz,`OP_bgtz,
                    `OP_blez,`OP_bne:
                    begin
                        state <= `Branch_Completion;
                    end
                    `OP_addi,`OP_addiu,`OP_andi,
                    `OP_lui,`OP_ori,`OP_slti,
                    `OP_slti,`OP_sltiu,`OP_xori:
                    begin
                        state <= `Execution;
                    end
                    `OP_j,`OP_jal:
                    begin
                        state <= `Jump_Completion;
                    end
                    default:
                    begin
                        state <= `Initial;
                    end
                endcase 
            end
            `Memory_Address_Computation:
            begin
                ALUSrc_A <= 2'b00 ; //RegA
                ALUSrc_B <= 2'b10 ; //sign-extend
                ALUOp <= `ALU_ADD ; //compute address;
                RegWrite <= 1'b0;
                PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
                case(OP)
                    `OP_lh,`OP_lhu,`OP_lw,
                    `OP_lb,`OP_lbu:
                    begin
                        state <= `Memory_Access_Load;
                    end
                    `OP_sb,
                    `OP_sh,`OP_sw:
                    begin
                        state <= `Memory_Access_Store;
                    end
                    default:
                    begin
                        state <= `Initial;
                    end
                endcase
            end
            `Memory_Access_Load:
            begin
                MemRead <= 1'b1;
                RegWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
                state <= `MemRead_Completion;
                case(OP)
                    `OP_lw:
                    begin
                        MemRBits <= `MemR_lw;
                    end
                    `OP_lh:
                    begin
                        MemRBits <= `MemR_lh;
                    end
                    `OP_lhu:
                    begin
                        MemRBits <= `MemR_lhu;
                    end
                    `OP_lb:
                    begin
                        MemRBits <= `MemR_lb;
                    end
                    `OP_lbu:
                    begin
                        MemRBits <= `MemR_lbu;
                    end
                endcase
            end
            `Memory_Access_Store:
            begin
                MemWrite <= 1'b1;
                RegWrite <= 1'b0;
				PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				IRWrite <= 1'b0;
                state <= `Instruction_Fetch;
                case(OP)
                    `OP_sw:
                    begin
                    MemWrBits <= `MemWr_sw;
                    end
                    `OP_sh:
                    begin
                    MemWrBits <= `MemWr_sh;
                    end
                    `OP_sb:
                    begin
                    MemWrBits <= `MemWr_sb;
                    end
                endcase
            end
            `Execution:
            begin
                RegWrite <= 1'b0;
                PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
                state <= `Rtype_Completion;
                case(OP)
                    `OP_addi:
                        begin
                            ALUSrc_A <= 2'b00; //RegA
                            ALUSrc_B <= 2'b10;//signextend
                            ALUOp <= `ALU_ADD;
                        end
                    `OP_addiu:
                        begin
                            ALUSrc_A <= 2'b00; //RegA
                            ALUSrc_B <= 2'b10;//signextend
                            ALUOp <= `ALU_ADD;
                        end
                    `OP_andi:
                        begin
                            ALUSrc_A <= 2'b00; //RegA
                            ALUSrc_B <= 2'b10;//signextend
                            ALUOp <= `ALU_ANDI;
                        end
                    `OP_lui:
                        begin
                            ALUSrc_A <= 2'b00; //RegA
                            ALUSrc_B <= 2'b10;//signextend
                            ALUOp <= `ALU_LUI;
                        end
                    `OP_ori:
                        begin
                            ALUSrc_A <= 2'b00; //RegA
                            ALUSrc_B <= 2'b10;//signextend
                            ALUOp <= `ALU_ORI;
                        end
                    `OP_xori:
                        begin
                            ALUSrc_A <= 2'b00; //RegA
                            ALUSrc_B <= 2'b10;//signextend
                            ALUOp <= `ALU_XORI;
                        end
                    `OP_slti:
                        begin
                            ALUSrc_A <= 2'b00; //RegA
                            ALUSrc_B <= 2'b10;//signextend
                            ALUOp <= `ALU_SLT;
                        end
                    `OP_sltiu:
                        begin
                            ALUSrc_A <= 2'b00; //RegA
                            ALUSrc_B <= 2'b10;//signextend
                            ALUOp <= `ALU_SLTU;
                        end
                    `OP_Rtype:
                        begin
                            case(Funct)
                                `funct_add:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_ADD;
                                end
                                `funct_addu:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_ADD;
                                end
                                `funct_and:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_AND;
                                end
                                `funct_nor:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_NOR;
                                end
                                `funct_or:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_OR;
                                end
                                `funct_sll: //逻辑左移 rt,rd shamt
                                begin
                                    ALUSrc_A <= 2'b10; // shamt;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_SLL;
                                end
                                `funct_sllv: //逻辑可变左移 rs rt rd
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_SLL;
                                end
                                `funct_srl: //逻辑右移 rt,rd shamt
                                begin
                                    ALUSrc_A <= 2'b10; // shamt;
                                    ALUSrc_B <= 2'b00 ; // RegB;
                                    ALUOp <= `ALU_SRL;
                                end
                                `funct_srlv: //逻辑可变右移 rs rt rd
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_SRL;
                                end
                                `funct_srav: //算数可变右移 rs rt rd
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_SRA;
                                end
                                `funct_sra: //算数右移 rs rt rd
                                begin
                                    ALUSrc_A <= 2'b10; // shamt
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_SRA;
                                end
                                `funct_sub:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_SUB;
                                end
                                `funct_subu:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00 ; // RegB;
                                    ALUOp <= `ALU_SUB;
                                end
                                `funct_xor:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_XOR;
                                end
                                `funct_slt:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_SLT;
                                end
                                `funct_sltu:
                                begin
                                    ALUSrc_A <= 2'b00; // RegA;
                                    ALUSrc_B <= 2'b00;  // RegB;
                                    ALUOp <= `ALU_SLTU;
                                end
                            endcase
                        end
                endcase
            end//Execution
            `Rtype_Completion:
            begin
                RegWrite <= 1'b1;
                PCWriteCond <= 1'b0;
				PCWrite <= 1'b0;
				MemWrite <= 1'b0;
				IRWrite <= 1'b0;
                MemtoReg <= 2'b01; //ALUOut_o
                state <= `Instruction_Fetch;
                case(OP)
                    `OP_Rtype:
                    begin
                        RegDst <= 2'b01; //rd
                    end
                    `OP_addi:
                    begin
                        RegDst <= 2'b00; //rt
                    end
                    `OP_addiu:
                    begin
                        RegDst <= 2'b00; //rt
                    end
                    `OP_andi:
                    begin
                        RegDst <= 2'b00; //rt
                    end
                    `OP_lui:
                    begin
                        RegDst <= 2'b00; //rt
                    end
                    `OP_ori:
                    begin
                        RegDst <= 2'b00; //rt
                    end
                    `OP_slti:
                    begin
                        RegDst <= 2'b00; //rt
                    end
                    `OP_sltiu:
                    begin
                        RegDst <= 2'b00; //rt
                    end
                    `OP_xori:
                    begin
                        RegDst <= 2'b00; //rt
                    end
                endcase
            end
            `Branch_Completion:
            begin
                ALUSrc_A <= 2'b00; //RegA rs
                ALUSrc_B <= 2'b00;  // RegB or nothing此处bgtz等直接与0做比较
                PCSrc <= 2'b01; //BranchTarget
                PCWriteCond <= 1'b1;
                state <= `Instruction_Fetch;
                case(OP)
                    `OP_beq:
                        begin
                            ALUOp <= `ALU_SUB;
                        end
                    `OP_bgez_bltz:
                        begin
                            case(Rt)
                                5'b00000: //bltz
                                begin
                                    ALUOp <= `ALU_BLTZ;
                                end
                                5'b00001: //bgez
                                begin
                                    ALUOp <= `ALU_BGEZ;
                                end
                            endcase
                        end
                    `OP_bgtz:
                        begin
                            ALUOp <= `ALU_BGTZ;
                        end
                    `OP_blez:
                        begin
                            ALUOp <= `ALU_BLEZ;
                        end
                    `OP_bne:
                        begin
                            ALUOp <= `ALU_BNE;
                        end
                endcase
            end
            `Jump_Completion:
            begin
                PCWrite <= 1'b1;
                state <= `Instruction_Fetch;
                case(OP)
                    `OP_j:
                        begin
                            PCSrc <= 2'b10; //PC[31:28] +  <<2 + 00
                            RegWrite <= 1'b0;
				            PCWriteCond <= 1'b0;
				            MemWrite <= 1'b0;
				            IRWrite <= 1'b0;
                        end
                    `OP_jal:
                        begin
                            PCSrc <= 2'b10; //PC[31:28] +  <<2 + 00
                            RegWrite <= 1'b1; //Write PC+4 to No.31
                            RegDst <= 2'b10; //No.31 Reg
                            MemtoReg <= 2'b10; //PC+4;
				            PCWriteCond <= 1'b0;
				            MemWrite <= 1'b0;
				            IRWrite <= 1'b0;
                        end
                    `OP_Rtype:
                        begin
                            case(Funct)
                            `funct_jalr:
                                begin
                                    PCSrc <= 2'b11; //RegA_o
                                    RegWrite <= 1'b1; //Write PC+4 to No.31
                                    RegDst <= 2'b10; //No.31 Reg
                                    MemtoReg <= 2'b10; //PC+4;
				                    PCWriteCond <= 1'b0;
				                    MemWrite <= 1'b0;
				                    IRWrite <= 1'b0;
                                end
                            `funct_jr:
                                begin
                                    PCSrc <= 2'b11; //RegA_o
                                    RegWrite <= 1'b0;
				                    PCWriteCond <= 1'b0;
				                    MemWrite <= 1'b0;
				                    IRWrite <= 1'b0;
                                end
                            endcase
                        end
                endcase
            end //endJmp
            `MemRead_Completion:
            begin
                RegDst <= 2'b00; //rt
                RegWrite <= 1'b1;
                MemtoReg <= 2'b00; //MemData_o
                PCWrite <= 1'b0;
                PCWriteCond <= 1'b0;
                MemWrite <= 1'b0;
                IRWrite <= 1'b0;
                state <= `Instruction_Fetch;
            end
        endcase    //endstate
    end//endalways
endmodule