`include "ctrl_encode_def.v"
module DM(
    input clk,
    input MemR,
    input MemWr,
    input [1:0] MemWrBits,
    input [2:0] MemRBits,
    input [31:0]addr,
    input [31:0]data,
    output reg [31:0]ReadData
);
    reg [31:0] Data_Memory [511:0];
    integer i;
	initial
		begin
		for(i = 0;i < 512;i = i + 1)
			Data_Memory[i] <= 0;
		end
    
    always@(negedge clk)
    begin
        if(MemWr == 1)
            begin
            case(MemWrBits)
                2'b00: //sw
                    begin
                    Data_Memory[addr>>2] = data; 
                    end
                2'b01: //sh
                    begin
                    if(~addr[1])
                        Data_Memory[addr>>2][15:0] = data[15:0];
                    else if(addr[1])
                        Data_Memory[addr>>2][31:16] = data[15:0];
                    end
                2'b10: //sb
                    begin
                    if(~addr[1]&~addr[0])
                    Data_Memory[addr>>2][7:0] = data[7:0]; 
                    else if(~addr[1]&addr[0])
                    Data_Memory[addr>>2][15:8] = data[7:0];
                    else if(addr[1]&~addr[0])
                    Data_Memory[addr>>2][23:16] = data[7:0]; 
                    else if(addr[1]&addr[0])
                    Data_Memory[addr>>2][31:24] = data[7:0];  
                    end           
            endcase
            end
    end
    always@(*)
    begin
    case(MemRBits)
        `MemR_lw:
            begin
            ReadData <= (MemR == 1)? Data_Memory[addr>>2] : 0;
            end
        `MemR_lhu: //lhu
            begin
            if(~addr[1] & ~addr[0])
                ReadData <= (MemR == 1)? {16'b0,Data_Memory[addr>>2][15:0]} : 0;
            else if(addr[1] & ~addr[0])
                ReadData <= (MemR == 1)? {16'b0,Data_Memory[addr>>2][31:16]} :0; 
            end
        `MemR_lh: //lh
            begin
            if(~addr[1] & ~addr[0])
                ReadData <= (MemR == 1)? {{16{Data_Memory[addr>>2][15]}},Data_Memory[addr>>2][15:0]} : 0;
            else if(addr[1] & ~addr[0])
                ReadData <= (MemR == 1)? {{16{Data_Memory[addr>>2][31]}},Data_Memory[addr>>2][31:16]} :0; 
            end
        `MemR_lbu: //lbu
            begin
            if(~addr[1]&~addr[0]) 
                ReadData <= (MemR == 1)? {24'b0,Data_Memory[addr>>2][7:0]} : 0;    
            else if(~addr[1]&addr[0]) 
                ReadData <= (MemR == 1)? {24'b0,Data_Memory[addr>>2][15:8]} : 0; 
            else if(addr[1]&~addr[0]) 
                ReadData <= (MemR == 1)? {24'b0,Data_Memory[addr>>2][23:16]} : 0;
            else if(addr[1]&addr[0]) 
                ReadData <= (MemR == 1)? {24'b0,Data_Memory[addr>>2][31:24]} : 0;    
            end
        `MemR_lb: //lb
            begin
            if(~addr[1]&~addr[0]) 
                ReadData <= (MemR == 1)? {{24{Data_Memory[addr>>2][7]}},Data_Memory[addr>>2][7:0]} : 0;    
            else if(~addr[1]&addr[0]) 
                ReadData <= (MemR == 1)? {{24{Data_Memory[addr>>2][15]}},Data_Memory[addr>>2][15:8]} : 0; 
            else if(addr[1]&~addr[0]) 
                ReadData <= (MemR == 1)? {{24{Data_Memory[addr>>2][23]}},Data_Memory[addr>>2][23:16]} : 0;
            else if(addr[1]&addr[0]) 
                ReadData <= (MemR == 1)? {{24{Data_Memory[addr>>2][31]}},Data_Memory[addr>>2][31:24]} : 0;    
            end
    endcase
    end
endmodule