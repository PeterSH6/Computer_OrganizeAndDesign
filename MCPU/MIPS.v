`include "alu.v"
`include "ctrl_encode_def.v"
`include "EXT.v"
`include "mux.v"
`include "PC.v"
`include "RF.v"
`include "IM.v"
`include "DM.v"
`include "Control.v"
`include "Register.v"

module MIPS(clk,rst);
    input clk;
    input rst;
    
    //PC module OK
    wire [31:0] PC_i; 
    wire [31:0] PC_o;
    wire PC_Write_Final;
    PC my_PC(.clk(clk),.rst(rst),.NPC(PC_i),.PC(PC_o),.PC_Write_Final(PC_Write_Final));

    //IM module OK
    wire [31:0] Instruction;
    IM my_IM(.PC(PC_o),.Instruction(Instruction));

    //Instruction Regsiter OK
    wire IRWrite;
    wire [31:0] Instr_o;
    Register InstrReg(.clk(clk),.WriteSignal(IRWrite),.in(Instruction),.out(Instr_o));

    //MUX RegSrc OK
    wire [4:0]writeRegister;//写回寄存器号数
    wire [4:0] reg_ra = 5'b11111;//31号寄存器
    wire [1:0] RegDst;
    mux4_5 muxRegDst(.d0(Instr_o[20:16]),.d1(Instr_o[15:11]),.d2(reg_ra),.s(RegDst),.y(writeRegister));//5位 3选1

    //RF module OK
    wire RegWrite;
    wire [31:0]ReadData1;
    wire [31:0]ReadData2;
    wire [31:0]WriteDataFinal;
    RF my_RF(.clk(clk),.rst(rst),
    .RFWr(RegWrite),
    .A1(Instr_o[25:21]),
    .A2(Instr_o[20:16]),
    .A3(writeRegister),
    .WD(WriteDataFinal),.RD1(ReadData1),.RD2(ReadData2));//last 2 param
    
    //RegisterA OK
    wire [31:0] RegA_o;
    Register  RegA(.clk(clk),.WriteSignal(1'b1),.in(ReadData1),.out(RegA_o));
    
    //RegisterB OK
    wire [31:0] RegB_o;
    Register  RegB(.clk(clk),.WriteSignal(1'b1),.in(ReadData2),.out(RegB_o));

    //MUX ALUSrcA OK
    wire [1:0] Sig_ALUSrcA;
    wire [31:0] ALUSrcA;
    mux4 MUX_ALUSrcA(.d0(RegA_o),.d1(PC_o),.d2({27'b0,Instr_o[10:6]}),.s(Sig_ALUSrcA),.y(ALUSrcA));

    //EXT16 Instr[15:0] -> 31:0 SignEXT OK
    wire [31:0] Instr_32;
    EXT16 my_EXT(.Imm16(Instr_o[15:0]),.EXTOp(1'b1),.Imm32(Instr_32));

    //MUX ALUSrcB OK
    wire [1:0] Sig_ALUSrcB;
    wire [31:0] ALUSrcB;
    mux4 MUX_ALUSrcB(.d0(RegB_o),.d1(32'd4),.d2(Instr_32),.d3(Instr_32 << 2),.s(Sig_ALUSrcB),.y(ALUSrcB));

    //ALU OK
    wire [4:0] ALUOp;
    wire [31:0] ALUResult;
    wire zero;
    alu ALU(.A(ALUSrcA),.B(ALUSrcB),.ALUOp(ALUOp),.C(ALUResult),.Zero(zero));

    //ALUOut OK
    wire [31:0] ALUOut_o;
    Register ALUOut(.clk(clk),.WriteSignal(1'b1),.in(ALUResult),.out(ALUOut_o));

    //DM OK
    wire MemR;
    wire MemWr;
    wire [1:0] MemWrBits;
    wire [2:0] MemRBits;
    wire [31:0]ReadData;
    DM DataMemory(.clk(clk),.MemR(MemR),.MemWr(MemWr),.MemWrBits(MemWrBits),.MemRBits(MemRBits),.addr(ALUOut_o),.data(RegB_o),.ReadData(ReadData)); //从b寄存器中直接读

    //MemData Register OK
    wire [31:0] MemData_o;
    Register MemDataReg(.clk(clk),.WriteSignal(1'b1),.in(ReadData),.out(MemData_o));

    //WriteBack MUX OK
    wire [1:0] MemtoReg;
    mux4 MUX_WriteBack(.d0(MemData_o),.d1(ALUOut_o),.d2(PC_o),.s(MemtoReg),.y(WriteDataFinal));

    //MUX PCSrc
    wire [1:0] PCSrc;
    mux4 MUX_PCSrc(.d1(ALUOut_o),.d0(ALUResult)
    ,.d2({PC_o[31:28],Instr_o[25:0],2'b00}) //此处Instr_o不用右移动
    ,.d3(RegA_o),.s(PCSrc),.y(PC_i));

    //Control
    wire PCWrite;
    wire PCWriteCond;
    Control my_Control(.clk(clk),.rst(rst),.OP(Instr_o[31:26])
    ,.Funct(Instr_o[5:0]),.Rt(Instr_o[20:16]),.PCWrite(PCWrite),
    .PCWriteCond(PCWriteCond),.PCSrc(PCSrc),.IRWrite(IRWrite),
    .RegDst(RegDst),.MemRead(MemR),.MemtoReg(MemtoReg),.ALUOp(ALUOp),
    .MemWrite(MemWr),.ALUSrc_A(Sig_ALUSrcA),.ALUSrc_B(Sig_ALUSrcB),
    .RegWrite(RegWrite),.MemWrBits(MemWrBits),.MemRBits(MemRBits));

    //PCFinal
    assign PC_Write_Final = PCWrite | (PCWriteCond & zero);


endmodule

    