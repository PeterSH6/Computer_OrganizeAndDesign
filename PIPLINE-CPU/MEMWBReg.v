module MEMWBReg(
    input clk,
    input rst,
    input MEMWBStall,
    input MEMWBFlush,
    input [31:0] EXMEMInstruction,
    output reg [31:0] MEMWBInstruction,
    input [31:0] EXMEMPCPlus4,
    output reg [31:0] MEMWBPCPlus4,
    input [31:0] EXMEMALUResult,
    output reg [31:0] MEMWBALUResult,
    input [31:0] MemoryData,
    output reg [31:0] MEMWBMemoryData,
    input [4:0] EXMEMRegRd,
    output reg [4:0] MEMWBRegRd,
    input EXMEMRegWrite,
    output reg MEMWBRegWrite,
    input [1:0] EXMEMMemtoReg,
    output reg [1:0] MEMWBMemtoReg,
    input EXMEMMemRead,
    output reg MEMWBMemRead
);

initial
    begin
        MEMWBInstruction <= 32'b0;
        MEMWBPCPlus4  <= 32'b0;
        MEMWBALUResult  <= 32'b0;
        MEMWBMemoryData  <= 32'b0;
        MEMWBRegRd  <= 5'b0;
        MEMWBRegWrite  <= 1'b0;
        MEMWBMemtoReg  <= 2'b0;
        MEMWBMemRead <= 1'b0;
    end

always @(posedge clk)
    begin
        if(rst)
        begin
        MEMWBInstruction <= 32'b0;
        MEMWBPCPlus4  <= 32'b0;
        MEMWBALUResult  <= 32'b0;
        MEMWBMemoryData  <= 32'b0;
        MEMWBRegRd  <= 5'b0;
        MEMWBRegWrite  <= 1'b0;
        MEMWBMemtoReg  <= 2'b0;
        MEMWBMemRead <= 1'b0;
        end
        else if(!MEMWBStall)
        begin
            if(MEMWBFlush)
                begin
                    MEMWBInstruction <= 32'b0;
                    MEMWBPCPlus4  <= 32'b0;
                    MEMWBALUResult  <= 32'b0;
                    MEMWBMemoryData  <= 32'b0;
                    MEMWBRegRd  <= 5'b0;
                    MEMWBRegWrite  <= 1'b0;
                    MEMWBMemtoReg  <= 2'b0;
                    MEMWBMemRead <= 1'b0;
                end
            else
                begin
                    MEMWBInstruction <= EXMEMInstruction;
                    MEMWBPCPlus4 <= EXMEMPCPlus4;
                    MEMWBALUResult <= EXMEMALUResult;
                    MEMWBMemoryData <= MemoryData;
                    MEMWBRegRd <= EXMEMRegRd;
                    MEMWBRegWrite <= EXMEMRegWrite;
                    MEMWBMemtoReg <= EXMEMMemtoReg;
                    MEMWBMemRead <= EXMEMMemRead;
                end
        end
    end
endmodule