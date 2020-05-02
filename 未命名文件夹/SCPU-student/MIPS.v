`include "alu.v"
`include "ctrl_encode_def.v"
`include "EXT.v"
`include "mux.v"
`include "NPC.v"
`include "PC.v"
`include "RF.v"
`include "IM.v"
`include "DM.v"
`include "Control.v"
`include "ALUControl.v"

module MIPS(clk,rst);
    input clk;
    input rst;

    //PC module
    wire [31:0] i_PC;
    wire [31:0] o_PC;
    PC my_PC(.clk(clk),.rst(rst),.NPC(i_PC),.PC(o_PC));

    //IM module
    wire [31:0] Instruction;
    IM my_IM(.PC(o_PC),.Instruction(Instruction));

    //control
    wire RegDst;
    wire Jump;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire [1:0] ALUOp;
    Control my_ctrl(.OP(Instruction[31:26]),.RegDst(RegDst),.Jump(Jump),.Branch(Branch),.MemRead(MemRead),.MemtoReg(MemtoReg),.ALUOp(ALUOp),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite));
    
    //MUX
    wire [4:0]writeRegister;
    mux2 RegDst(.d0(Instruction[20:16]),.d1(Instruction[15:11]),.s(RegWrite),.y(writeRegister));//位数
    
    //RF module
    wire [31:0]WriteData;
    wire [31:0]ReadData1;
    wire [31:0]ReadData2;
    RF my_RF(.clk(clk),.rst(rst),
    .RFWr(RegWrite),
    .A1(Instruction[25:21]),
    .A2(Instruction[20:16]),
    .A3(writeRegister),
    .WD(WriteData),.RD1(ReadData1),.RD2(ReadData2));//last 2 param

    //Sign-Extend
    wire [31:0] extended;
    EXT my_ext(.Imm16(Instruction[15:0]),.Imm32(extended));

    //MUX R-lw,sw
    wire [31:0]ALUData2;
    mux2 ALUSrc(.d0(ReadData2),.d1(extended),.s(ALUSrc),.y(ALUData2));

    //ALU
    wire [3:0]ALU_Control
    wire [31:0] ALUResult;
    wire Zero;
    alu my_alu(.A(ReadData1),.B(ALUDataB),.ALUOp(ALU_Control),.C(ALUResult),.Zero(Zero));

    //NPC
    NPC my_NPC(.PC(o_PC),.Jump(Jump),.Branch(Branch),.IMM(Instruction[25:0]),.NPC(i_PC));
    
    //DM
    wire MemData;//read data
    DM my_DM(.clk(clk),.MemR(MemRead),.MemWr(MemWrite),.addr(ALUResult),.data(ReadData2),.ReadData(MemData));
    
    //MUX Mem2Reg
    mux2 Mem2Reg(.d0(MemData),.d1(ALUResult),.s(MemtoReg),.y(WriteData));

endmodule

    