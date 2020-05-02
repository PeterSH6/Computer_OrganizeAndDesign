`include "ctrl_encode_def.v"
module Control(OP,RegDst,Jump,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite);
    input [5:0] OP;
    output reg RegDst,Jump,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite;
    output reg [1:0] ALUOp
    always@(*)
    begin
        case(OP)
            `OP_Rtype:
                begin
                {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump} = 8'b10010000;
                ALUOp = 2'b10;
                end
            `OP_lw:
                begin
                {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump} = 8'b01111000;
                ALUOp = 2'b00;
                end;
            `OP_sw:
                begin
                {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump} = 8'b01000100;
                ALUOp = 2'b00;
                end;
            `OP_beq:
                begin
                {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump} = 8'b00000010;
                ALUOp = 2'b01;
                end
    end
endmodule