module JumpAddress(
    input [31:0] IDEXPCPlus4,
    input [31:0] IDEXInstruction,
    input [31:0] GPR_RS,
    input IDEXJumpSrc,
    output reg [31:0] JumpPC
);

always @(*)
begin
    if(IDEXJumpSrc == 0) //PC[31:28] + <<2 + 00
    begin
        JumpPC <= {IDEXPCPlus4[31:28],IDEXInstruction[25:0],2'b00};
    end
    else if(IDEXJumpSrc == 1) //GPR_RS
    begin
        JumpPC <= GPR_RS;
    end
end
endmodule