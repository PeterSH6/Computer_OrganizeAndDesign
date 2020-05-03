module DM(
    input MemR,
    input MemWr,
    input [31:0]addr,
    input [31:0]data,
    output [31:0]ReadData
);
    reg [31:0] Data_Memory [511:0];
    integer i;
	initial
		begin
		for(i = 0;i < 512;i = i + 1)
			Data_Memory[i] <= 0;
		end
    
    always@(*)
    begin
        if(MemWr)
            Data_Memory[addr>>2] = data;
    end

    assign ReadData = (MemR == 1)? Data_Memory[addr>>2] : 0;
endmodule