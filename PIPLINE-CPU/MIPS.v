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
    wire [1:0] PCSrc1;//通过Hazard Detect判定PC源
    wire [31:0] NPC_First;
    mux4 MUX_NPC1(.d0(PCPlus4),.d1(JumpPC),.d2(IDEXPCPlus4),.d3(BranchPC),.s(PCSrc1),.y(NPC_First));
    
    //MUX_NPC2
    wire [31:0] BranchPC;
    wire [31:0] NPC;
    wire PCSrc2;//通过Control判断源
    mux2 MUX_NPC2(.d0(NPC_First),.d1(BranchPC),.s(PCSrcHazard),.y(NPC));

    //PC module
    wire [31:0] PC_o;
    wire PCWrite;
    PC my_PC(.clk(clk),.rst(rst),.NPC(NPC),.PC(PC_o),.PC_Write_Final(PCWrite));

    //IM module
    wire [31:0] Instruction;
    IM my_IM(.PC(PC_o),.Instruction(Instruction));

   //PCAdder4
   Adder_PCPlus4 PCAdder4(.PC_o(PC_o),.PCPlus4(PCPlus4));

   //IFIDReg
   wire IFIDStall;
   wire IFIDFlush;
   wire [31:0] IFIDInstruction;
   wire [31:0] IFIDPCPlus4;
   IFIDReg IFIDReg(.clk(clk),.rst(rst),.IFIDStall(IFIDStall),.IFIDFlush(IFIDFlush),.PCPlus4_i(PC_o),.Instruction_i(Instruction_i),.PCPlus4_o(IFIDPCPlus4),.IFIDInstruction(IFIDInstruction));


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
    BranchAdd BranchAdd(.PCPlus4(IFIDPCPlus4),.SignEXTOffset(SignEXTOffset),.BranchPC(BranchPC));

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
    wire JumpSrc;//用于JumpAddress中选择相应的JumpPC
    Control Control(.clk(clk),.rst(rst),.OP(IFIDInstruction[31:26])
    ,.Funct(IFIDInstruction[5:0]),.Rs(IFIDInstruction[25:21]),.Rt(IFIDInstruction[20:16]),
    .PCSrc(PCSrc2),NPCType(NPCType),.JumpSrc(JumpSrc),
    .RegDst(RegDst),.MemRead(MemR),.MemtoReg(MemtoReg),.ALUOp(ALUOp),
    .MemWrite(MemWr),.ALUSrc_A(Sig_ALUSrcA),.ALUSrc_B(Sig_ALUSrcB),
    .RegWrite(IDEXRegWrite),.MemWrBits(MemWrBits),.MemRBits(MemRBits));


    //Hazard Detect
    wire [1:0] NextType;//从BranchJump检测unit中检测
    wire [31:0] IDEXIntruction;
    Hazard_Detect Hazard_Detect(.NextType(NextType),.IDEXMEMRead(MemR),.IDEXRt(IDEXIntruction[20:16])
    ,.IFIDRs(IFIDInstruction[25:21]),.IFIDRt(IFIDInstruction[20:16]),.IFIDStall(IFIDStall),.IFIDFlush(IFIDFlush)
    ,.PCSrc(PCSrc1),.PCWrite(PCWrite),.IDEXFlush(IDEXFlush));

    //IDEXReg
    wire IDEXStall;
    assign IDEXStall = 1'b0;
    wire [31:0] IDEXRD1;
    wire [31:0] IDEXRD2;
    wire [1:0] IDEXALUSrc_A <= 2'b0;
    wire [1:0] IDEXALUSrc_B <= 2'b0;
    wire IDEXSignEXT <= 1'b0;
    wire IDEXRegWrite <= 1'b0;
    wire [31:0] IDEXPCPlus4 <= 32'b0;
    wire [1:0] IDEXNPCType<= 2'b0;
    wire IDEXMemWrite <= 1'b0;
    wire [1:0] IDEXMemWrBits <= 2'b0;
    wire [1:0] IDEXMemtoReg <= 2'b0;
    wire IDEXMemRead <= 1'b0;
    wire [2:0] IDEXMemRBits <= 3'b0;
    wire IDEXJumpSrc <= 1'b0;
    wire [31:0] IDEXInstruction <= 32'b0;
    wire [4:0] IDEXALUOp <= 5'b0;
    wire [4:0] IDEXRegRd  <= 5'b0;
    IDEXReg IDEXReg(.clk(clk),.rst(rst),.IDEXStall(IDEXStall),.IDEXFlush(IDEXFlush),.RD1_i(ReadData1),.IDEXRD1(IDEXRD1),.RD2_i(ReadData2),.IDEXRD2(IDEXRD2)
    ,.PCPlus4_i(IFIDPCPlus4),.IDEXPCPlus4(IDEXPCPlus4),.SignEXT_i(SignEXTOffset),.IDEXSignEXT(IDEXSignEXT),.Instruction(IFIDInstruction),.IDEXInstruction(IDEXInstruction)
    ,.WriteBackDst(RegDstIn),.IDEXRegRd(IDEXRegRd),.RegWrite(RegWrite),.IDEXRegWrite(IDEXRegWrite)
    ,.ALUOp(ALUOp),.IDEXALUOp(IDEXALUOp),.MemRead(IDEXMemRead),.MemWrite(IDEXMemWrite),.NPCType(IDEXNPCType)
    ,.MemRBits(IDEXMemRBits),.MemWrBits(IDEXMemWrBits),MemtoReg(IDEXMemtoReg),.ALUSrc_A(IDEXALUSrc_A),.ALUSrc_B(IDEXALUSrc_B),.JumpSrc(JumpSrc),.IDEXJumpSrc(IDEXJumpSrc));


