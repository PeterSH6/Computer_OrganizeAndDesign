module Adder_PCPlus4(PC_o,PCPlus4);
    input [31:0] PC_o;
	output reg [31:0] PCPlus4;
	
	always@(*)
		begin
		PCPlus4 = PC_o + 32'd4;
		end
endmodule