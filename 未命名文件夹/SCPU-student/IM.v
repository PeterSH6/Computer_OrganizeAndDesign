module IM(
    input [31:0]PC,
    output reg[31:0] Instruction
);
    reg[31:0] Instruction_Memory[255:0];
    always@(*)
    begin
        assign Instruction = Instruction_Memory[PC>>2];
    end
endmodule