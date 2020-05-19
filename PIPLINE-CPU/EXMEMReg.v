module EXMEMReg(
    input clk,
    input rst,
    input EXMEMStall,
    input EXMEMFlush,
    input [31:0] IDEXInstruction,
    output reg [31:0] EXMEMInstruction,
    input [31:0] IDEXPCPlus4,
    output reg [31:0] EXMEMPCPlus4,
    input [31:0] IDEXMemWriteData,
    output reg [31:0] EXMEMMemWriteData,
    input [31:0] ALUResult,
    output reg [31:0] EXMEMALUResult,
    input [4:0] IDEXRegRd,
    output reg [4:0] EXMEMRegRd,
    input IDEXRegWrite,
    output reg EXMEMRegWrite,
    input IDEXMemWrite,
    output reg EXMEMMemWrite,
    input [1:0] IDEXMemWrBits,
    output reg [1:0] EXMEMMemWrBits,
    input IDEXMemRead,
    output reg EXMEMMemRead,
    input [2:0] IDEXMemRBits,
    output reg [2:0] EXMEMMemRBits,
    input [1:0] IDEXMemtoReg,
    output reg [1:0] EXMEMMemtoReg
    );

initial
    begin
        EXMEMRegWrite <= 1'b0;
        EXMEMRegRd <= 5'b0;
        EXMEMPCPlus4 <= 32'b0;
        EXMEMMemWriteData <= 32'b0;
        EXMEMMemWrite<= 1'b0;
        EXMEMMemWrBits<= 2'b0;
        EXMEMMemtoReg<= 2'b0;
        EXMEMMemRead<= 1'b0;
        EXMEMMemRBits<= 3'b0;
        EXMEMInstruction<= 32'b0;
        EXMEMALUResult<= 32'b0;
    end

always @(posedge clk)
    begin
        if(rst)
        begin
        EXMEMRegWrite <= 1'b0;
        EXMEMRegRd <= 5'b0;
        EXMEMPCPlus4 <= 32'b0;
        EXMEMMemWriteData <= 32'b0;
        EXMEMMemWrite<= 1'b0;
        EXMEMMemWrBits<= 2'b0;
        EXMEMMemtoReg<= 2'b0;
        EXMEMMemRead<= 1'b0;
        EXMEMMemRBits<= 3'b0;
        EXMEMInstruction<= 32'b0;
        EXMEMALUResult<= 32'b0;
        end
        else if(!EXMEMStall)
            begin
                if(EXMEMFlush)
                    begin
                        EXMEMRegWrite <= 1'b0;
                        EXMEMRegRd <= 5'b0;
                        EXMEMPCPlus4 <= 32'b0;
                        EXMEMMemWriteData <= 32'b0;
                        EXMEMMemWrite<= 1'b0;
                        EXMEMMemWrBits<= 2'b0;
                        EXMEMMemtoReg<= 2'b0;
                        EXMEMMemRead<= 1'b0;
                        EXMEMMemRBits<= 3'b0;
                        EXMEMInstruction<= 32'b0;
                        EXMEMALUResult<= 32'b0;
                    end
                else
                    begin
                        EXMEMRegWrite <= IDEXRegWrite;
                        EXMEMRegRd <= IDEXRegRd;
                        EXMEMPCPlus4 <= IDEXPCPlus4;
                        EXMEMMemWriteData <= IDEXMemWriteData;
                        EXMEMMemWrite<= IDEXMemWrite;
                        EXMEMMemWrBits<= IDEXMemWrBits;
                        EXMEMMemtoReg<= IDEXMemtoReg;
                        EXMEMMemRead<= IDEXMemRead;
                        EXMEMMemRBits<= IDEXMemRBits;
                        EXMEMInstruction<= IDEXInstruction;
                        EXMEMALUResult<= ALUResult;
                    end
            end
    end


endmodule