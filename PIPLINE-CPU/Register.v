module Register(clk,WriteSignal,in,out);//有Write就要有clk
    input clk;
    input WriteSignal;
    input[31:0] in;
    output reg [31:0] out;

    always@(negedge clk)//阶段中间的寄存器应为后半周期写入
        begin
            out <= (WriteSignal == 1) ? in : out;
        end
endmodule