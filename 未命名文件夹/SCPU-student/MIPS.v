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

    //PC_MUX
    wire [31:0] i_PC;
    wire [31:0] ALUResult;
    wire PCSrc;
    wire [31:0] finali_PC;
    mux2 PC_MUX(.d0(i_PC),.d1(ALUResult),.s(PCSrc),.y(finali_PC));
    
    //PC module
    wire [31:0] o_PC;
    PC my_PC(.clk(clk),.rst(rst),.NPC(finali_PC),.PC(o_PC));

    //IM module
    wire [31:0] Instruction;
    IM my_IM(.PC(o_PC),.Instruction(Instruction));

    //control
    wire [1:0] RegDst;
    wire Jump;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire MemWrite;
    wire [1:0] ALUSrc;
    wire RegWrite;
    wire [3:0] ALUOp;
    wire BranchSrc;
    wire Not;
    wire WriteBackSrc1;
    wire PCSrc1;
    wire ShiftSrc1;
    wire [1:0] mux_bhw;
    wire [1:0] MemRBits;
    wire [1:0] MemWrBits;
    wire EXTOp_b;
    wire EXTOp_h;
    wire EXTOp1;//sign extend or zero extend
    Control my_ctrl(.OP(Instruction[31:26]),.Inst(Instruction[20:16]),.RegDst(RegDst),.Jump(Jump),.Branch(Branch),
    .MemRead(MemRead),.MemtoReg(MemtoReg),.ALUOp(ALUOp),.MemWrite(MemWrite),.MemWrBits(MemWrBits),.MemRBits(MemRBits),
    .ALUSrc(ALUSrc),.RegWrite(RegWrite),.BranchSrc(BranchSrc),.Not(Not),.EXTOP_b(EXTOp_b),.EXTOP_h(EXTOp_h),.EXTOP1(EXTOp1),
    .WriteBackSrc(WriteBackSrc1),.PCSrc1(PCSrc1),.ShiftSrc1(ShiftSrc1),.mux_bhw(mux_bhw));
    
    //MUX
    wire [4:0]writeRegister;
    wire [4:0] reg_ra = 5'b11111;
    mux4_5 muxRegDst(.d0(Instruction[20:16]),.d1(Instruction[15:11]),.d2(reg_ra),.s(RegDst),.y(writeRegister));//5位 2选1
    
    //WriteBack MUX
    wire [31:0]PCPLUS4;
    wire [31:0]WriteData;
    wire [31:0] WriteDataFinal;
    wire WriteBackSrc2;
    wire WriteBackSrc;
    assign WriteBackSrc = WriteBackSrc1 | WriteBackSrc2;
    mux2 WriteBackMux(.d0(WriteData),.d1(PCPLUS4),.s(WriteBackSrc),.y(WriteDataFinal));

    //RF module
    wire [31:0]ReadData1;
    wire [31:0]ReadData2;
    RF my_RF(.clk(clk),.rst(rst),
    .RFWr(RegWrite),
    .A1(Instruction[25:21]),
    .A2(Instruction[20:16]),
    .A3(writeRegister),
    .WD(WriteDataFinal),.RD1(ReadData1),.RD2(ReadData2));//last 2 param

    //Sign-Extend 16-32
    wire [31:0] extended;
    EXT16 my_ext16(.Imm16(Instruction[15:0]),.EXTOp(EXTOp1),.Imm32(extended));

    //MUX R-lw,sw
    wire [31:0]ALUData2;
    mux4 muxALUSrc(.d0(ReadData2),.d1(extended),.d2(32'b0),.s(ALUSrc),.y(ALUData2));

    //ALUControl
    wire [3:0] ALU_Control;
    wire PCSrc2;
    wire ShiftSrc2;
    ALUControl my_alucontrol(.ALUOp(ALUOp),.Funct(Instruction[5:0]),.ALU_Control(ALU_Control),.PCSrc2(PCSrc2),.ShiftSrc(ShiftSrc2),.WriteBackSrc2(WriteBackSrc2));

    assign PCSrc = PCSrc1 & PCSrc2;

    //MUX ALUSrc1
    wire ShiftSrc;
    assign ShiftSrc = ShiftSrc1 & ShiftSrc2;
    wire [31:0] ReadDataF1;
    mux2 muxALUSrc1(.d0(ReadData1),.d1({27'b0,Instruction[10:6]}),.s(ShiftSrc),.y(ReadDataF1));

    //ALU
    wire Zero;
    alu my_alu(ReadDataF1,ALUData2,ALU_Control,ALUResult,Zero);

    //MUX branchsrc
    wire branchsrc_o;
    mux2_1 my_muxbranchsrc(.d0(Zero),.d1(ALUResult[0]),.s(BranchSrc),.y(branchsrc_o));

    //Not
    wire Not_o ;
    assign Not_o = (Not) ? (~branchsrc_o) : branchsrc_o;

    //NPC
    wire Branch1;
    assign Branch1 = Branch & Not_o;//与门 beq
    NPC my_NPC(.PC(o_PC),.Jump(Jump),.Branch(Branch1),.IMM(Instruction[25:0]),.NPC(i_PC),.PCPLUS4_o(PCPLUS4));
    
    //DM
    wire [31:0] MemData;//read data
    DM my_DM(.clk(clk),.MemR(MemRead),.MemWr(MemWrite),.MemWrBits(MemWrBits),.MemRBits(MemRBits),.addr(ALUResult),.data(ReadData2),.ReadData(MemData));
    
    //EXT8-32 for lb,lbu
    wire [31:0] MemData_8;
    EXT8 my_EXT8(.Imm8(MemData[7:0]),.EXTOp(EXTOp_b),.Imm32(MemData_8));

    //EXT16-32 for lh,lhu
    wire [31:0] MemData_16;
    EXT16 my_EXT16(.Imm16(MemData[15:0]),.EXTOp(EXTOp_h),.Imm32(MemData_16));
    
    //MUX 3to1
    wire [31:0] LoadData;
    mux4 my_mux4(.d0(MemData),.d1(MemData_8),.d2(MemData_16),.s(mux_bhw),.y(LoadData)); //3--1

    //MUX Mem2Reg
    mux2 Mem2Reg(.d0(ALUResult),.d1(LoadData),.s(MemtoReg),.y(WriteData));

endmodule

    