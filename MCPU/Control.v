`include "ctrl_encode_def.v"
module Control(clk,rst,OP,Funct,PCWrite,PCWriteCond,PCSrc,IRWrite,RegDst,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc_A,ALUSrc_B,RegWrite,EXTOP,MemWrBits,MemRBits);
    input clk;
    input rst;
    input [5:0] OP;
    input [5:0] Funct;
    output reg PCWrite,PCWriteCond,IRWrite,MemRead,MemWrite,RegWrite,EXTOP;
    output reg [3:0] ALUOp;
    output reg [2:0] MemRBits;
    output reg [1:0] MemWrBits;
    output reg [1:0] MemtoReg;
    output reg [1:0] ALUSrc_A;
    output reg [1:0] ALUSrc_B;
    output reg [1:0] RegDst;
    output reg [1:0] PCSrc;

    reg [3:0] state;
    parameter   Inital =                4'b0000;
                Instruction_Fetch =     4'b0001;
                Instruction_Decode =    4'b0010;

    initial begin
        state <= Inital;
        {PCWrite,PCWriteCond,IRWrite,MemRead,MemWrite,RegWrite,EXTOP} <= 7'b0;
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
            Inital:
            begin
                state <= Instruction_Fetch;
            end
            Instruction_Fetch:
            begin
                PCWrite <= 1'b1;
                PCWriteCond <= 1'b0;
                ALUSrc_A <= 2'b01; //PC
                ALUSrc_B <= 2'b01; //4
                IRWrite <= 1'b1;
                ALUOp <= `ALU_ADD; //PC+4
                MemWrite <= 1'b0;
                PCSrc <= 2'b00 ; //PC+4
                state <= Instruction_Decode;
            end
            Instruction_Decode:
            begin
                PCWriteCond <= 1'b0;
                PCWrite <= 1'b0;
                ALUOp <= `ALU_ADD; //PC + sign-extend << 2
                ALUSrc_A <= 2'b01; //PC
                ALUSrc_B <= 2'b11; // sign-extend << 2
                IRWrite <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b0;
            end
                

    
    end
endmodule