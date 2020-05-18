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
    
//-------------------------IF Stage-----------------------------
    //MUX_NPC
    wire [31:0] PCPlus4;
    wire [31:0] JumpPC;
    wire [31:0] IDEXPCPlus4; //预测错误，需要branch下一条指令
    wire [1:0] PCSrcControl;//通过Control判定PC源
    wire [31:0] NPC_First;
    mux4 MUX_NPC1(.d0(PCPlus4),.d1(JumpPC),.d2(IDEXPCPlus4),.d3(BranchPC),.s(PCSrcControl),.y(NPC_First));
    
    //MUX_NPC2
    wire [31:0] BranchPC;
    wire [31:0] NPC;
    wire PCSrcHazard;//通过HazardDetection判断源
    mux2 MUX_NPC2(.d0(NPC_First),.d1(BranchPC),.s(PCSrcHazard),.y(NPC));

    //PC module
    wire [31:0] PC_o;
    wire PC_Write_Final;
    PC my_PC(.clk(clk),.rst(rst),.NPC(NPC),.PC(PC_o),.PC_Write_Final(PC_Write_Final));

    //IM module
    wire [31:0] Instruction;
    IM my_IM(.PC(PC_o),.Instruction(Instruction));

   //PCAdder4
   Adder_PCPlus4 PCAdder4(.PC_o(PC_o),.PCPlus4(PCPlus4));

   //IFIDReg
   wire IFIDStall;
   wire IFIDFlush;
   wire [31:0] IFIDInstruction;
   wire [31:0] PCPlus4_o;
   IFIDReg IFIDReg(.clk(clk),.rst(rst),.IFIDStall(IFIDStall),.IFIDFlush(IFIDFlush),.PCPlus4_i(PC_o),.Instruction_i(Instruction_i),.PCPlus4_o(PCPlus4_o),.IFIDInstruction(IFIDInstruction));


//-------------------------ID Stage-----------------------------
    //RF
    wire [4:0] writeRegister; //从MEM/WB中返回
    wire [31:0]WriteDataFinal; //从MEM/WB中返回，ALUResult或者Load
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire MEMWBRegWrite;//从MEM/WB中返回
     RF my_RF(.clk(clk),.rst(rst),
    .RFWr(MEMWBRegWrite),
    .A1(IFIDInstruction[25:21]),
    .A2(IFIDInstruction[20:16]),
    .A3(writeRegister),
    .WD(WriteDataFinal),.RD1(ReadData1),.RD2(ReadData2));

    //MUX_RegDst;
    wire [1:0] RegDst;//Control
    wire [4:0] RegDstIn;
    mux4 MUX_RegDst(.d0(IFIDInstruction[20:16],.d1(IFIDInstruction[15:11]),.d2(5'b11111),.s(RegDst),.y(RegDstIn)));

    //SignExt
    wire [31:0] SignEXTOffset;
    EXT16 EXTOffset(.Imm16(IFIDInstruction[15:0]),.EXTOp(1'b1),.Imm32(SignEXTOffset));

    //BranchAdd
    BranchAdd BranchAdd(.PCPlus4(PCPlus4_o),.SignEXTOffset(SignEXTOffset),.BranchPC(BranchPC));

    //Control
    wire MemR;
    wire [1:0] MemtoReg;
    wire [4:0] ALUOp;
    wire MemWr;
    wire [1:0] Sig_ALUSrcA;
    wire [1:0] Sig_ALUSrcB;
    wire IDEXRegWrite; //传到WB后再传回来
    wire [2:0] MemWrBits;
    wire [1:0] MemRBits;
    wire [1:0] NPCType;//传给EX中的Branch判断单元来进行判定。
    Control Control(.clk(clk),.rst(rst),.OP(Instruction_o[31:26])
    ,.Funct(Instruction_o[5:0]),.Rs(Instruction_o[25:21]),.Rt(Instruction_o[20:16]),
    .PCSrc(NPC_First),NPCType(NPCType),
    .RegDst(RegDst),.MemRead(MemR),.MemtoReg(MemtoReg),.ALUOp(ALUOp),
    .MemWrite(MemWr),.ALUSrc_A(Sig_ALUSrcA),.ALUSrc_B(Sig_ALUSrcB),
    .RegWrite(IDEXRegWrite),.MemWrBits(MemWrBits),.MemRBits(MemRBits));


    //Hazard Detect
    





//------------------------EX Stage--------------------------
   
    
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

    