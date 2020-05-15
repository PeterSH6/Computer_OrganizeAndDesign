module PC( clk, rst, NPC, PC, PC_Write_Final );

  input              clk;
  input              rst;
  input             PC_Write_Final;
  input       [31:0] NPC;
  output reg  [31:0] PC;

  initial
    begin
      PC <= 32'h0000_0000;
    end

  always @(negedge clk, posedge rst)
    begin
    if (rst) 
      PC <= 32'h0000_0000;
    else
      begin
        if(PC_Write_Final)
          PC <= NPC;
        else
          PC <= PC;
      end
    end
      
endmodule

