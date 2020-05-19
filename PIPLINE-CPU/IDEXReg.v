module IDEXReg(
    input clk,
    input rst,
    input IDEXStall,
    input IDEXFlush,
    input [31:0] RD1_i,
    output reg [31:0] IDEXRD1,
    input [31:0] RD2_i,
    output reg [31:0] IDEXRD2,
    input [31:0] PCPlus4_i,
    output reg [31:0] IDEXPCPlus4,
    input [31:0] SignEXT_i,
    output reg [31:0] IDEXSignEXT,
    input [31:0] Instruction,
    output reg [31:0] IDEXInstruction,
    input [4:0] WriteBackDst,//根据选择器所选择的Rd，Rt，31来存储
    output reg [4:0] IDEXRegRd,
    input RegWrite,
    output reg IDEXRegWrite,
    input [4:0] ALUOp,
    output reg [4:0] IDEXALUOp,
    input MemRead,
    output reg IDEXMemRead,
    input MemWrite,
    output reg IDEXMemWrite,
    input [1:0] NPCType,
    output reg [1:0] IDEXNPCType,
    input [2:0] MemRBits,
    output reg [2:0] IDEXMemRBits,
    input [1:0] MemWrBits,
    output reg [1:0] IDEXMemWrBits,
    input [1:0] MemtoReg,
    output reg [1:0] IDEXMemtoReg,
    input [1:0] ALUSrc_A,
    output reg [1:0] IDEXALUSrc_A,
    input [1:0] ALUSrc_B,
    output reg [1:0] IDEXALUSrc_B,
    input JumpSrc,
    output reg IDEXJumpSrc    
);

initial
begin
    IDEXALUSrc_A <= 2'b0;
    IDEXALUSrc_B <= 2'b0;
    IDEXSignEXT <= 1'b0;
    IDEXRegWrite <= 1'b0;
    IDEXRD2 <= 32'b0;
    IDEXRD1 <= 32'b0;
    IDEXPCPlus4 <= 32'b0;
    IDEXNPCType<= 2'b0;
    IDEXMemWrite <= 1'b0;
    IDEXMemWrBits <= 2'b0;
    IDEXMemtoReg <= 2'b0;
    IDEXMemRead <= 1'b0;
    IDEXMemRBits <= 3'b0;
    IDEXJumpSrc <= 1'b0;
    IDEXInstruction <= 32'b0;
    IDEXALUOp <= 5'b0;
    IDEXRegRd  <= 5'b0;
end

always @(posedge clk)
begin
    if(rst)
    begin
        IDEXALUSrc_A <= 2'b0;
        IDEXALUSrc_B <= 2'b0;
        IDEXSignEXT <= 1'b0;
        IDEXRegWrite <= 1'b0;
        IDEXRD2 <= 32'b0;
        IDEXRD1 <= 32'b0;
        IDEXPCPlus4 <= 32'b0;
        IDEXNPCType<= 2'b0;
        IDEXMemWrite <= 1'b0;
        IDEXMemWrBits <= 2'b0;
        IDEXMemtoReg <= 2'b0;
        IDEXMemRead <= 1'b0;
        IDEXMemRBits <= 3'b0;
        IDEXJumpSrc <= 1'b0;
        IDEXInstruction <= 32'b0;
        IDEXALUOp <= 5'b0;
        IDEXRegRd  <= 5'b0;
    end
    else if(!IDEXStall)
    begin
        if(IDEXFlush)
        begin
            IDEXALUSrc_A <= 2'b0;
            IDEXALUSrc_B <= 2'b0;
            IDEXSignEXT <= 1'b0;
            IDEXRegWrite <= 1'b0;
            IDEXRD2 <= 32'b0;
            IDEXRD1 <= 32'b0;
            IDEXPCPlus4 <= 32'b0;
            IDEXNPCType<= 2'b0;
            IDEXMemWrite <= 1'b0;
            IDEXMemWrBits <= 2'b0;
            IDEXMemtoReg <= 2'b0;
            IDEXMemRead <= 1'b0;
            IDEXMemRBits <= 3'b0;
            IDEXJumpSrc <= 1'b0;
            IDEXInstruction <= 32'b0;
            IDEXALUOp <= 5'b0;
            IDEXRegRd  <= 5'b0;
        end
        else
        begin
            IDEXALUSrc_A <= ALUSrc_A;
            IDEXALUSrc_B <= ALUSrc_B;
            IDEXSignEXT <= SignEXT_i;
            IDEXRegWrite <= RegWrite;
            IDEXRD2 <= RD2_i;
            IDEXRD1 <= RD1_i;
            IDEXPCPlus4 <= PCPlus4_i;
            IDEXNPCType<= NPCType;
            IDEXMemWrite <= MemWrite;
            IDEXMemWrBits <= MemWrBits;
            IDEXMemtoReg <= MemtoReg;
            IDEXMemRead <= MemRead;
            IDEXMemRBits <= MemRBits;
            IDEXJumpSrc <= JumpSrc;
            IDEXInstruction <= Instruction;
            IDEXALUOp <= ALUOp;
            IDEXRegRd  <= WriteBackDst;
        end
    end
end
endmodule