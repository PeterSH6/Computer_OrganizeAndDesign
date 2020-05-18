module(
    input [31:0] PCPlus4,
    input [31:0] SignEXTOffset,
    output [31:0] BranchPC
)

always@(*)
		begin
		BranchPC = PCPlus4 + (SignEXTOffset << 2);
		end
endmodule
