`include "ctrl_encode_def.v"
module ALUControl(ALUOp,Funct,ALU_Control,PCSrc2,ShiftSrc);

    input [3:0] ALUOp;
    input [5:0] Funct;
    output reg[3:0] ALU_Control;
    output reg PCSrc2;
    output reg ShiftSrc;
    
    initial
        begin
            ALU_Control = 4'b0000;
        end
    
    always@(*)
    begin
    case(ALUOp)
        `ALUOP_LS: //lw,lb,lbu,lhu,lh,sw
            begin
            ALU_Control = `ALU_ADD;
            PCSrc2 = 1'b0;
            ShiftSrc = 1'b0;
            end
        `ALUOP_Rtype: //R-type
            begin
            case(Funct)
                `funct_add:
                    begin
                    ALU_Control = `ALU_ADD;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_addu:
                    begin
                    ALU_Control = `ALU_ADD;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_sub:
                    begin
                    ALU_Control = `ALU_SUB;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_subu:
                    begin
                    ALU_Control = `ALU_SUB;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_and:
                    begin
                    ALU_Control = `ALU_AND;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_or:
                    begin
                    ALU_Control = `ALU_OR;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_nor:
                    begin
                    ALU_Control = `ALU_NOR;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_xor:
                    begin
                    ALU_Control = `ALU_XOR;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_slt:
                    begin
                    ALU_Control = `ALU_SLT;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_sltu:
                    begin
                    ALU_Control = `ALU_SLTU;
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_jalr:
                    begin
                    ALU_Control = `ALU_NOP;
                    PCSrc2 = 1'b1;
                    ShiftSrc = 1'b0;
                    end
                `funct_jr:
                    begin
                    ALU_Control = `ALU_NOP;
                    PCSrc2 = 1'b1;
                    ShiftSrc = 1'b0;
                    end
                `funct_sll:
                    begin
                    ALU_Control = `ALU_SLL; //左移
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b1;
                    end
                `funct_sllv:
                    begin
                    ALU_Control = `ALU_SLL; //左移
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0;
                    end
                `funct_sra:
                    begin
                    ALU_Control = `ALU_SRA; //算数右移
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b1; //s
                    end
                `funct_srav:
                    begin
                    ALU_Control = `ALU_SRA; //算数右移
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b0; //GPR
                    end
                `funct_srl:
                    begin
                    ALU_Control = `ALU_SRL; //逻辑右移
                    PCSrc2 = 1'b0;
                    ShiftSrc = 1'b1; //s
                    end
            endcase
            end
        `ALUOP_ADDI: //adi
            begin
            ALU_Control = `ALU_ADD;
            PCSrc2 = 1'b0;
            end
        `ALUOP_ANDI: //andi
            begin
            ALU_Control = `ALU_AND;
            PCSrc2 = 1'b0;
            end
        `ALUOP_ORI: //ori
            begin
            ALU_Control = `ALU_OR;
            PCSrc2 = 1'b0;
            end
        `ALUOP_XORI: //xori
            begin
            ALU_Control = `ALU_XOR;
            PCSrc2 = 1'b0;
            end
        `ALUOP_SLTI:
            begin
            ALU_Control = `ALU_SLT;
            PCSrc2 = 1'b0;
            end
        `ALUOP_SLTIU:
            begin
            ALU_Control = `ALU_SLTU;
            PCSrc2 = 1'b0;
            end
        `ALUOP_LUI:
            begin
            ALU_Control = `ALU_LUI;
            PCSrc2 = 1'b0;
            end
        `ALUOP_BEQ:
            begin
            ALU_Control = `ALU_SUB;
            PCSrc2 = 1'b0;
            end
        `ALUOP_BNE:
            begin
            ALU_Control = `ALU_SUB;
            PCSrc2 = 1'b0;
            end
        
    endcase
    end
endmodule