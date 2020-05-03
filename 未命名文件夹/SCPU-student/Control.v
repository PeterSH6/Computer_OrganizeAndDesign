`include "ctrl_encode_def.v"
module Control(OP,Inst,RegDst,Jump,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,,EXTOP1,EXTOP_b,EXTOP_h,mux_bhw,BranchSrc,Not,WriteBackSrc,PCSrc1,ShiftSrc1);
    input [5:0] OP;
    input [4:0] Inst;
    output reg Jump,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,EXTOP1,EXTOP_b,EXTOP_h,BranchSrc,Not,WriteBackSrc,PCSrc1,ShiftSrc1;
    output reg [3:0] ALUOp;
    output reg [1:0] RegDst;
    output reg [1:0] mux_bhw;
    always@(*)
    begin
        case(OP) //Instruction前6位
            `OP_Rtype:
                begin
                RegDst = 2'b01;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'bx;
                EXTOP_b = 1'bx;
                EXTOP_h = 1'bx;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_Rtype;
                ALUSrc = 2'b00;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b1;
                ShiftSrc1 = 1'b1;
                end
            `OP_addi:
                begin
                RegDst = 2'b00;
                ALUSrc = 2'b01;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                ALUOp = `ALUOP_ADDI;
                BranchSrc = 1'bx;
                Not = 1'bx;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_addiu:
                begin
                RegDst = 2'b00;
                ALUSrc = 2'b01;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                ALUOp = `ALUOP_ADDI;
                BranchSrc = 1'bx;
                Not = 1'bx;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_andi:
                begin
                RegDst = 2'b00;
                ALUSrc = 2'b01;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                ALUOp = `ALUOP_ANDI;
                BranchSrc = 1'bx;
                Not = 1'bx;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_ori:
                begin
                RegDst = 2'b00;
                ALUSrc = 2'b01;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                ALUOp = `ALUOP_ORI;
                BranchSrc = 1'bx;
                Not = 1'bx;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_xori:
                begin
                RegDst = 2'b00;
                ALUSrc = 2'b01;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_XORI;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_lui:
                begin
                RegDst = 2'b00;
                ALUSrc = 2'b01;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_LUI;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_slti:
                begin
                RegDst = 2'b00;
                ALUSrc = 2'b01;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_SLTI;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_sltiu:
                begin
                RegDst = 2'b00;
                ALUSrc = 2'b01;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_SLTIU;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_lw:
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'bx;
                EXTOP_h = 1'bx;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_LS;
                ALUSrc = 2'b01;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_lb:
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b1;
                EXTOP_h = 1'bx;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_LS;
                ALUSrc = 2'b01;
                mux_bhw = 2'b01;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_lbu:
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'bx;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_LS;
                mux_bhw = 2'b01;
                ALUSrc = 2'b01;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_lh:
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'bx;
                EXTOP_h = 1'b1;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_LS;
                ALUSrc = 2'b01;
                mux_bhw = 2'b10;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_lhu:
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'bx;
                EXTOP_h = 1'b0;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = `ALUOP_LS;
                mux_bhw = 2'b10;
                ALUSrc = 2'b01;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_sw:
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b1;
                Branch = 1'b0;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'bx;
                EXTOP_h = 1'bx;
                BranchSrc = 1'bx;
                Not = 1'bx;
                ALUOp = 2'b00;
                ALUSrc = 2'b01;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_beq:
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'bx;
                EXTOP_h = 1'bx;
                BranchSrc = 1'b0;
                Not = 1'b0;
                ALUOp = `ALUOP_BEQ;
                ALUSrc = 2'b00;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_bne:
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                Jump = 1'b0;
                EXTOP1 = 1'b1;
                EXTOP_b = 1'bx;
                EXTOP_h = 1'bx;
                BranchSrc = 1'b0;
                Not = 1'b1;
                ALUOp = `ALUOP_BNE;
                ALUSrc = 2'b00;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_bgez_bltz: 
                begin
                if(Inst == 5'b00001) //大于等于时转移
                    begin
                    RegDst = 2'b00;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b1;
                    Jump = 1'b0;
                    EXTOP1 = 1'bx;
                    EXTOP_b = 1'bx;
                    EXTOP_h = 1'bx;
                    BranchSrc = 1'b1;
                    Not = 1'b1;
                    ALUOp = `ALUOP_SLTI; //set on greater than 
                    ALUSrc = 2'b10;
                    mux_bhw = 2'b00;
                    WriteBackSrc = 1'b0;
                    PCSrc1 = 1'b0;
                    ShiftSrc1 = 1'b0;
                    end
                else if(Inst == 5'b00000) //小于时转移
                    begin
                    RegDst = 2'b00;
                    MemtoReg = 1'b0;
                    RegWrite = 1'b0;
                    MemRead = 1'b0;
                    MemWrite = 1'b0;
                    Branch = 1'b1;
                    Jump = 1'b0;
                    EXTOP1 = 1'bx;
                    EXTOP_b = 1'bx;
                    EXTOP_h = 1'bx;
                    BranchSrc = 1'b1;
                    Not = 1'b0;
                    ALUOp = `ALUOP_SLTI; //set on greater than 
                    ALUSrc = 2'b10;
                    mux_bhw = 2'b00;
                    WriteBackSrc = 1'b0;
                    PCSrc1 = 1'b0;
                    ShiftSrc1 = 1'b0;
                    end
                end   
            `OP_bgtz: //大于0时转移 000111
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                Jump = 1'b0;
                EXTOP1 = 1'bx;
                EXTOP_b = 1'bx;
                EXTOP_h = 1'bx;
                BranchSrc = 1'b1;
                Not = 1'b0;
                ALUOp = `ALUOP_SGT; //set on greater than 
                ALUSrc = 2'b10;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_blez: //小于等于0时转移 000110
                begin
                RegDst = 2'b00;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                Jump = 1'b0;
                EXTOP1 = 1'bx;
                EXTOP_b = 1'bx;
                EXTOP_h = 1'bx;
                BranchSrc = 1'b1;
                Not = 1'b1;
                ALUOp = `ALUOP_SGT; //set on greater than 
                ALUSrc = 2'b10;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_j:
                begin
                RegDst = 2'b00;
                ALUSrc = 2'b00;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b1;
                EXTOP1 = 1'b0;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                ALUOp = 4'bxxxx;
                BranchSrc = 1'bx;
                Not = 1'bx;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b0;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end
            `OP_jal:
                begin
                RegDst = 2'b10; //31号寄存器
                ALUSrc = 2'b00;
                MemtoReg = 1'b0;
                RegWrite = 1'b1; //write back to GPR[31]
                MemRead = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b0;
                Jump = 1'b1;
                EXTOP1 = 1'b0;
                EXTOP_b = 1'b0;
                EXTOP_h = 1'b0;
                ALUOp = 4'bxxxx;
                BranchSrc = 1'bx;
                Not = 1'bx;
                mux_bhw = 2'b00;
                WriteBackSrc = 1'b1;
                PCSrc1 = 1'b0;
                ShiftSrc1 = 1'b0;
                end 
        endcase          
    end
endmodule