//------------------------EX Stage--------------------------
    //MUX_ForwardA
    wire [1:0] ForwardA;
    wire  [31:0] ALUSrcA_First;
    wire [31:0] EXMEMALUResult;
    mux4 MUX_ForwardA(.d0(IDEXRD1),.d1(WriteDataFinal),.d2(EXMEMALUResult),.s(ForwardA),.y(ALUSrcA_First));

    //MUX_ALUSrcA
    wire [31:0] ALUSrcAData;
    mux2 MUX_ALUSrcA(.d0(ALUSrcA_First),.d1(IDEXInstruction[10:6]).s(IDEXALUSrc_A),.y(ALUSrcAData));

    //JumpAddress unit
    //ALUSrcA_First为Forward后的结果，可以解决jalr，jr中使用rs的数据冒险问题
   JumpAddress JumpAddress(.IDEXPCPlus4(IDEXPCPlus4),.IDEXInstruction(IDEXInstruction),.GPR_RS(ALUSrcA_First),.IDEXJumpSrc(IDEXJumpSrc),.JumpPC(JumpPC));

    //MUX_ForwardB
    wire [1:0] ForwardB;
    wire [31:0] ALUSrcB_First;
    mux4 MUX_ForwardB(.d0(IDEXRD2),.d1(WriteDataFinal),.d2(EXMEMALUResult),.s(ForwardB),.y(ALUSrcB_First));

    //MUX_ALUSrcB
    wire [31:0] ALUSrcBData;
    mux2 MUX_ALUSrcB(.d0(ALUSrcB_First),.d1(SignEXTOffset),.s(IDEXALUSrc_B),.y(ALUSrcBData));

    //ALU
    wire Zero;
    wire [31:0] ALUResult;
    alu ALU(.A(ALUSrcAData),.B(ALUSrcBData),.ALUOp(IDEXALUOp),.C(ALUResult),.Zero(Zero));

    //Branch_Jump_Detect
    //NextType在HazardDetect中最后生成所需要的PCSrc1信号用作选择
    Branch_Jump_Detect Branch_Jump_Detect(.NPCType(IDEXNPCType),.Zero(Zero),.NextType(NextType));

    //ForwardUnit
    wire EXMEMRegWrite;
    wire [4:0] EXMEMRegRd;
    wire [4:0] MEMWBRegRd;
    ForwardUnit ForwardUnit(.EXMEMRegWrite(EXMEMRegWrite),.EXMEMRegRd(EXMEMRegRd),.IDEXRegRs(IDEXInstruction[25:21])
    ,.IDEXRegRt(IDEXInstruction[20:16]),.MEMWBRegWrite(MEMWBRegWrite),.MEMWBRegRd(MEMWBRegRd)
    .ForwardA(ForwardA),.ForwardB(ForwardB));

    //EXMEMReg
    wire EXMEMStall;
    assign EXMEMStall = 1'b0;
    wire EXMEMFlush;
    assign EXMEMFlush = 1'b0;
    wire [31:0] EXMEMInstruction;
    wire [31:0] EXMEMPCPlus4;
    wire [31:0] EXMEMMemWriteData;
    wire EXMEMMemWrite;
    wire EXMEMMemWrBits;
    wire EXMEMMemRead;
    wire [1:0] EXMEMMemRBits;
    wire [1:0] EXMEMMemtoReg;
    EXMEMReg EXMEMReg(
     .clk(clk),
     .rst(rst),
     .EXMEMStall(EXMEMStall),
     .EXMEMFlush(EXMEMFlush),
     .IDEXInstruction(IDEXInstruction),
     .EXMEMInstruction(EXMEMInstruction),
     .IDEXPCPlus4(IDEXPCPlus4),
     .EXMEMPCPlus4(EXMEMPCPlus4),
     .IDEXMemWriteData(ALUSrcB_First), //store value
     .EXMEMMemWriteData(EXMEMMemWriteData),
     .ALUResult(ALUResult),
     .EXMEMALUResult(EXMEMALUResult),
     .IDEXRegRd(IDEXRegRd),
     .EXMEMRegRd(EXMEMRegRd),
     .IDEXRegWrite(IDEXRegWrite),
     .EXMEMRegWrite(EXMEMRegWrite),
     .IDEXMemWrite(IDEXMemWrite),
     .EXMEMMemWrite(EXMEMMemWrite),
     .IDEXMemWrBits(IDEXMemWrBits),
     .EXMEMMemWrBits(EXMEMMemWrBits),
     .IDEXMemRead(IDEXMemRead),
     .EXMEMMemRead(EXMEMMemRead),
     .IDEXMemRBits(IDEXMemRBits),
     .EXMEMMemRBits(EXMEMMemRBits),
     .IDEXMemtoReg(IDEXMemtoReg),
     .EXMEMMemtoReg(EXMEMMemtoReg)
    );

    //-------------------MEM Stage-------------------------------

    //DataMemory
    wire [31:0] EXMEMMemReadData;
    DM DM(.clk(clk),.MemR(EXMEMMemRead),.MemWr(EXMEMMemWrite),.MemWrBits(EXMEMMemWrBits),.MemRBits(EXMEMMemRBits)
    ,.addr(EXMEMALUResult),.data(EXMEMMemWriteData),.ReadData(EXMEMMemReadData));

    //MEMWBReg
    wire MEMWBStall;
    assign MEMWBStall = 1'b0;
    wire MEMWBFlush;
    assign MEMWBFlush = 1'b0;
    wire [31:0] MEMWBInstruction;
    wire [31:0] MEMWBPCPlus4;
    wire [31:0] MEMWBALUResult;
    wire [31:0] MEMWBMemoryData;
    wire [1:0] MEMWBMemtoReg;
    MEMWBReg MEMWBReg(.clk(clk),.rst(rst),.MEMWBStall(MEMWBStall),.MEMWBFlush(MEMWBFlush),.EXMEMInstruction(EXMEMInstruction)
    ,.MEMWBInstruction(MEMWBInstruction),.EXMEMPCPlus4(EXMEMPCPlus4),.MEMWBPCPlus4(MEMWBPCPlus4),.EXMEMALUResult(EXMEMALUResult)
    ,.MEMWBALUResult(MEMWBALUResult),.MemoryData(EXMEMMemReadData),.MEMWBMemoryData(MEMWBMemoryData),.EXMEMRegRd(EXMEMRegRd)
    ,.MEMWBRegRd(MEMWBRegRd),.EXMEMRegWrite(EXMEMRegWrite),.MEMWBRegWrite(MEMWBRegWrite),.EXMEMMemtoReg(EXMEMMemtoReg),.MEMWBMemtoReg(MEMWBMemtoReg));

    //--------------------------WB Stage---------------------------------




endmodule

    