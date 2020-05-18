`include "ctrl_encode_def.v"
module Control(clk,rst,OP,Funct,Rs,Rt,PCSrc,NPCType,RegDst,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc_A,ALUSrc_B,RegWrite,MemWrBits,MemRBits,JumpSrc);
    input clk;
    input rst;
    input [5:0] OP;
    input [4:0] Rs;//Instr[25:21]
    input [4:0] Rt; //Instr[20:16]
    input [5:0] Funct;
    output reg  MemRead,MemWrite,RegWrite;
    output reg [1:0] NPCType;
    output reg [4:0] ALUOp;
    output reg [2:0] MemRBits;
    output reg [1:0] MemWrBits;
    output reg [1:0] MemtoReg;
    output reg [1:0] ALUSrc_A;
    output reg [1:0] ALUSrc_B;
    output reg [1:0] RegDst;
    output reg PCSrc;
    output reg JumpSrc; //只有NPCType为Jump才有实际作用

    initial 
    begin
        MemRead,MemWrite,RegWrite <= 3'b0;
        NPCType <= 2'b00;
        ALUOp <= 4'b0;
        MemRBits <= 3'b0;
        MemWrBits <= 2'b0;
        MemtoReg <= 2'b0;
        ALUSrc_A <= 2'b0;
        ALUSrc_B <= 2'b0;
        RegDst <= 2'b0;
        PCSrc <= 1'b0;
    end
          
    always@(posedge clk)
    begin
        case(Op)
        //-------------Rtype jalr jr---------------------
            `OP_Rtype,
            `OP_jalr,`OP_jr:
            begin
                case(Funct)
                    `funct_add:
                    begin
                        $display("Control add");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_ADD;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_addu:
                    begin
                        $display("Control addu");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_ADD;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_sub:
                    begin
                        $display("Control sub");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SUB;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_subu:
                    begin
                        $display("Control subu");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SUB;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_sll:
                    begin
                        $display("Control sll");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SLL;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b01; //Shamt
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_sra:
                    begin
                        $display("Control sra");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SRA;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b01; //Shamt
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_srl:
                    begin
                        $display("Control srl");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SRL;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b01; //Shamt
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_srlv:
                    begin
                        $display("Control srlv");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SRL;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_srav:
                    begin
                        $display("Control srav");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SRA;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_sllv:
                    begin
                        $display("Control sllv");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SLL;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_and:
                    begin
                        $display("Control and");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_AND;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_or:
                    begin
                        $display("Control or");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_OR;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_xor:
                    begin
                        $display("Control xor");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_XOR;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_nor:
                    begin
                        $display("Control nor");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_NOR;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_slt:
                    begin
                        $display("Control slt");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SLT;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_sltu:
                    begin
                        $display("Control sltu");
                        RegWrite <= 1'b1;
                        RegDst <= 2'b01; //Rd
                        MemtoReg <= 2'b00;
                        NPCType <= 2'b00; // PC+4
                        ALUOp <= `ALU_SLTU;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; //PC+4  
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                    end
                    `funct_jalr:
                    begin
                        $display("Control jalr");
                        RegWrite <= 1'b1; //[31] = PC+4
                        RegDst <= 2'b10; //No.31
                        MemtoReg <= 2'b10; //PC+4 ---ALUResult,Load,PC+4
                        NPCType <= 2'b10; // Jump
                        ALUOp <= `ALU_SLT;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; // Not Branch 
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                        JumpSrc <= 1'b1; // PC = GPR[rs]
                    end
                    `funct_jr: //only Jump,no Store to RF
                    begin
                        $display("Control jr");
                        RegWrite <= 1'b0; 
                        RegDst <= 2'b00;
                        MemtoReg <= 2'b10; //PC+4 ---ALUResult,Load,PC+4
                        NPCType <= 2'b10; // Jump
                        ALUOp <= `ALU_SLT;
                        MemRead <= 1'b0;
                        MemWrite <= 1'b0;
                        PCSrc <= 1'b0; // Not Branch 
                        ALUSrc_A <= 2'b00; //RD1
                        ALUSrc_B <= 2'b00; //RD2
                        JumpSrc <= 1'b1; // PC = GPR[rs]
                    end
                endcase
            end //Rtype jalr jr
        //-----------R-i type--------------
        `OP_addi:
        begin
            $display("Control addi");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b00; //ALUResult
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0;
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD;
        end
        `OP_addiu:
        begin
            $display("Control addiu");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b00; //ALUResult
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0;
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD;
        end
        `OP_andi:
        begin
            $display("Control andi");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b00; //ALUResult
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0;
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ANDI;
        end
        `OP_ori:
        begin
            $display("Control ori");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b00; //ALUResult
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0;
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ORI;
        end
        `OP_xori:
        begin
            $display("Control xori");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b00; //ALUResult
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0;
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_XORI;
        end
        `OP_lui:
        begin
            $display("Control lui");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b00; //ALUResult
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0;
            ALUSrc_A <= 2'b00 ; //RD1 随意值
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_XORI;
        end
        `OP_slti:
        begin
            $display("Control slti");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b00; //ALUResult
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0;
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_SLT;
        end
        `OP_sltiu:
        begin
            $display("Control sltiu");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b00; //ALUResult
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0;
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_SLTU;
        end
        //------load--------
        `OP_lw:
        begin
            $display("Control LW");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b01; //DataMemory 
            MemWrite <= 1'b0;
            MemRead <= 1'b1;
            MemRBits <= `MemR_lw; //Read Type
            PCSrc <= 1'b0; //PC+4
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD; //计算地址
        end
        `OP_lb:
        begin
            $display("Control LB");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b01; //DataMemory 
            MemWrite <= 1'b0;
            MemRead <= 1'b1;
            MemRBits <= `MemR_lb; //Read Type
            PCSrc <= 1'b0; //PC+4
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD; //计算地址
        end
        `OP_lbu:
        begin
            $display("Control LBU");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b01; //DataMemory 
            MemWrite <= 1'b0;
            MemRead <= 1'b1;
            MemRBits <= `MemR_lbu; //Read Type
            PCSrc <= 1'b0; //PC+4
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD; //计算地址
        end
        `OP_lh:
        begin
            $display("Control LH");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b01; //DataMemory 
            MemWrite <= 1'b0;
            MemRead <= 1'b1;
            MemRBits <= `MemR_lh; //Read Type
            PCSrc <= 1'b0; //PC+4
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD; //计算地址
        end
        `OP_lhu:
        begin
            $display("Control LHU");
            RegDst <= 2'b00 //Rt
            RegWrite <= 1'b1;
            MemtoReg <= 2'b01; //DataMemory 
            MemWrite <= 1'b0;
            MemRead <= 1'b1;
            MemRBits <= `MemR_lhu; //Read Type
            PCSrc <= 1'b0; //PC+4
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD; //计算地址
        end
        //-------------store type----------------
        `OP_sw:
        begin
            $display("Control SW");
            RegWrite <= 1'b0;
            MemWrite <= 1'b1;
            MemRead <= 1'b0;
            MemWrBits <= `MemWr_sw; //Write Type
            PCSrc <= 1'b0; //PC+4
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD; //计算地址
        end
        `OP_sh:
        begin
            $display("Control SH");
            RegWrite <= 1'b0;
            MemWrite <= 1'b1;
            MemRead <= 1'b0;
            MemWrBits <= `MemWr_sh; //Write Type
            PCSrc <= 1'b0; //PC+4
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD; //计算地址
        end
        `OP_sb:
        begin
            $display("Control SB");
            RegWrite <= 1'b0;
            MemWrite <= 1'b1;
            MemRead <= 1'b0;
            MemWrBits <= `MemWr_sb; //Write Type
            PCSrc <= 1'b0; //PC+4
            ALUSrc_A <= 2'b00 ; //RD1
            ALUSrc_B <= 2'b01 ; // SignExtend
            NPCType <= 2'b00 ; // PC+4
            ALUOp <= `ALU_ADD; //计算地址
        end
        //---------------------Branch-----------------------
        `OP_beq:
        begin
            $display("Control beq");
            RegWrite <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b1; //Branch
            ALUSrc_A <= 2'b00 ; //RD1 
            ALUSrc_B <= 2'b00 ; //RD2
            NPCType <= 2'b01 ; // Branch 给EX级的 BranchUnit
            ALUOp <= `ALU_SUB ; //BEQ
        end
        `OP_blez:
        begin
            $display("Control blez");
            RegWrite <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b1; //Branch
            ALUSrc_A <= 2'b00 ; //RD1 
            ALUSrc_B <= 2'b00 ; //RD2
            NPCType <= 2'b01 ; // Branch 给EX级的 BranchUnit
            ALUOp <= `ALU_BLEZ ; //blez
        end
        `OP_bgtz:
        begin
            $display("Control bgtz");
            RegWrite <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b1; //Branch
            ALUSrc_A <= 2'b00 ; //RD1 
            ALUSrc_B <= 2'b00 ; //RD2
            NPCType <= 2'b01 ; // Branch 给EX级的 BranchUnit
            ALUOp <= `ALU_BGTZ ; //BGTZ
        end
        `OP_bne:
        begin
            $display("Control bne");
            RegWrite <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b1; //Branch
            ALUSrc_A <= 2'b00 ; //RD1 
            ALUSrc_B <= 2'b00 ; //RD2
            NPCType <= 2'b01 ; // Branch 给EX级的 BranchUnit
            ALUOp <= `ALU_BNE; //BGTZ
        end
        `OP_bgez_bltz:
        begin
            case(Rt)
                5'b00000: //bltz
                begin
                    $display("Control bltz");
                    RegWrite <= 1'b0;
                    MemWrite <= 1'b0;
                    MemRead <= 1'b0;
                    PCSrc <= 1'b1; //Branch
                    ALUSrc_A <= 2'b00 ; //RD1 
                    ALUSrc_B <= 2'b00 ; //RD2
                    NPCType <= 2'b01 ; // Branch 给EX级的 BranchUnit
                    ALUOp <= `ALU_BLTZ ; 
                end
                5'b00001: //bgez
                begin
                    $display("Control bgez");
                    RegWrite <= 1'b0;
                    MemWrite <= 1'b0;
                    MemRead <= 1'b0;
                    PCSrc <= 1'b1; //Branch
                    ALUSrc_A <= 2'b00 ; //RD1 
                    ALUSrc_B <= 2'b00 ; //RD2
                    NPCType <= 2'b01 ; // Branch 给EX级的 BranchUnit
                    ALUOp <= `ALU_BGEZ ; 
                end
            endcase
        end
        //-----------------------Jump--------------------
        `OP_j:
        begin
            RegWrite <= 1'b0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0; //Not Branch
            ALUSrc_A <= 2'b00 ; //RD1 
            ALUSrc_B <= 2'b00 ; //RD2
            NPCType <= 2'b10 ; // Jump
            ALUOp <= `ALU_NOP ;  //无所谓，从Jump计算元件中得出Jump地址
            JumpSrc <= 1'b0; // PC[31:28] + <<2 + 00
        end
        `OP_jal:
        begin
            RegWrite <= 1'b1;
            RegDst <= 2'b10 ; //No.31
            MemtoReg <= 2'b10; //PC + 4
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            PCSrc <= 1'b0; //Not Branch
            ALUSrc_A <= 2'b00 ; //RD1 
            ALUSrc_B <= 2'b00 ; //RD2
            NPCType <= 2'b10 ; // Jump
            ALUOp <= `ALU_NOP ;  //无所谓，从Jump计算元件中得出Jump地址
            JumpSrc <= 1'b0 ; // PC[31:28] + <<2 + 00
        end
        endcase
    end
endmodule