module IFIDReg(clk,rst,IFIDStall,IFIDFlush,PCPlus4_i,PCPlus4_o,Instruction_i,Instruction_o)
    input clk;
    input rst;
    input IFIDStall;
    input IFIDFlush;
    input [31:0] PCPlus4_i;
    input [31:0] Instruction_i;
    output reg [31:0] PCPlus4_o;
    output reg [31:0] Instruction_o;
    
    initial
    begin
        PCPlus4_o <= 32'b0;
        Instruction_o <= 32'b0;
    end

    always @(negedge clk)//在后半周期更新寄存器
    begin
        if(rst)
        begin
            PCPlus4_o <= 32'b0;
            Instruction_o <= 32'b0;
        end
        else if(!IFIDStall)
        begin
            if(IFIDFlush)
                begin
                    PCPlus4_o <= 32'b0;
                    Instruction_o <= 32'b0;
                end
            else
                begin
                    PCPlus4_o <= PCPlus4_i;
                    Instruction_o <= Instruction_i;
                end
        end
    end
endmodule