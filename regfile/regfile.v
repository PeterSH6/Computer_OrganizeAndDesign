module regfile(
    input clock,
    input reset,
    input RegWrite,
    input [4:0] WriteReg,
    input [4:0] Read1,
    input [4:0] Read2,
    input [31:0] WriteData,
    output [31:0] Data1,
    output [31:0] Data2
);
    reg [31:0] registers[31:0];
    integer i;
    assign Data1 = registers[Read1];
    assign Data2 = registers[Read2];

    always @(posedge clock or negedge reset)
        begin
            if(!reset)
				for(i = 0;i <= 31;i = i + 1)
					registers[i] <= 32'd0;
            else
                begin
                if(RegWrite)
                    registers[WriteReg] <= (WriteReg != 0) ? WriteData : 32'd0;
                end   
        end
endmodule

module multiplexer(
    input [1:0] sig,
    input [31:0] i_1,
    input [31:0] i_2,
    input [31:0] i_3,
    input [31:0] i_4,
    output [31:0] out 
);
    reg[31:0] out_temp;

always @(sig)
    begin
        case(sig)
        2'b00 : out_temp = i_1;
        2'b01 : out_temp = i_2;
        2'b10 : out_temp = i_3;
        2'b11 : out_temp = i_4;
        endcase
    end
    assign out = out_temp;
endmodule
        
