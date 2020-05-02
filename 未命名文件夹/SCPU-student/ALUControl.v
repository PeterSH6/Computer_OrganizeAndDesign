`include "ctrl_encode_def.v"
module ALUControl(ALUOp,Funct);

    input [1:0] ALUOp;
    input [5:0] Funct;
    output reg[3:0] ALU_Control;
    
    initial
        begin
            ALU_Control = 4'b0000;
        end
    
    always@(*)
    begin
    case(ALUOp)
        2'b00: //lw,sw
            begin
            ALU_Control = 4'b0010;
            end
        2'b10: //R-type
            begin
            case(Funct)
                `funct_add:
                    begin
                    ALU_Control = `ALU_ADD;
                    end
                `funct_sub:
                    begin
                    ALU_Control = `ALU_SUB;
                    end
                `funct_and:
                    begin
                    ALU_Control = `ALU_AND;
                    end
                `funct_or:
                    begin
                    ALU_Control = `ALU_OR;
                    end
                `funct_slt:
                    begin
                    ALU_Control = `ALU_SLT;
                    end
                `funct_sltu:
                    begin
                    ALU_Control = `ALU_SLTU;
                    end
            endcase
            end
        2'b01: //beq
            begin
            ALU_Control = `ALU_SUB;
            end
    endcase
    end
endmodule